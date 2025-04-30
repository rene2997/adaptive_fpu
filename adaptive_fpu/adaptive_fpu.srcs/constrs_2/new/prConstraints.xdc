create_pblock pblock_reconfig_module
add_cells_to_pblock [get_pblocks pblock_reconfig_module] [get_cells -quiet [list fpu]]
resize_pblock [get_pblocks pblock_reconfig_module] -add {SLICE_X38Y3:SLICE_X63Y48}
resize_pblock [get_pblocks pblock_reconfig_module] -add {DSP48_X1Y2:DSP48_X1Y17}
resize_pblock [get_pblocks pblock_reconfig_module] -add {RAMB18_X1Y2:RAMB18_X2Y17}
resize_pblock [get_pblocks pblock_reconfig_module] -add {RAMB36_X1Y1:RAMB36_X2Y8}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_reconfig_module]
set_property SNAPPING_MODE ON [get_pblocks pblock_reconfig_module]

set_property HD.RECONFIGURABLE true [get_cells fpu]







