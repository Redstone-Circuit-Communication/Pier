package levilamina

// The facade functions for the slots the other facade files do not reach: what an actor looks
// at and wears, the block-writing slots, the level, the server clock, the economy history, the
// dimensions a pack or a plot world needs, and the fast lanes.

/*
#include <stdlib.h>
#include "sdk/abi.h"
#include "slots_gen.h"
#include "glue.h"
*/
import "C"

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
	"sync/atomic"
	"unsafe"
)

// numberOf reads a number of any width.
func numberOf(n *Nbt) (float64, bool) {
	if n == nil {
		return 0, false
	}
	switch n.Kind {
	case NbtByte, NbtShort, NbtInt, NbtLong:
		return float64(n.Int), true
	case NbtFloat, NbtDouble:
		return n.Float, true
	}
	return 0, false
}

// vec3Of reads a list of three numbers.
func vec3Of(n *Nbt) ([3]float64, bool) {
	var out [3]float64
	if n == nil || n.Kind != NbtList || len(n.List) != 3 {
		return out, false
	}
	for i, item := range n.List {
		v, ok := numberOf(item)
		if !ok {
			return out, false
		}
		out[i] = v
	}
	return out, true
}

// cellOf reads a list of three whole numbers.
func cellOf(n *Nbt) ([3]int32, bool) {
	v, ok := vec3Of(n)
	return [3]int32{int32(v[0]), int32(v[1]), int32(v[2])}, ok
}

// parseText parses SNBT the host wrote, naming what it was when it does not parse.
func parseText(text, what string) (*Nbt, error) {
	v, err := ParseSNBT(text)
	if err != nil {
		return nil, fmt.Errorf("parsing %s failed: %w", what, err)
	}
	return v, nil
}

// optInt32 is an integer entry of a compound, or def when it is absent.
func optInt32(v *Nbt, path string, def int32) int32 {
	if n, ok := v.OptInt(path); ok {
		return int32(n)
	}
	return def
}

// AABB is the axis-aligned bounding box of an actor.
type AABB struct{ Min, Max [3]float64 }

// AABB reads the bounding box of the actor.
func (e Entity) AABB() (AABB, error) {
	out, ok, err := Raw.ActorGetAabb(e.ID)
	text, err := lastOr(out, ok, err, fmt.Sprintf("the bounding box of actor %d", e.ID))
	if err != nil {
		return AABB{}, err
	}
	v, err := parseText(text, "the bounding box")
	if err != nil {
		return AABB{}, err
	}
	lo, okLo := vec3Of(v.Get("min"))
	hi, okHi := vec3Of(v.Get("max"))
	if !okLo || !okHi {
		return AABB{}, noAnswer("the corners of the bounding box")
	}
	return AABB{Min: lo, Max: hi}, nil
}

// Effect is one status effect of an actor.
type Effect struct {
	ID        string
	Ticks     int32
	Amplifier int32
	Visible   bool
}

// Effects lists every status effect on the actor.
func (e Entity) Effects() ([]Effect, error) {
	out, ok, err := Raw.ActorGetEffects(e.ID)
	text, err := lastOr(out, ok, err, fmt.Sprintf("the status effects of actor %d", e.ID))
	if err != nil {
		return nil, err
	}
	v, err := parseText(text, "the status effects")
	if err != nil {
		return nil, err
	}
	if v.Kind != NbtList {
		return nil, noAnswer("the status effect list")
	}
	effects := make([]Effect, 0, len(v.List))
	for _, item := range v.List {
		id, ok := item.OptString("id")
		if !ok {
			if n, isNum := item.OptInt("id"); isNum {
				id = strconv.FormatInt(n, 10)
			}
		}
		visible, hasVisible := item.OptBool("visible")
		if !hasVisible {
			visible = true
		}
		effects = append(effects, Effect{ID: id, Ticks: optInt32(item, "ticks", 0), Amplifier: optInt32(item, "amplifier", 0), Visible: visible})
	}
	return effects, nil
}

// The equipment slots of EquippedItem and SetEquippedItem.
const (
	EquipMainHand   int32 = 0
	EquipOffHand    int32 = 1
	EquipHelmet     int32 = 2
	EquipChestplate int32 = 3
	EquipLeggings   int32 = 4
	EquipBoots      int32 = 5
)

// EquippedItem is what the actor wears or holds in one equipment slot.
func (e Entity) EquippedItem(slot int32) (Item, error) {
	out, ok, err := Raw.ActorGetEquippedItem(e.ID, slot)
	text, err := lastOr(out, ok, err, fmt.Sprintf("equipment slot %d of actor %d", slot, e.ID))
	return Item{SNBT: text}, err
}

