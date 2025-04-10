# Project and module definitions
PROJECT := adaptive_fpu
TOP_MODULE ?= WildcatTop
TEST_MODULE ?= test_memory
FPU := fpu.sv

# directory layout
SRC_DIR := ../wildcat/generated
TB_DIR := .
OBJ_DIR := obj_dir    # verilator will generate obj_dir/

# file lists
SRCS := $(wildcard $(SRC_DIR)/*.v)
TB   := $(TEST_MODULE).sv

# verilator compilation
$(OBJ_DIR)/V$(TEST_MODULE): $(TB) $(SRCS)
	verilator --cc $(TB) $(SRCS) $(FPU) \
		--top-module $(TEST_MODULE) \
		--Mdir $(OBJ_DIR) \
		--exe --trace

	# Build the C++ simulation executable
	make -C $(OBJ_DIR) -f V$(TEST_MODULE).mk V$(TEST_MODULE)

# Run simulation
test: $(OBJ_DIR)/V$(TEST_MODULE)
	./$(OBJ_DIR)/V$(TEST_MODULE)

clean:
	rm -rf $(OBJ_DIR) *.vcd

.PHONY: compile clean test
