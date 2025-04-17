# Project and module definitions
PROJECT := adaptive_fpu
TOP_MODULE ?= WildcatTop
TEST_MODULE ?= test_fpu
FPU := fpu.sv

# directory layout
SRC_DIR := ../wildcat/generated
TB_DIR := .
# verilator will generate obj_dir/
OBJ_DIR := obj_dir

# file lists
SRCS := $(wildcard $(SRC_DIR)/*.v)
TB   := $(TEST_MODULE).sv

# verilator compilation
$(OBJ_DIR)/V$(TEST_MODULE): $(TB) $(SRCS) $(FPU)
	verilator --binary -j 0 $(TB) $(SRCS) $(FPU) --top-module $(TEST_MODULE) --trace

# Run simulation
test: $(OBJ_DIR)/V$(TEST_MODULE)
	./$(OBJ_DIR)/V$(TEST_MODULE)

clean:
	$(RM) -rf $(OBJ_DIR) *.vcd

.PHONY: compile clean test