// SetEquippedItem puts an item into one equipment slot.
func (e Entity) SetEquippedItem(slot int32, item Item) error {
	ok, err := Raw.ActorSetEquippedItem(e.ID, slot, item.SNBT)
	return okOr(ok, err, fmt.Sprintf("writing equipment slot %d of actor %d", slot, e.ID))
}

// FirstPassenger is the first actor riding this one.
func (e Entity) FirstPassenger() (Entity, error) {
	id, ok, err := Raw.ActorGetFirstPassenger(e.ID)
	return Entity{ID: id}, okOr(ok, err, fmt.Sprintf("the passenger of actor %d", e.ID))
}

// StatusFlag reads one bit of the engine's ActorFlags.
func (e Entity) StatusFlag(flagIndex int32) (bool, error) {
	return Raw.ActorGetStatusFlag(e.ID, flagIndex)
}

// SetStatusFlag writes one bit of the engine's ActorFlags.
func (e Entity) SetStatusFlag(flagIndex int32, value bool) error {
	ok, err := Raw.ActorSetStatusFlag(e.ID, flagIndex, value)
	return okOr(ok, err, fmt.Sprintf("writing status flag %d of actor %d", flagIndex, e.ID))
}

// RayKind says what a ray trace hit.
type RayKind int32

// What a ray can hit.
const (
	RayNone RayKind = iota
	RayEntity
	RayBlock
)

// RayHit is the result of one ray trace.
type RayHit struct {
	Kind RayKind
	// EntityID is the actor hit, for RayEntity.
	EntityID ActorID
	// Block is the cell hit, for RayBlock, with the face in Facing and the block's name in
	// BlockName.
	Block     [3]int32
	Facing    int32
	BlockName string
	// Pos is the exact point of the hit.
	Pos [3]float64
}

func parseRayHit(text string) (RayHit, error) {
	v, err := parseText(text, "the ray result")
	if err != nil {
		return RayHit{}, err
	}
	kind, _ := v.OptString("type")
	pos, _ := vec3Of(v.Get("pos"))
	switch kind {
	case "entity":
		id, ok := v.OptInt("entity_id")
		if !ok {
			id, ok = v.OptInt("entity")
		}
		if !ok {
			return RayHit{}, noAnswer("the actor a ray hit")
		}
		return RayHit{Kind: RayEntity, EntityID: ActorID(id), Pos: pos}, nil
	case "block":
		cell, ok := cellOf(v.Get("block"))
		if !ok {
			cell = [3]int32{int32(floor(pos[0])), int32(floor(pos[1])), int32(floor(pos[2]))}
		}
		name, _ := v.OptString("block_name")
		return RayHit{Kind: RayBlock, Block: cell, Facing: optInt32(v, "facing", -1), BlockName: name, Pos: pos}, nil
	case "", "none":
		return RayHit{Kind: RayNone}, nil
	}
	return RayHit{}, fmt.Errorf("the type of the ray result is an unrecognized %q", kind)
}

func floor(x float64) int64 {
	n := int64(x)
	if float64(n) > x {
		n--
	}
	return n
}

// TraceRay casts a ray along the line of sight of the actor and reports what it hits.
func (e Entity) TraceRay(maxDist float32, includeActors, includeBlocks bool) (RayHit, error) {
	out, ok, err := Raw.ActorTraceRay(e.ID, maxDist, includeActors, includeBlocks)
	text, err := lastOr(out, ok, err, fmt.Sprintf("the ray trace of actor %d", e.ID))
	if err != nil {
		return RayHit{}, err
	}
	return parseRayHit(text)
}

// TraceRayBlocks is TraceRay reporting the hit as a block cell, with the face that was hit.
func (e Entity) TraceRayBlocks(maxDist float32, includeActors, includeBlocks bool) (RayHit, error) {
	out, ok, err := Raw.EditTraceRay(e.ID, maxDist, includeActors, includeBlocks)
	text, err := lastOr(out, ok, err, fmt.Sprintf("the ray trace of actor %d", e.ID))
	if err != nil {
		return RayHit{}, err
	}
	return parseRayHit(text)
}

// CollisionBox is the block's collision shape as the host writes it.
func (b BlockAt) CollisionBox() (string, error) {
	out, ok, err := Raw.BlockGetCollisionShape(b.Dim, b.X, b.Y, b.Z)
	return lastOr(out, ok, err, "the collision shape")
}

