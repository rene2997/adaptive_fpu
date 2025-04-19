# Project and module definitions
PROJECT := adaptive_fpu
TOP_MODULE ?= WildcatTop
TEST_MODULE ?= test_fpu  # Default testbench

# Directory layout
SRC_DIR := ../external 
SRC_DIR += ../wildcat/generated
TB_DIR := .
OBJ_DIR := obj_dir
APP := fp_operation.S

# File lists
SRCS := ../external/fpu/multiplier/multiplier.v
SRCS += ../external/fpu_wrapper.sv
SRCS += $(wildcard ../wildcat/generated/*.v)
TB   := $(TEST_MODULE).sv

# Verilator compilation
$(OBJ_DIR)/V$(TEST_MODULE): $(TB) $(SRCS)
	verilator --binary -j 0 $(TB) $(SRCS) --top-module $(TEST_MODULE) --trace --trace-structs --trace-depth 2

# Run simulation
test: $(OBJ_DIR)/V$(TEST_MODULE)
	./$(OBJ_DIR)/V$(TEST_MODULE)

# Assembly to ELF
app:
	riscv64-unknown-elf-as -march=rv32ia_zicsr $(APP) -o fp_app.o
	riscv64-unknown-elf-ld -m elf32lriscv -T link.ld fp_app.o -o fp_app.elf

# Optional helper targets for specific testbenches
test-fpu:
	$(MAKE) test TEST_MODULE=test_fpu

test-mem: app
	$(MAKE) test TEST_MODULE=test_mem_arbiter

clean:
	$(RM) -rf $(OBJ_DIR) *.vcd *.o *.elf

.PHONY: compile clean test test-fpu test-mem
