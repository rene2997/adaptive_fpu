# Project and module definitions
PROJECT := adaptive_fpu
TOP_MODULE ?= WildcatTop
TEST_MODULE ?= test_fpu  # Default testbench

# Directory layout
OBJ_DIR := obj_dir
APP := fp_operation.S

# Common source files
COMMON_SRCS := ../external/fpu/multiplier/multiplier.v

# Source files per testbench
ifeq ($(TEST_MODULE),test_fpu)
  SRCS := $(COMMON_SRCS) ../external/fpu_wrapper.sv
endif

ifeq ($(TEST_MODULE),test_mem_arbiter)
  SRCS := $(COMMON_SRCS) $(wildcard ../wildcat/generated/*.v) $(wildcard ../external/*.sv)
endif

TB := $(TEST_MODULE).sv


HEX_FILES := data0.hex data1.hex data2.hex data3.hex
HEX_SRC_DIR := ../wildcat/
HEX_DST_DIR := .

copy-hex:
	cp $(addprefix $(HEX_SRC_DIR)/, $(HEX_FILES)) $(HEX_DST_DIR)

# Verilator compilation
$(OBJ_DIR)/V$(TEST_MODULE): $(TB) $(SRCS)
	verilator --binary -j 0 $(TB) $(SRCS) --top-module $(TEST_MODULE) --trace --trace-structs --trace-depth 2

# Run simulation
test: $(OBJ_DIR)/V$(TEST_MODULE)
	./$(OBJ_DIR)/V$(TEST_MODULE)

# Assembly to object file
app:
	riscv64-unknown-elf-as -march=rv32ia_zicsr $(APP) -o fp_app.o
	riscv64-unknown-elf-ld -m elf32lriscv -T link.ld fp_app.o -o fp_app.out

# Run hardware simulation via SBT
hw: app
	cd ../wildcat && sbt "runMain wildcat.pipeline.WildcatTop ../verilator/fp_app.out" && cd - > /dev/null

# Helper test targets
test-fpu:
	$(MAKE) test TEST_MODULE=test_fpu

test-mem: hw copy-hex
	$(MAKE) test TEST_MODULE=test_mem_arbiter

clean:
	$(RM) -rf $(OBJ_DIR) *.vcd *.o *.elf

.PHONY: compile clean test test-fpu test-mem