// ExtraBlock is the liquid layer of the cell, as a block name; an empty layer is air.
func (b BlockAt) ExtraBlock() (string, error) {
	out, ok, err := Raw.GetExtraBlock(b.Dim, b.X, b.Y, b.Z)
	return lastOr(out, ok, err, "the liquid layer")
}

// SetExtraBlock writes the liquid layer of the cell; write minecraft:air to clear it.
func (b BlockAt) SetExtraBlock(blockSpec string, updateFlags int32) error {
	ok, err := Raw.SetExtraBlock(b.Dim, b.X, b.Y, b.Z, blockSpec, updateFlags)
	return okOr(ok, err, "writing the liquid layer")
}

// SetNBT writes a block from serialized NBT, the shape Info produces.
func (b BlockAt) SetNBT(snbt string, updateFlags int32) error {
	ok, err := Raw.EditSetBlockNbt(b.Dim, b.X, b.Y, b.Z, snbt, updateFlags)
	return okOr(ok, err, "writing a block from NBT")
}

// SetStates writes a block from a name and optional partial states; an empty statesSNBT means
// every state at its default.
func (b BlockAt) SetStates(name, statesSNBT string, updateFlags int32) error {
	ok, err := Raw.EditSetBlockStates(b.Dim, b.X, b.Y, b.Z, name, statesSNBT, updateFlags)
	return okOr(ok, err, "writing a block from a name and states")
}

// SetEntitySNBT writes the NBT of the block entity of the cell, which must already hold the
// matching block.
func (b BlockAt) SetEntitySNBT(snbt string) error {
	ok, err := Raw.EditSetBlockEntity(b.Dim, b.X, b.Y, b.Z, snbt)
	return okOr(ok, err, "writing a block entity")
}

// SpawnEntityNBT spawns an actor from full NBT, the inverse of Snapshot. A non-nil pos
// overrides the Pos tag. Every current host answers not provided.
func SpawnEntityNBT(dim int32, snbt string, pos *[3]float64) (Entity, error) {
	var at [3]float64
	if pos != nil {
		at = *pos
	}
	id, ok, err := Raw.EditSpawnEntityNbt(dim, snbt, pos != nil, at[0], at[1], at[2])
	return Entity{ID: id}, okOr(ok, err, "spawning an actor from NBT")
}

// FindPath computes a path for an actor to a target cell, as the host's SNBT. Every current
// host answers not provided.
func FindPath(who Entity, x, y, z int32) (*Nbt, error) {
	out, ok, err := Raw.LevelFindPath(who.ID, x, y, z)
	text, err := lastOr(out, ok, err, fmt.Sprintf("the path of actor %d", who.ID))
	if err != nil {
		return nil, err
	}
	return parseText(text, "the path")
}

// UpdateWeather sets the level and the remaining ticks of rain and of lightning.
func UpdateWeather(rainLevel float32, rainTicks int32, lightningLevel float32, lightningTicks int32) error {
	ok, err := Raw.LevelUpdateWeather(rainLevel, rainTicks, lightningLevel, lightningTicks)
	return okOr(ok, err, "updating the weather")
}

// SleepStatus is how many players sleep.
type SleepStatus struct {
	Sleeping       bool
	TotalPlayers   int32
	ActiveSleeping int32
}

// LevelSleepStatus reads the sleep status of the players.
func LevelSleepStatus() (SleepStatus, error) {
	out, ok, err := Raw.LevelGetSleepStatus()
	text, err := lastOr(out, ok, err, "the sleep status")
	if err != nil {
		return SleepStatus{}, err
	}
	v, err := parseText(text, "the sleep status")
	if err != nil {
		return SleepStatus{}, err
	}
	sleeping, _ := v.OptBool("sleeping")
	return SleepStatus{Sleeping: sleeping, TotalPlayers: optInt32(v, "total_players", 0), ActiveSleeping: optInt32(v, "active_sleeping", 0)}, nil
}

// Village is one village.
type Village struct {
	UUID     string
	Center   [3]int32
	Min, Max [3]int32
	PoiCount int32
}

// boundsOf reads {min:[x,y,z],max:[x,y,z]} at path.
func boundsOf(v *Nbt, path string) (lo, hi [3]int32, ok bool) {
	b := v.Get(path)
	if b == nil {
		return lo, hi, false
	}
	lo, okLo := cellOf(b.Get("min"))
	hi, okHi := cellOf(b.Get("max"))
	return lo, hi, okLo && okHi
}

