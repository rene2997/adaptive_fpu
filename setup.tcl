puts "Opening project"
cd adaptive_fpu
open_project ./adaptive_fpu.xpr
import_files -force -norecurse {../wildcat/generated/WildcatTop.ScratchPadMem.MEM.v ../wildcat/generated/WildcatTop.ScratchPadMem.MEM_1.v ./adaptive_fpu.srcs/sources_1/new/fpu_wrapper.sv ../wildcat/generated/WildcatTop.ScratchPadMem.MEM_3.v ../wildcat/generated/WildcatTop.ScratchPadMem.MEM_2.v ../wildcat/generated/WildcatTop.v}
update_compile_order -fileset sources_1
set_property file_type SystemVerilog [get_files C:/Users/hajprut/github/adaptive_fpu/adaptive_fpu/adaptive_fpu.srcs/sources_1/imports/adaptive_fpu/wildcat/generated/WildcatTop.ScratchPadMem.MEM.v]
set_property file_type SystemVerilog [get_files C:/Users/hajprut/github/adaptive_fpu/adaptive_fpu/adaptive_fpu.srcs/sources_1/imports/adaptive_fpu/wildcat/generated/WildcatTop.ScratchPadMem.MEM_1.v]
set_property file_type SystemVerilog [get_files C:/Users/hajprut/github/adaptive_fpu/adaptive_fpu/adaptive_fpu.srcs/sources_1/imports/adaptive_fpu/wildcat/generated/WildcatTop.ScratchPadMem.MEM_2.v]
set_property file_type SystemVerilog [get_files C:/Users/hajprut/github/adaptive_fpu/adaptive_fpu/adaptive_fpu.srcs/sources_1/imports/adaptive_fpu/wildcat/generated/WildcatTop.ScratchPadMem.MEM_3.v]
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
open_run synth_1 -name synth_1
write_checkpoint -force ./netlists/static/static.dcp

create_pblock pblock_reconfig_module
add_cells_to_pblock [get_pblocks pblock_reconfig_module] [get_cells -quiet [list fpu]]
resize_pblock [get_pblocks pblock_reconfig_module] -add {SLICE_X38Y15:SLICE_X63Y47}
resize_pblock [get_pblocks pblock_reconfig_module] -add {DSP48_X1Y6:DSP48_X1Y17}
resize_pblock [get_pblocks pblock_reconfig_module] -add {RAMB18_X1Y6:RAMB18_X2Y17}
resize_pblock [get_pblocks pblock_reconfig_module] -add {RAMB36_X1Y3:RAMB36_X2Y8}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_reconfig_module]
set_property SNAPPING_MODE ON [get_pblocks pblock_reconfig_module]
set_property HD.RECONFIGURABLE true [get_cells fpu]



save_constraints
read_checkpoint -cell [get_cells fpu] ./netlists/multiplier/reconfig_module.dcp
set_property HD.RECONFIGURABLE 1 [get_cells fpu]
opt_design
place_design
route_design
write_checkpoint ./netlists/config_multi/config_multi_routed.dcp
update_design -cell [get_cells fpu] -black_box
lock_design -level routing 
write_checkpoint -force ./netlists/staticRouted.dcp



read_checkpoint -cell [get_cells fpu ] 
read_checkpoint -cell [get_cells fpu] ./netlists/adder/reconfig_module.dcp 
opt_design
place_design
route_design