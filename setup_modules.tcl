set current_dir [pwd]
open_project adaptive_fpu_out_of_context/adaptive_fpu_out_of_context.xpr
update_compile_order -fileset sources_1

puts "Synthesizing each reconfigurable module separately and generating netlists"
synth_design -mode out_of_context -top fpu -part xc7a100tfgg676-1

puts "Saving the netlist into the stated directory (without XDC to avoid errors on read)"
write_checkpoint ./netlists/fpu_1/fpu.dcp -force