// Villages lists the villages of one dimension.
func Villages(dim int32) ([]Village, error) {
	out, err := Raw.Villages(dim)
	if err != nil {
		return nil, err
	}
	villages := make([]Village, 0, len(out))
	for _, text := range out {
		v, err := ParseSNBT(text)
		if err != nil {
			continue
		}
		center, okCenter := cellOf(v.Get("center"))
		lo, hi, okBounds := boundsOf(v, "bounds")
		if !okCenter || !okBounds {
			continue
		}
		uuid, _ := v.OptString("uuid")
		villages = append(villages, Village{UUID: uuid, Center: center, Min: lo, Max: hi, PoiCount: optInt32(v, "poi_count", 0)})
	}
	return villages, nil
}

// Structure is one hardcoded generation area: a stronghold, a witch hut, an ocean monument
// or a similar structure.
type Structure struct {
	Kind     string
	Min, Max [3]int32
}

// StructuresNear lists the hardcoded generation areas of the loaded chunks within a radius.
func StructuresNear(dim, x, y, z, radius int32) ([]Structure, error) {
	out, err := Raw.StructuresNear(dim, x, y, z, radius)
	if err != nil {
		return nil, err
	}
	found := make([]Structure, 0, len(out))
	for _, text := range out {
		v, err := ParseSNBT(text)
		if err != nil {
			continue
		}
		lo, hi, ok := boundsOf(v, "bounds")
		if !ok {
			continue
		}
		kind, _ := v.OptString("type")
		found = append(found, Structure{Kind: kind, Min: lo, Max: hi})
	}
	return found, nil
}

// ChunksLoaded reports whether every chunk covered by the region is in memory.
func ChunksLoaded(dim, minX, minZ, maxX, maxZ int32) (bool, error) {
	n, err := Raw.LevelChunksLoaded(dim, minX, minZ, maxX, maxZ)
	if err != nil {
		return false, err
	}
	switch n {
	case 1:
		return true, nil
	case 0:
		return false, nil
	}
	return false, fmt.Errorf("dimension %d is unavailable, so the chunk load state cannot be determined", dim)
}

// DeleteChunkKeys deletes every save key of a chunk, so the engine regenerates it from the
// generator on its next load, and returns how many keys went. Only an unloaded chunk can be
// restored this way.
func DeleteChunkKeys(dim, chunkX, chunkZ int32) (int32, error) {
	n, err := Raw.LevelDeleteChunkKeys(dim, chunkX, chunkZ)
	if err != nil {
		return 0, err
	}
	if n < 0 {
		return 0, fmt.Errorf("the save layer is unavailable, so the keys of chunk %d,%d cannot be deleted", chunkX, chunkZ)
	}
	return n, nil
}

// ChunkKeys lists every save key of a chunk. A key is binary, and a Go string holds it as it
// is.
func ChunkKeys(dim, chunkX, chunkZ int32) ([]string, error) {
	keys, n, err := Raw.LevelChunkKeys(dim, chunkX, chunkZ)
	if err != nil {
		return nil, err
	}
	if n < 0 {
		return nil, fmt.Errorf("the save layer is unavailable, so the keys of chunk %d,%d cannot be listed", chunkX, chunkZ)
	}
	return keys, nil
}

// DeleteSaveKey deletes one save key byte for byte. The content is not interpreted.
func DeleteSaveKey(key string) error {
	ok, err := Raw.LevelDeleteKey(key)
	return okOr(ok, err, "deleting a save key")
}

// PositionOf looks up the feet position and the dimension of a connected player by name.
func PositionOf(name string) (PlayerPos, error) {
	p, err := Raw.GetPlayerPosition(name)
	if err != nil {
		return PlayerPos{}, err
	}
	if !p.Found {
		return PlayerPos{}, fmt.Errorf("player %s is offline, so no position can be read", name)
	}
	return p, nil
}

// Position is the player's feet position and dimension.
func (p Player) Position() (PlayerPos, error) {
	name, err := p.RealName()
	if err != nil {
		if p.Sel.Kind != SelName {
			return PlayerPos{}, err
		}
		name = p.Sel.Value
	}
	return PositionOf(name)
}

// Cooldown is how many ticks of cooldown the item has left, and -1 when it is not on cooldown.
func (p Player) Cooldown(itemName string) (int32, error) {
	return Raw.PlayerGetCooldown(p.Sel, itemName)
}

// SetCooldown puts the item on cooldown for the player.
func (p Player) SetCooldown(itemName string, ticks int32) error {
	ok, err := Raw.PlayerStartCooldown(p.Sel, itemName, ticks)
	return okOr(ok, err, "starting an item cooldown")
}

