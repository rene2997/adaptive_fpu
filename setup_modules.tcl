puts "Opening multiplier project"
cd adaptive_fpu_out_of_context
open_project ./adaptive_fpu_out_of_context.xpr
set_property board_part digilentinc.com:basys3:part0:1.2 [current_project]
import_files -force -norecurse {../adaptive_fpu/netlists/multiplier/reconfig_module.v ../adaptive_fpu/fpu_wrapper.sv}
update_compile_order -fileset sources_1

puts "Synthesizing each reconfigurable module separately and generating netlists"
synth_design -mode out_of_context -top fpu_wrapper -part xc7a35tcpg236-1

puts "Saving the netlist into the  directory (without XDC to avoid errors on read)"
write_checkpoint -force ../adaptive_fpu/netlists/multiplier/reconfig_module.dcp
puts "Cleaning imported source files to reset project"
remove_files [get_files fpu_wrapper.sv]
remove_files [get_files reconfig_module.v]
close_project


puts "Opening adder project"
open_project ./adaptive_fpu_out_of_context.xpr
set_property board_part digilentinc.com:basys3:part0:1.2 [current_project]
import_files -force -norecurse {../adaptive_fpu/netlists/adder/reconfig_module.v ../adaptive_fpu/fpu_wrapper.sv}
update_compile_order -fileset sources_1

puts "Synthesizing each reconfigurable module separately and generating netlists"
synth_design -mode out_of_context -top fpu_wrapper -part xc7a35tcpg236-1

puts "Saving the netlist into the  directory (without XDC to avoid errors on read)"
write_checkpoint -force ../adaptive_fpu/netlists/adder/reconfig_module.dcp
puts "Cleaning imported source files to reset project"
remove_files [get_files fpu_wrapper.sv]
remove_files [get_files reconfig_module.v]
close_project


puts "Opening divider project"
open_project ./adaptive_fpu_out_of_context.xpr
set_property board_part digilentinc.com:basys3:part0:1.2 [current_project]
import_files -force -norecurse {../adaptive_fpu/netlists/divider/reconfig_module.v ../adaptive_fpu/fpu_wrapper.sv}
update_compile_order -fileset sources_1

puts "Synthesizing each reconfigurable module separately and generating netlists"
synth_design -mode out_of_context -top fpu_wrapper -part xc7a35tcpg236-1

puts "Saving the netlist into the  directory (without XDC to avoid errors on read)"
write_checkpoint -force ../adaptive_fpu/netlists/divider/reconfig_module.dcp
puts "Cleaning imported source files to reset project"
remove_files [get_files fpu_wrapper.sv]
remove_files [get_files reconfig_module.v]
close_project




