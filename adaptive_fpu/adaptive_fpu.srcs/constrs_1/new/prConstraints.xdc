add_cells_to_pblock [get_pblocks pblock_fpu] [get_cells -quiet [list cpu/fpu]]


create_pblock pblock_fpu
resize_pblock [get_pblocks pblock_fpu] -add {SLICE_X28Y25:SLICE_X71Y74}
resize_pblock [get_pblocks pblock_fpu] -add {DSP48_X1Y10:DSP48_X1Y29}
resize_pblock [get_pblocks pblock_fpu] -add {RAMB18_X1Y10:RAMB18_X1Y29}
resize_pblock [get_pblocks pblock_fpu] -add {RAMB36_X1Y5:RAMB36_X1Y14}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_fpu]
set_property SNAPPING_MODE ON [get_pblocks pblock_fpu]