// Equipment lists the equipment of the player, one entry per slot of the engine's numbering.
func (p Player) Equipment() ([]SlotItem, error) {
	out, ok, err := Raw.PlayerGetEquipment(p.Sel)
	text, err := lastOr(out, ok, err, "the equipment")
	if err != nil {
		return nil, err
	}
	v, err := parseText(text, "the equipment")
	if err != nil {
		return nil, err
	}
	if v.Kind != NbtList {
		return nil, noAnswer("the equipment list")
	}
	items := make([]SlotItem, 0, len(v.List))
	for _, entry := range v.List {
		slot, okSlot := entry.OptInt("slot")
		snbt, okItem := entry.OptString("item_snbt")
		if okSlot && okItem {
			items = append(items, SlotItem{Slot: int32(slot), SNBT: snbt})
		}
	}
	return items, nil
}

// NetworkStatus is the network status of a player. A value the host could not measure is -1.
type NetworkStatus struct {
	Ping, AvgPing, MaxPing, PacketLoss int32
}

// NetworkDetail reads the network status of the player.
func (p Player) NetworkDetail() (NetworkStatus, error) {
	out, ok, err := Raw.PlayerGetNetworkStatus(p.Sel)
	text, err := lastOr(out, ok, err, "the network status")
	if err != nil {
		return NetworkStatus{}, err
	}
	v, err := parseText(text, "the network status")
	if err != nil {
		return NetworkStatus{}, err
	}
	return NetworkStatus{Ping: optInt32(v, "ping", -1), AvgPing: optInt32(v, "avg_ping", -1), MaxPing: optInt32(v, "max_ping", -1), PacketLoss: optInt32(v, "packet_loss", -1)}, nil
}

// SendPacket pushes one raw packet onto the connection of the player: the id and the body,
// without the header.
func (p Player) SendPacket(packetID int32, body []byte) error {
	ok, err := Raw.SendPacket(p.Sel, packetID, body)
	return okOr(ok, err, fmt.Sprintf("sending packet %d", packetID))
}

// ShowParticle spawns a particle that only this player sees.
func (p Player) ShowParticle(dim int32, effect string, x, y, z float64) error {
	ok, err := Raw.SpawnParticleFor(p.Sel, dim, effect, x, y, z)
	return okOr(ok, err, "spawning a particle for one player")
}

// Refresh resends the whole container to its owner. A block container has no owner to resend
// to, and the host refuses it.
func (c Container) Refresh() error {
	ok, err := Raw.ContainerRefresh(c.Ref)
	return okOr(ok, err, "resending a container")
}

// UserDataSNBT is the custom NBT of the item, its tag section, as SNBT.
func (i Item) UserDataSNBT() (string, error) {
	out, ok, err := Raw.ItemGetUserData(i.SNBT)
	return lastOr(out, ok, err, "the custom NBT of an item")
}

// Enchant is one enchantment.
type Enchant struct {
	ID    string
	Level int32
}

// EnchantList lists the enchantments of the item.
func (i Item) EnchantList() ([]Enchant, error) {
	text, err := i.Enchants()
	if err != nil {
		return nil, err
	}
	v, err := parseText(text, "the enchantments")
	if err != nil {
		return nil, err
	}
	if v.Kind != NbtList {
		return nil, noAnswer("the enchantment list")
	}
	list := make([]Enchant, 0, len(v.List))
	for _, entry := range v.List {
		id, ok := entry.OptString("id")
		if !ok {
			n, isNum := entry.OptInt("id")
			if !isNum {
				continue
			}
			id = strconv.FormatInt(n, 10)
		}
		list = append(list, Enchant{ID: id, Level: optInt32(entry, "level", 1)})
	}
	return list, nil
}

// WithEnchants replaces the whole enchantment set and returns the new item. Every current
// host answers not provided: writing enchantments is not implemented, and Transform with the
// add-enchant operation is the way to add one.
func (i Item) WithEnchants(set []Enchant) (Item, error) {
	var b strings.Builder
	b.WriteByte('[')
	for n, e := range set {
		if n > 0 {
			b.WriteByte(',')
		}
		fmt.Fprintf(&b, "{%s:%s,%s:%d}", snbtQuote("id"), snbtQuote(e.ID), snbtQuote("level"), e.Level)
	}
	b.WriteByte(']')
	out, ok, err := Raw.ItemSetEnchants(i.SNBT, b.String())
	text, err := lastOr(out, ok, err, "writing the enchantments")
	return Item{SNBT: text}, err
}

// SetTickFreeze freezes or unfreezes the world.
func SetTickFreeze(on bool) error {
	ok, err := Raw.TickFreeze(on)
	return okOr(ok, err, "freezing the ticks")
}

