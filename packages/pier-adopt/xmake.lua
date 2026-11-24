-- pier-adopt: loads the pier mods LeviLamina refused for naming the host "pier", where
-- the host's manifest name is "Pier". An optional capability on both targets.
--
-- It registers one bootstrap step and fills no slot. Without this package such a mod
-- stays refused, LeviLamina's own error line is the only report, and nothing else in the
-- host changes.
target("pier-adopt")
    pier_common()
    set_kind("object")
    -- object and not static. Every TU in this package registers itself into the host
    -- SPI through a file-level static object and no external symbol references them.
    -- Inside a static library the linker drops such an object entirely, and the
    -- symptom is a capability that disappears silently (contract §1 rule 4). The
    -- `object-kind` check guards this.
    add_deps("pier-abi", "pier-support", "pier-host")
    add_packages("levilamina")
    add_files("src/*.cpp")
target_end()
