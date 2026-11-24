package levilamina

import (
	"strings"
	"testing"
	"unsafe"
)

func mustParse(t *testing.T, text string) *Nbt {
	t.Helper()
	v, err := ParseSNBT(text)
	if err != nil {
		t.Fatalf("ParseSNBT(%q): %v", text, err)
	}
	return v
}

func TestNumbersOfAnyWidth(t *testing.T) {
	v := mustParse(t, "{b:1b,s:2s,i:3,l:4L,f:1.5f,d:2.5d,t:\"x\"}")
	for path, want := range map[string]float64{"b": 1, "s": 2, "i": 3, "l": 4, "f": 1.5, "d": 2.5} {
		got, ok := numberOf(v.Get(path))
		if !ok || got != want {
			t.Errorf("numberOf(%s) = %v, %v; want %v", path, got, ok, want)
		}
	}
	if _, ok := numberOf(v.Get("t")); ok {
		t.Error("a string is not a number")
	}
	if _, ok := numberOf(nil); ok {
		t.Error("nil is not a number")
	}
}

func TestACellAndAPointAreListsOfThreeNumbers(t *testing.T) {
	v := mustParse(t, "{p:[1.5d,2.0d,-3.5d],c:[1,2,3],short:[1,2],words:[\"a\",\"b\",\"c\"]}")
	p, ok := vec3Of(v.Get("p"))
	if !ok || p != [3]float64{1.5, 2, -3.5} {
		t.Errorf("vec3Of = %v, %v", p, ok)
	}
	c, ok := cellOf(v.Get("c"))
	if !ok || c != [3]int32{1, 2, 3} {
		t.Errorf("cellOf = %v, %v", c, ok)
	}
	if _, ok := vec3Of(v.Get("short")); ok {
		t.Error("a list of two is not a point")
	}
	if _, ok := vec3Of(v.Get("words")); ok {
		t.Error("a list of strings is not a point")
	}
}

func TestBoundsAreReadFromAMinAndAMax(t *testing.T) {
	v := mustParse(t, "{bounds:{min:[0,60,0],max:[32,80,40]}}")
	lo, hi, ok := boundsOf(v, "bounds")
	if !ok || lo != [3]int32{0, 60, 0} || hi != [3]int32{32, 80, 40} {
		t.Errorf("boundsOf = %v %v %v", lo, hi, ok)
	}
	if _, _, ok := boundsOf(v, "missing"); ok {
		t.Error("a missing compound has no bounds")
	}
}

func TestARayHitIsAnEntityABlockOrNothing(t *testing.T) {
	entity, err := parseRayHit("{type:\"entity\",pos:[1.0d,2.0d,3.0d],entity_id:77L}")
	if err != nil || entity.Kind != RayEntity || entity.EntityID != 77 || entity.Pos != [3]float64{1, 2, 3} {
		t.Errorf("entity hit = %+v, %v", entity, err)
	}
	block, err := parseRayHit("{type:\"block\",pos:[1.5d,64.0d,2.5d],block:[1,64,2],block_name:\"minecraft:stone\",facing:1}")
	if err != nil || block.Kind != RayBlock || block.Block != [3]int32{1, 64, 2} || block.BlockName != "minecraft:stone" || block.Facing != 1 {
		t.Errorf("block hit = %+v, %v", block, err)
	}
	none, err := parseRayHit("{type:\"none\"}")
	if err != nil || none.Kind != RayNone {
		t.Errorf("no hit = %+v, %v", none, err)
	}
	if _, err := parseRayHit("{type:\"sky\"}"); err == nil {
		t.Error("a type nobody knows is an error")
	}
	if _, err := parseRayHit("{type:\"entity\",pos:[0.0d,0.0d,0.0d]}"); err == nil {
		t.Error("an entity hit with no id is an error")
	}
}

func TestABlockHitWithNoCellIsTheCellOfItsPointRoundedDown(t *testing.T) {
	hit, err := parseRayHit("{type:\"block\",pos:[-0.5d,64.9d,2.5d],facing:0}")
	if err != nil {
		t.Fatal(err)
	}
	if hit.Block != [3]int32{-1, 64, 2} {
		t.Errorf("cell = %v; want [-1 64 2]", hit.Block)
	}
}

func TestAPlotMergeMaskIsNorthEastSouthWestFromTheLowBit(t *testing.T) {
	m := NewPlotMerge(1, 2, true, false, true, false)
	if m.X != 1 || m.Z != 2 || m.Mask != 0b0101 {
		t.Errorf("NewPlotMerge = %+v", m)
	}
	if NewPlotMerge(0, 0, false, false, false, false).Mask != 0 {
		t.Error("no direction is no mask")
	}
}

func TestAPackRefusalNamesItsStatusAndItsReasons(t *testing.T) {
	plain := (&PackError{Status: -3}).Error()
	if !strings.Contains(plain, "-3") {
		t.Errorf("error = %q", plain)
	}
	with := (&PackError{Status: -9, Problems: "bad params"}).Error()
	if !strings.Contains(with, "bad params") {
		t.Errorf("error = %q", with)
	}
}

func TestALaneLeaseCountsACallWhileItIsRunning(t *testing.T) {
	var alive, busy uint32 = 1, 0
	table := uint32(99)
	lease := &LaneLease{lease: 5, table: unsafe.Pointer(&table), alive: &alive, busy: &busy}
	if !lease.IsAlive() {
		t.Fatal("the provider is there")
	}
	tab, _, leave, ok := lease.Enter()
	if !ok || *(*uint32)(tab) != 99 || busy != 1 {
		t.Fatalf("Enter = %v, %v, busy %d", tab, ok, busy)
	}
	leave()
	if busy != 0 {
		t.Errorf("busy = %d after leave", busy)
	}
	alive = 0
	if _, _, _, ok := lease.Enter(); ok {
		t.Error("a provider that is gone cannot be entered")
	}
	if busy != 0 {
		t.Errorf("busy = %d after a refused Enter", busy)
	}
}

func TestAnErrorFromTheHostIsKeptAndAMissingAnswerIsNamed(t *testing.T) {
	if err := okOr(true, nil, "x"); err != nil {
		t.Error(err)
	}
	if err := okOr(false, nil, "writing x"); err == nil || !strings.Contains(err.Error(), "writing x") {
		t.Errorf("okOr = %v", err)
	}
	if _, err := lastOr(nil, true, nil, "the answer"); err == nil {
		t.Error("a slot that sank nothing has no answer")
	}
	if got, err := lastOr([]string{"a", "b"}, true, nil, "x"); err != nil || got != "b" {
		t.Errorf("lastOr = %q, %v", got, err)
	}
}