// StepTicks lets n more frames through while the world is frozen.
func StepTicks(n uint32) error {
	ok, err := Raw.TickStep(n)
	return okOr(ok, err, "stepping the ticks")
}

// SetTickWarp sets the time warp: 0 < factor <= 100, below 1 is slow motion and 1 is normal.
func SetTickWarp(factor float64) error {
	ok, err := Raw.TickWarp(factor)
	return okOr(ok, err, "warping the ticks")
}

// BeginProfile opens a sampling window of ticks frames, from 1 to 12000. Only one window is
// open at a time.
func BeginProfile(ticks uint32) error {
	ok, err := Raw.ProfileBegin(ticks)
	return okOr(ok, err, "beginning a profile")
}

// TakeProfile takes the sampling report as SNBT. ready is false while the window is still open
// or none was armed. The report is handed out once per window.
func TakeProfile() (report string, ready bool, err error) {
	out, ok, err := Raw.ProfileTake()
	if err != nil || !ok || len(out) == 0 {
		return "", false, err
	}
	return out[len(out)-1], true, nil
}

// IsWine reports whether this host runs under Wine.
func IsWine() (bool, error) { return Raw.SysIsWine() }

// MoneyHistory lists the transactions of the last seconds seconds, one per line.
func MoneyHistory(xuid string, seconds int32) ([]string, error) {
	return Raw.MoneyGetHist(xuid, seconds)
}

// ClearMoneyHistory clears the transactions older than seconds seconds.
func ClearMoneyHistory(seconds int32) error { return Raw.MoneyClearHist(seconds) }

// MoneyRanking lists the top of the rich list, one per line.
func MoneyRanking(top uint16) ([]string, error) { return Raw.MoneyRanking(top) }

// BinaryToSnbt decodes binary NBT as SNBT. format is 0 for the little-endian disk layout and
// 1 for the network encoding.
func BinaryToSnbt(data []byte, format int32) (string, error) {
	out, ok, err := Raw.NbtBinaryToSnbt(data, format)
	return lastOr(out, ok, err, "decoding binary NBT")
}

// ClientIsInLevel reports whether the client is inside a level, which means a world is loaded.
func ClientIsInLevel() (bool, error) { return Raw.ClientIsInLevel() }

// ClientLocalPlayerName is the name of the local player. The host has no answer outside a level.
func ClientLocalPlayerName() (string, error) {
	out, ok, err := Raw.ClientGetLocalPlayer()
	return lastOr(out, ok, err, "the local player")
}

// KeyCodes lists the key codes now assigned to the binding, which differ from the defaults when
// the player remapped the key.
func (k *KeyBinding) KeyCodes() ([]int32, error) {
	if k == nil || k.h.IsZero() {
		return nil, fmt.Errorf("the key binding is not registered")
	}
	out, ok, err := Raw.ClientGetKeyCodes(k.h)
	text, err := lastOr(out, ok, err, "the key codes")
	if err != nil {
		return nil, err
	}
	var codes []int32
	for _, part := range strings.Split(strings.Trim(strings.TrimSpace(text), "[]"), ",") {
		if n, err := strconv.ParseInt(strings.TrimSpace(part), 10, 32); err == nil {
			codes = append(codes, int32(n))
		}
	}
	return codes, nil
}

// ExistingDimension is one custom dimension that has been registered.
type ExistingDimension struct {
	Name string `json:"name"`
	Dim  int32  `json:"dim"`
	SNBT string `json:"snbt"`
}

// ExistingDimensions lists every registered custom dimension.
func ExistingDimensions() ([]ExistingDimension, error) {
	lines, err := ListDimensions()
	if err != nil {
		return nil, err
	}
	found := make([]ExistingDimension, 0, len(lines))
	for _, line := range lines {
		var d ExistingDimension
		if strings.TrimSpace(line) == "" || json.Unmarshal([]byte(line), &d) != nil || d.Name == "" {
			continue
		}
		found = append(found, d)
	}
	return found, nil
}

// PackError is the refusal of a terrain pack: the PIER_PACK_* status the host gave and, when
// it wrote one, its reasons.
type PackError struct {
	Status   int32
	Problems string
}

func (e *PackError) Error() string {
	if e.Problems != "" {
		return fmt.Sprintf("the host refused the terrain pack with status %d: %s", e.Status, e.Problems)
	}
	return fmt.Sprintf("the host refused the terrain pack with status %d", e.Status)
}

