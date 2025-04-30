# For Vivado init. : cd C:/Users/hajprut/github/adaptive_fpu/adaptive_fpu
puts "Opening project"
cd adaptive_fpu
open_project ./adaptive_fpu.xpr
remove_files [get_files fpu_wrapper.sv]
remove_files [get_files reconfig_module.v]
remove_files [get_files WildcatTop.v]
remove_files [get_files WildcatTop.ScratchPadMem.MEM.v]
remove_files [get_files WildcatTop.ScratchPadMem.MEM_1.v]
remove_files [get_files WildcatTop.ScratchPadMem.MEM_2.v]
remove_files [get_files WildcatTop.ScratchPadMem.MEM_3.v]
remove_files [get_files reconfig_module.dcp]

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

# only create if it isn't there
if { [llength [get_pblocks -quiet pblock_reconfig_module]] == 0 } {
  create_pblock pblock_reconfig_module
  add_cells_to_pblock [get_pblocks pblock_reconfig_module] [get_cells -quiet [list fpu]]
  resize_pblock [get_pblocks pblock_reconfig_module] -add {SLICE_X38Y15:SLICE_X63Y47}
  resize_pblock [get_pblocks pblock_reconfig_module] -add {DSP48_X1Y6:DSP48_X1Y17}
  resize_pblock [get_pblocks pblock_reconfig_module] -add {RAMB18_X1Y6:RAMB18_X2Y17}
  resize_pblock [get_pblocks pblock_reconfig_module] -add {RAMB36_X1Y3:RAMB36_X2Y8}
  resize_pblock pblock_reconfig_module -add {SLICE_X38Y15:SLICE_X63Y60 DSP48_X1Y6:DSP48_X1Y23 RAMB18_X1Y6:RAMB18_X2Y23 RAMB36_X1Y3:RAMB36_X2Y11} -remove {SLICE_X38Y15:SLICE_X63Y47 DSP48_X1Y6:DSP48_X1Y17 RAMB18_X1Y6:RAMB18_X2Y17 RAMB36_X1Y3:RAMB36_X2Y8 SLICE_X38Y15:SLICE_X63Y47 DSP48_X1Y6:DSP48_X1Y17 RAMB18_X1Y6:RAMB18_X2Y17 RAMB36_X1Y3:RAMB36_X2Y8} -locs keep_all
resize_pblock pblock_reconfig_module -from SLICE_X38Y15:SLICE_X63Y60 -to SLICE_X38Y2:SLICE_X63Y47 -from DSP48_X1Y6:DSP48_X1Y23 -to DSP48_X1Y2:DSP48_X1Y17 -from RAMB18_X1Y6:RAMB18_X2Y23 -to RAMB18_X1Y2:RAMB18_X2Y17 -from RAMB36_X1Y3:RAMB36_X2Y11 -to RAMB36_X1Y1:RAMB36_X2Y8 -locs keep_all
resize_pblock pblock_reconfig_module -from SLICE_X38Y15:SLICE_X63Y60 -to SLICE_X38Y3:SLICE_X63Y48 -from DSP48_X1Y6:DSP48_X1Y23 -to DSP48_X1Y2:DSP48_X1Y17 -from RAMB18_X1Y6:RAMB18_X2Y23 -to RAMB18_X1Y2:RAMB18_X2Y17 -from RAMB36_X1Y3:RAMB36_X2Y11 -to RAMB36_X1Y1:RAMB36_X2Y8 -locs keep_all
  set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_reconfig_module]
  set_property SNAPPING_MODE ON [get_pblocks pblock_reconfig_module]
  set_property HD.RECONFIGURABLE true [get_cells fpu]
}

save_constraints

if { [llength [get_cells fpu]] > 0 && [get_property IS_BLACKBOX [get_cells fpu]] == 0 } {
  update_design -cell [get_cells fpu] -black_box
}
read_checkpoint -cell [get_cells fpu] ./netlists/multiplier/reconfig_module.dcp
set_property HD.RECONFIGURABLE 1 [get_cells fpu]
opt_design
place_design
route_design
write_checkpoint -force ./netlists/config_multi/config_multi_routed.dcp
report_timing_summary
report_power


if { [llength [get_cells fpu]] > 0 && [get_property IS_BLACKBOX [get_cells fpu]] == 0 } {
  update_design -cell [get_cells fpu] -black_box
}
lock_design -level routing 
write_checkpoint -force ./netlists/staticRouted.dcp
read_checkpoint -cell [get_cells fpu] ./netlists/adder/reconfig_module.dcp 
opt_design
place_design
route_design
write_checkpoint -force ./netlists/config_adder/config_adder_routed.dcp
report_timing_summary
report_power


if { [llength [get_cells fpu]] > 0 && [get_property IS_BLACKBOX [get_cells fpu]] == 0 } {
  update_design -cell [get_cells fpu] -black_box
}
lock_design -level routing 
read_checkpoint -cell [get_cells fpu] ./netlists/divider/reconfig_module.dcp 
opt_design
place_design
route_design
write_checkpoint -force ./netlists/config_divider/config_divider_routed.dcp
report_timing_summary
report_power





