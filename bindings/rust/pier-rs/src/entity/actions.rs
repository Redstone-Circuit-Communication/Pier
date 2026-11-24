//! Actor actions: the `PIER_AACT_*` family.
//!
//! They share one multiplexed slot, `actor_action`, and therefore share the same failure
//! modes: the actor is gone, an argument is invalid, or the host does not recognize the
//! action number.

use crate::entity::Entity;
use crate::rt::error::{Error, Result};
use crate::rt::ffi::{call_out_str, s};
use crate::sys;

impl Entity {
    // Actions

    /// Runs one `PIER_AACT_*` action and returns its output, which is an empty string for most
    /// actions.
    pub fn act(&self, action: i32, sarg: &str, a: f64, b: f64, c: f64) -> Result<String> {
        let f = crate::require_slot!(actor_action, "running an actor action");
        call_out_str(|ctx, sink| unsafe { f(self.0, action, s(sarg), a, b, c, ctx, sink) })
            .ok_or_else(|| {
                Error(format!(
                    "action {action} on actor {} failed: it is gone, an argument is invalid, or the host does not recognize the action number",
                    self.0
                ))
            })
    }

    fn act0(&self, action: i32) -> Result<()> {
        self.act(action, "", 0.0, 0.0, 0.0).map(|_| ())
    }

    /// The actions that answer `"0"` or `"1"`, such as `ADD_TAG` and `HAS_TAG`.
    fn act_bool(&self, action: i32, sarg: &str) -> Result<bool> {
        let out = self.act(action, sarg, 0.0, 0.0, 0.0)?;
        match out.trim() {
            "1" => Ok(true),
            "0" => Ok(false),
            other => Err(Error(format!(
                "action {action} should answer \"0\" or \"1\" and answered {other:?}"
            ))),
        }
    }

    pub fn kill(&self) -> Result<()> {
        self.act0(sys::PIER_AACT_KILL)
    }
    pub fn despawn(&self) -> Result<()> {
        self.act0(sys::PIER_AACT_DESPAWN)
    }
    pub fn clear_effects(&self) -> Result<()> {
        self.act0(sys::PIER_AACT_CLEAR_EFFECTS)
    }
    pub fn stop_fire(&self) -> Result<()> {
        self.act0(sys::PIER_AACT_STOP_FIRE)
    }
    pub fn remove_all_passengers(&self) -> Result<()> {
        self.act0(sys::PIER_AACT_REMOVE_ALL_PASSENGERS)
    }