// AddDimensionPack adds a custom dimension whose terrain is a terrain pack: a directory with a
// config file and a binary built by tools/pier-pack. configPath is relative to the server
// root, with forward slashes, no .. and not absolute. A refusal is a *PackError.
func AddDimensionPack(name, configPath, specSNBT string) (int32, error) {
	id, err := Raw.MdAddDimensionPack(name, configPath, specSNBT)
	if err != nil {
		return 0, err
	}
	if id < 0 {
		return 0, &PackError{Status: id}
	}
	return id, nil
}

// InspectPack reads what a terrain pack asks for, as a JSON document, without registering
// anything. A refusal is a *PackError.
func InspectPack(configPath string) (string, error) {
	out, status, err := Raw.MdPackInspect(configPath)
	if err != nil {
		return "", err
	}
	text := ""
	if len(out) > 0 {
		text = out[len(out)-1]
	}
	if status != 0 {
		return "", &PackError{Status: status, Problems: text}
	}
	return text, nil
}

// RetireDimension retires a custom dimension: it is dropped from the host's tables and from
// dimension_config.json, so nothing registers it on the next boot. The chunks it wrote stay.
// It reports whether one by that name was registered.
func RetireDimension(name string) (bool, error) { return Raw.MdRetireDimension(name) }

// ClearDimensionRules clears every rule of a dimension, for when its world was deleted.
func ClearDimensionRules(dim int32) error { return Raw.MdClearDimensionRules(dim) }

// SetDimensionCells gives a generated dimension the cell geometry its confinement rules use:
// cell is the edge of a cell and gap the space between cells, both in blocks. A cell of 0
// removes the geometry.
func SetDimensionCells(dimID, cell, gap int32) error {
	ok, err := Raw.MdSetDimensionCells(dimID, cell, gap)
	return okOr(ok, err, fmt.Sprintf("setting the cell geometry of dimension %d", dimID))
}

// PlotMerge holds the merge marks of one plot.
type PlotMerge struct {
	X, Z int32
	// Mask is a bitset: 1 north, 2 east, 4 south, 8 west.
	Mask uint32
}

// NewPlotMerge assembles a mask from the four directions in the order north, east, south, west.
func NewPlotMerge(x, z int32, north, east, south, west bool) PlotMerge {
	var mask uint32
	for i, on := range [4]bool{north, east, south, west} {
		if on {
			mask |= 1 << uint(i)
		}
	}
	return PlotMerge{X: x, Z: z, Mask: mask}
}

// SetPlotMerges replaces the merge marks of a dimension as a whole. Only plots that carry a
// marker need to be listed.
func SetPlotMerges(dim int32, merges []PlotMerge) error {
	entries := make([]int32, 0, len(merges)*3)
	for _, m := range merges {
		entries = append(entries, m.X, m.Z, int32(m.Mask))
	}
	return Raw.MdSetPlotMerges(dim, entries)
}

// LaneInfo is the registration record of a published lane.
type LaneInfo struct {
	Name        string `json:"name"`
	Mod         string `json:"mod"`
	Fingerprint string `json:"fingerprint"`
	Protocol    uint32 `json:"protocol"`
	Leases      uint32 `json:"leases"`
	Alive       bool   `json:"alive"`
}

// Lanes lists every published lane. It passes no pointer at all, so it suits looking at what
// exists first.
func Lanes() ([]LaneInfo, error) {
	out, err := Raw.LaneList()
	if err != nil {
		return nil, err
	}
	if len(out) == 0 || strings.TrimSpace(out[len(out)-1]) == "" {
		return nil, nil
	}
	var lanes []LaneInfo
	if err := json.Unmarshal([]byte(out[len(out)-1]), &lanes); err != nil {
		return nil, fmt.Errorf("parsing the lane listing failed: %w", err)
	}
	return lanes, nil
}

// LanePublication is one published lane.
type LanePublication struct{ id uint64 }

