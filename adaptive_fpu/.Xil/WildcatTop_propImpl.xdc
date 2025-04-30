set_property SRC_FILE_INFO {cfile:C:/Users/hajprut/github/adaptive_fpu/adaptive_fpu/adaptive_fpu.srcs/constrs_2/new/prConstraints.xdc rfile:../adaptive_fpu.srcs/constrs_2/new/prConstraints.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:1 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_reconfig_module
add_cells_to_pblock [get_pblocks pblock_reconfig_module] [get_cells -quiet [list fpu]]
resize_pblock [get_pblocks pblock_reconfig_module] -add {SLICE_X38Y3:SLICE_X63Y48}
resize_pblock [get_pblocks pblock_reconfig_module] -add {DSP48_X1Y2:DSP48_X1Y17}
resize_pblock [get_pblocks pblock_reconfig_module] -add {RAMB18_X1Y2:RAMB18_X2Y17}
resize_pblock [get_pblocks pblock_reconfig_module] -add {RAMB36_X1Y1:RAMB36_X2Y8}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_reconfig_module]
set_property SNAPPING_MODE ON [get_pblocks pblock_reconfig_module]