    pub fn heal(&self, amount: f64) -> Result<()> {
        self.act(sys::PIER_AACT_HEAL, "", amount, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn hurt(&self, amount: f64) -> Result<()> {
        self.act(sys::PIER_AACT_HURT, "", amount, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn burn(&self, damage: f64) -> Result<()> {
        self.act(sys::PIER_AACT_BURN, "", damage, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn set_on_fire(&self, seconds: i32) -> Result<()> {
        self.act(sys::PIER_AACT_SET_ON_FIRE, "", seconds as f64, 0.0, 0.0)
            .map(|_| ())
    }

    /// Teleports elsewhere within the same dimension.
    pub fn teleport(&self, x: f64, y: f64, z: f64) -> Result<()> {
        let dim = self.dimension()?;
        self.teleport_to(dim, x, y, z)
    }

    /// Teleports into a given dimension. A custom dimension, with an id of 3 or above, goes
    /// through here too.
    pub fn teleport_to(&self, dim: i32, x: f64, y: f64, z: f64) -> Result<()> {
        self.act(sys::PIER_AACT_TELEPORT, &dim.to_string(), x, y, z)
            .map(|_| ())
    }

    pub fn set_rotation(&self, pitch: f64, yaw: f64) -> Result<()> {
        self.act(sys::PIER_AACT_SET_ROTATION, "", pitch, yaw, 0.0)
            .map(|_| ())
    }

    /// The tags the entity carries, the ones `/tag` lists.
    pub fn tags(&self) -> Result<Vec<String>> {
        let text = self.tags_json()?;
        serde_json::from_str(&text).map_err(|e| {
            crate::Error(format!(
                "the tags of entity {} could not be read: {e}",
                self.id()
            ))
        })
    }

    /// The id of the entity's owner, or -1 when it has none.
    pub fn owner_id(&self) -> Result<i64> {
        let text = self.owner_id_text()?;
        text.trim().parse::<i64>().map_err(|_| {
            crate::Error(format!(
                "the owner of entity {} could not be read",
                self.id()
            ))
        })
    }

    pub fn set_sitting(&self, sitting: bool) -> Result<()> {
        let a = if sitting { 1.0 } else { 0.0 };
        self.act(sys::PIER_AACT_SET_SITTING, "", a, 0.0, 0.0)
            .map(|_| ())
    }

    /// Mounts this entity on `vehicle`; `force` mounts it where the vehicle has no free seat.
    pub fn start_riding(&self, vehicle: &Entity, force: bool) -> Result<()> {
        let a = if force { 1.0 } else { 0.0 };
        self.act(
            sys::PIER_AACT_START_RIDING,
            &vehicle.id().to_string(),
            a,
            0.0,
            0.0,
        )
        .map(|_| ())
    }

    /// The current, minimum, maximum and default value of one attribute, by a name such as
    /// `"minecraft:health"` or `"minecraft:movement"`.
    pub fn attribute_info(&self, name: &str) -> Result<crate::types::AttributeValue> {
        let text = self.act(sys::PIER_AACT_ATTRIBUTE_INFO, name, 0.0, 0.0, 0.0)?;
        let v: serde_json::Value = serde_json::from_str(&text).map_err(|e| {
            crate::Error(format!(
                "attribute {name} of entity {} could not be read: {e}",
                self.id()
            ))
        })?;
        let num = |key: &str| {
            v.get(key)
                .and_then(serde_json::Value::as_f64)
                .ok_or_else(|| {
                    crate::Error(format!(
                        "attribute {name} of entity {} has no {key}",
                        self.id()
                    ))
                })
        };
        Ok(crate::types::AttributeValue {
            current: num("current")?,
            min: num("min")?,
            max: num("max")?,
            default: num("default")?,
        })
    }

    pub fn set_attribute(&self, name: &str, value: f32) -> Result<()> {
        self.act(
            sys::PIER_AACT_ATTRIBUTE_SET,
            name,
            f64::from(value),
            0.0,
            0.0,
        )
        .map(|_| ())
    }

    pub fn set_attribute_max(&self, name: &str, value: f32) -> Result<()> {
        self.act(
            sys::PIER_AACT_ATTRIBUTE_SET_MAX,
            name,
            f64::from(value),
            0.0,
            0.0,
        )
        .map(|_| ())
    }

    pub fn set_attribute_default(&self, name: &str, value: f32) -> Result<()> {
        self.act(
            sys::PIER_AACT_ATTRIBUTE_SET_DEFAULT,
            name,
            f64::from(value),
            0.0,
            0.0,
        )
        .map(|_| ())
    }

    /// The names of the attributes the entity has, of the ones the attribute calls can name.
    pub fn attribute_names(&self) -> Result<Vec<String>> {
        let text = self.act(sys::PIER_AACT_ATTRIBUTE_LIST, "", 0.0, 0.0, 0.0)?;
        serde_json::from_str(&text).map_err(|e| {
            crate::Error(format!(
                "the attributes of entity {} could not be listed: {e}",
                self.id()
            ))
        })
    }
    pub fn set_velocity(&self, x: f64, y: f64, z: f64) -> Result<()> {
        self.act(sys::PIER_AACT_SET_VELOCITY, "", x, y, z)
            .map(|_| ())
    }
    pub fn apply_impulse(&self, x: f64, y: f64, z: f64) -> Result<()> {
        self.act(sys::PIER_AACT_APPLY_IMPULSE, "", x, y, z)
            .map(|_| ())
    }

    pub fn set_name_tag(&self, name: &str) -> Result<()> {
        self.act(sys::PIER_AACT_SET_NAME_TAG, name, 0.0, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn set_name_tag_visible(&self, on: bool) -> Result<()> {
        self.act(
            sys::PIER_AACT_SET_NAME_TAG_VISIBLE,
            "",
            if on { 1.0 } else { 0.0 },
            0.0,
            0.0,
        )
        .map(|_| ())
    }
    pub fn set_score_tag(&self, text: &str) -> Result<()> {
        self.act(sys::PIER_AACT_SET_SCORE_TAG, text, 0.0, 0.0, 0.0)
            .map(|_| ())
    }

    pub fn add_tag(&self, tag: &str) -> Result<bool> {
        self.act_bool(sys::PIER_AACT_ADD_TAG, tag)
    }
    pub fn remove_tag(&self, tag: &str) -> Result<bool> {
        self.act_bool(sys::PIER_AACT_REMOVE_TAG, tag)
    }
    pub fn has_tag(&self, tag: &str) -> Result<bool> {
        self.act_bool(sys::PIER_AACT_HAS_TAG, tag)
    }

    /// Adds one status effect.
    pub fn add_effect(
        &self,
        effect: &str,
        ticks: i32,
        amplifier: i32,
        visible: bool,
    ) -> Result<()> {
        self.act(
            sys::PIER_AACT_ADD_EFFECT,
            effect,
            ticks as f64,
            amplifier as f64,
            if visible { 1.0 } else { 0.0 },
        )
        .map(|_| ())
    }

    pub fn remove_effect(&self, effect: &str) -> Result<()> {
        self.act(sys::PIER_AACT_REMOVE_EFFECT, effect, 0.0, 0.0, 0.0)
            .map(|_| ())
    }

    /// Reads the current value of one attribute, named as `minecraft:health` is.
    pub fn attribute(&self, name: &str) -> Result<f64> {
        let out = self.act(sys::PIER_AACT_ATTRIBUTE_GET, name, 0.0, 0.0, 0.0)?;
        out.trim().parse::<f64>().map_err(|e| {
            Error(format!(
                "the value {out:?} of attribute {name} does not parse as a number: {e}"
            ))
        })
    }

    pub fn set_variant(&self, v: i32) -> Result<()> {
        self.act(sys::PIER_AACT_SET_VARIANT, "", v as f64, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn set_mark_variant(&self, v: i32) -> Result<()> {
        self.act(sys::PIER_AACT_SET_MARK_VARIANT, "", v as f64, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn set_persistent(&self) -> Result<()> {
        self.act0(sys::PIER_AACT_SET_PERSISTENT)
    }
    pub fn set_invisible(&self, on: bool) -> Result<()> {
        self.act(
            sys::PIER_AACT_SET_INVISIBLE,
            "",
            if on { 1.0 } else { 0.0 },
            0.0,
            0.0,
        )
        .map(|_| ())
    }
    pub fn set_sneaking(&self, on: bool) -> Result<()> {
        self.act(
            sys::PIER_AACT_SET_SNEAKING,
            "",
            if on { 1.0 } else { 0.0 },
            0.0,
            0.0,
        )
        .map(|_| ())
    }
    pub fn set_skin_id(&self, id: i32) -> Result<()> {
        self.act(sys::PIER_AACT_SET_SKIN_ID, "", id as f64, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn set_strength(&self, v: i32) -> Result<()> {
        self.act(sys::PIER_AACT_SET_STRENGTH, "", v as f64, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn set_target(&self, target: Entity) -> Result<()> {
        self.act(sys::PIER_AACT_SET_TARGET, "", target.0 as f64, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn set_owner(&self, owner: Entity) -> Result<()> {
        self.act(sys::PIER_AACT_SET_OWNER, "", owner.0 as f64, 0.0, 0.0)
            .map(|_| ())
    }
    pub fn set_leash_holder(&self, holder: Entity) -> Result<()> {
        self.act(
            sys::PIER_AACT_SET_LEASH_HOLDER,
            "",
            holder.0 as f64,
            0.0,
            0.0,
        )
        .map(|_| ())
    }
    pub fn execute_event(&self, event: &str) -> Result<()> {
        self.act(sys::PIER_AACT_EXECUTE_EVENT, event, 0.0, 0.0, 0.0)
            .map(|_| ())
    }
}