// PublishLane publishes a lane, exclusively under name. fingerprint is the value of the
// contract and must not be 0, which means anyone may connect and which the host refuses.
// table is the provider's table of function pointers and data the pointer each of them
// receives; both must point into C memory, since the consumer reaches them from outside Go.
// retain and release, when not nil, are C functions that count leases on data. The lane is
// withdrawn automatically at unload.
func PublishLane(name string, fingerprint uint64, data, table, retain, release unsafe.Pointer) (*LanePublication, error) {
	if api == nil || !bool(C.piergo_has_lane_publish(api)) {
		return nil, notProvided("lane_publish")
	}
	if fingerprint == 0 {
		return nil, fmt.Errorf("the fingerprint of lane %s is 0, which the ABI refuses", name)
	}
	desc := C.PierLaneDesc{
		struct_size: C.uint32_t(unsafe.Sizeof(C.PierLaneDesc{})),
		protocol:    C.PIER_LANE_PROTOCOL,
		fingerprint: C.uint64_t(fingerprint),
		data:        data,
		vtable:      table,
		retain:      C.PierLaneRefFn(retain),
		release:     C.PierLaneRefFn(release),
	}
	id := uint64(C.piergo_call_lane_publish(api, self, str(name), &desc))
	if id == 0 {
		return nil, fmt.Errorf("publishing lane %s failed because the name is taken; the host log names the holder", name)
	}
	return &LanePublication{id: id}, nil
}

// Withdraw takes the lane back; calling it twice is harmless. Every outstanding lease is
// released.
func (p *LanePublication) Withdraw() error {
	if p == nil || p.id == 0 {
		return nil
	}
	id := p.id
	p.id = 0
	ok, err := Raw.LaneUnpublish(id)
	return okOr(ok, err, "withdrawing a lane")
}

// LaneNotFoundError means no lane by that name is published.
type LaneNotFoundError struct{ Name string }

func (e *LaneNotFoundError) Error() string {
	return fmt.Sprintf("no lane named %s is published", e.Name)
}

// LaneFingerprintError means the provider's contract is not the one the consumer asked for.
type LaneFingerprintError struct {
	Name         string
	Ours, Theirs uint64
}

func (e *LaneFingerprintError) Error() string {
	return fmt.Sprintf("lane %s has the fingerprint %#x and this side asked for %#x", e.Name, e.Theirs, e.Ours)
}

// LaneLease is a lease on a published lane, kept to return it.
type LaneLease struct {
	lease uint64
	data  unsafe.Pointer
	table unsafe.Pointer
	alive *uint32
	busy  *uint32
}

// AcquireLane acquires a lane. fingerprint must be the value the consumer computed itself
// from the contract; 0 is not valid and always fails. A missing lane is a *LaneNotFoundError
// and a contract that differs is a *LaneFingerprintError.
func AcquireLane(name string, fingerprint uint64) (*LaneLease, error) {
	if api == nil || !bool(C.piergo_has_lane_acquire(api)) {
		return nil, notProvided("lane_acquire")
	}
	var ref C.PierLaneRef
	ref.struct_size = C.uint32_t(unsafe.Sizeof(ref))
	switch C.piergo_call_lane_acquire(api, self, str(name), C.uint64_t(fingerprint), &ref) {
	case C.PIER_LANE_OK:
		return &LaneLease{
			lease: uint64(ref.lease),
			data:  ref.data,
			table: ref.vtable,
			alive: (*uint32)(unsafe.Pointer(ref.alive)),
			busy:  (*uint32)(unsafe.Pointer(ref.busy)),
		}, nil
	case C.PIER_LANE_NOT_FOUND:
		return nil, &LaneNotFoundError{Name: name}
	case C.PIER_LANE_FINGERPRINT:
		return nil, &LaneFingerprintError{Name: name, Ours: fingerprint, Theirs: uint64(ref.fingerprint)}
	}
	return nil, fmt.Errorf("the host refused to lease lane %s", name)
}

// IsAlive reports whether the provider is still there.
func (l *LaneLease) IsAlive() bool {
	if l == nil || l.alive == nil {
		return false
	}
	return atomic.LoadUint32(l.alive) != 0
}

// Enter enters the provider for one call and returns the provider's table and data pointers.
// ok is false when the provider is gone. Call leave when the call is over, so the provider
// cannot unload underneath a call that is running.
func (l *LaneLease) Enter() (table, data unsafe.Pointer, leave func(), ok bool) {
	if l == nil || l.table == nil {
		return nil, nil, nil, false
	}
	if l.busy != nil {
		atomic.AddUint32(l.busy, 1)
	}
	if !l.IsAlive() {
		if l.busy != nil {
			atomic.AddUint32(l.busy, ^uint32(0))
		}
		return nil, nil, nil, false
	}
	leave = func() {
		if l.busy != nil {
			atomic.AddUint32(l.busy, ^uint32(0))
		}
	}
	return l.table, l.data, leave, true
}

// Release returns the lease. It reports false when the provider is already gone, since the
// loader has released it by then and releasing again would be a double free.
func (l *LaneLease) Release() (bool, error) {
	if l == nil || l.lease == 0 {
		return false, nil
	}
	id := l.lease
	l.lease = 0
	return Raw.LaneRelease(id)
}
