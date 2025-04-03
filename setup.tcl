puts "Remember to put"
cd C:/Users/hajprut/github/adaptive_fpu/adaptive_fpu
puts "Placing the adaptive FPU in the static design"
read_checkpoint -cell [get_cells cpu/fpu] ./netlists/fpu_standard/fpu.dcp
puts "Remember to 'add properties' HD.RECONFIGURABLE"
opt_design
place_design
route_design
