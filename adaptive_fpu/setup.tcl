puts "Opening project"
cd adaptive_fpu
open_project ./adaptive_fpu.xpr
import_files -norecurse {adaptive_fpu/wildcat/generated/WildcatTop.ScratchPadMem.MEM.v adaptive_fpu/wildcat/generated/WildcatTop.ScratchPadMem.MEM_1.v adaptive_fpu/external/fpu_wrapper.sv adaptive_fpu/wildcat/generated/WildcatTop.ScratchPadMem.MEM_3.v adaptive_fpu/wildcat/generated/WildcatTop.ScratchPadMem.MEM_2.v adaptive_fpu/wildcat/generated/WildcatTop.v adaptive_fpu/external/fpu/multiplier/multiplier.v}
update_compile_order -fileset sources_1






puts "Placing the adaptive FPU in the static design"
read_checkpoint -cell [get_cells cpu/fpu] ./netlists/fpu_standard/fpu.dcp
puts "Remember to 'add properties' HD.RECONFIGURABLE"
opt_design
place_design
route_design
update_design -cell [get_cells cpu/fpu] -black_box
lock_design -level routing
write_checkpoint ./netlists/static/staticRouted.dcp