local OV = angelsmods.functions.OV
if angelsmods.industries and angelsmods.industries.overhaul then

  OV.modify_output("algae-brown-burning", {"solid-lithium", 1})
  -- OV.remove_unlock("bio-paper-1", "circuit-paper-board")

  -- MODULES
  OV.modify_input("speed-module", {"crystal-splinter-blue"})
  OV.modify_input("speed-module-2", {"crystal-shard-blue"})
  OV.modify_input("speed-module-3", {"crystal-full-blue"})
  OV.modify_input("productivity-module", {"crystal-splinter-red"})
  OV.modify_input("productivity-module-2", {"crystal-shard-red"})
  OV.modify_input("productivity-module-3", {"crystal-full-red"})
  OV.modify_input("effectivity-module", {"crystal-splinter-green"})
  OV.modify_input("effectivity-module-2", {"crystal-shard-green"})
  OV.modify_input("effectivity-module-3", {"crystal-full-green"})
  OV.add_prereq("speed-module", "bio-processing-crystal-splinter-1")
  OV.add_prereq("productivity-module", "bio-processing-crystal-splinter-1")
  OV.add_prereq("effectivity-module", "bio-processing-crystal-splinter-1")
  OV.add_prereq("speed-module-2", "bio-processing-crystal-shard-1")
  OV.add_prereq("productivity-module-2", "bio-processing-crystal-shard-1")
  OV.add_prereq("effectivity-module-2", "bio-processing-crystal-shard-1")
  OV.add_prereq("speed-module-3", "bio-processing-crystal-full")
  OV.add_prereq("productivity-module-3", "bio-processing-crystal-full")
  OV.add_prereq("effectivity-module-3", "bio-processing-crystal-full")

  -- BEACON
  OV.modify_input("beacon", {"crystal-full-harmonic"})
  OV.add_prereq("effect-transmission", "bio-processing-crystal-full")
elseif mods["bobplates"] then
  -- nothing to change
else
  OV.disable_recipe("algae-brown-burning")
end
