//! Writing SNBT.
//! The other side, `CompoundTag::fromSnbt`, is stricter than this one, so the rule here is to be
//! verbose rather than terse:
//! * no type suffix is omitted. A `100.0` without the `d` is read as an int, the same trap
//!   the host side has where `snbtNum` writes no suffix on a float, only in the other direction.
//! * every key is quoted. A bare key fails to parse when it starts with a digit, contains a
//!   dot or contains a non-ASCII character, and a business key such as a player name or a
//!   plot id can be anything.
//! * a control character is written as `\uXXXX`. Invalid UTF-8 was already replaced with
//!   U+FFFD by the host on the way in and is not seen here.
//! * a float uses `{:?}` and not `{}`: the latter prints `1` for `1.0` and the suffix does not
//!   recover the type, since `1d` is valid while not being the same writing habit as `1.0d`
//!   and is easily misread in a diff. A non-finite value, NaN or an infinity, cannot be
//!   expressed in SNBT and lands as `0`.

use super::NbtValue;

pub(super) fn write(v: &NbtValue, out: &mut String) {
    match v {
        NbtValue::Byte(x) => {
            out.push_str(&x.to_string());
            out.push('b');
        }
        NbtValue::Short(x) => {
            out.push_str(&x.to_string());
            out.push('s');
        }
        NbtValue::Int(x) => out.push_str(&x.to_string()),
        NbtValue::Long(x) => {
            out.push_str(&x.to_string());
            out.push('L');
        }
        NbtValue::Float(x) => {
            out.push_str(&fmt_float(*x as f64));
            out.push('f');
        }
        NbtValue::Double(x) => {
            out.push_str(&fmt_float(*x));
            out.push('d');
        }
        NbtValue::String(s) => {
            out.push('"');
            escape(s, out);
            out.push('"');
        }
        NbtValue::List(items) => {
            out.push('[');
            for (i, it) in items.iter().enumerate() {
                if i > 0 {
                    out.push(',');
                }
                write(it, out);
            }
            out.push(']');
        }
        NbtValue::Compound(map) => {
            out.push('{');
            for (i, (k, val)) in map.iter().enumerate() {
                if i > 0 {
                    out.push(',');
                }
                out.push('"');
                escape(k, out);
                out.push_str("\":");
                write(val, out);
            }
            out.push('}');
        }
        NbtValue::ByteArray(a) => {
            out.push_str("[B;");
            for (i, x) in a.iter().enumerate() {
                if i > 0 {
                    out.push(',');
                }
                out.push_str(&x.to_string());
                out.push('b');
            }
            out.push(']');
        }
        NbtValue::IntArray(a) => {
            out.push_str("[I;");
            for (i, x) in a.iter().enumerate() {
                if i > 0 {
                    out.push(',');
                }
                out.push_str(&x.to_string());
            }
            out.push(']');
        }
        NbtValue::LongArray(a) => {
            out.push_str("[L;");
            for (i, x) in a.iter().enumerate() {
                if i > 0 {
                    out.push(',');
                }
                out.push_str(&x.to_string());
                out.push('L');
            }
            out.push(']');
        }
    }
}

fn fmt_float(v: f64) -> String {
    if !v.is_finite() {
        return "0.0".to_owned();
    }
    let s = format!("{v:?}"); // `{:?}` guarantees the decimal point is there
    if s.contains(['.', 'e', 'E']) {
        s
    } else {
        s + ".0"
    }
}

fn escape(s: &str, out: &mut String) {
    for c in s.chars() {
        match c {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c if (c as u32) < 0x20 || c as u32 == 0x7f => {
                out.push_str(&format!("\\u{:04x}", c as u32));
            }
            c => out.push(c),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn snbt(v: &NbtValue) -> String {
        let mut out = String::new();
        write(v, &mut out);
        out
    }

    #[test]
    fn a_double_always_carries_its_point_and_its_suffix() {
        assert_eq!(snbt(&NbtValue::Double(1.0)), "1.0d");
        assert_eq!(snbt(&NbtValue::Double(-0.5)), "-0.5d");
        assert_eq!(snbt(&NbtValue::Float(0.5)), "0.5f");
    }

    #[test]
    fn a_value_snbt_cannot_express_is_written_as_zero() {
        assert_eq!(snbt(&NbtValue::Double(f64::NAN)), "0.0d");
        assert_eq!(snbt(&NbtValue::Double(f64::INFINITY)), "0.0d");
    }

    #[test]
    fn a_string_is_quoted_and_its_control_characters_are_escaped() {
        let s = NbtValue::String("a\"b\\c\nd\u{1}".to_owned());
        assert_eq!(snbt(&s), "\"a\\\"b\\\\c\\nd\\u0001\"");
    }

    #[test]
    fn every_key_is_quoted_so_a_business_key_cannot_break_the_parse() {
        let v = NbtValue::obj([("1x.y", NbtValue::Byte(1))]);
        assert_eq!(snbt(&v), "{\"1x.y\":1b}");
    }
}
