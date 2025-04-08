# Project and module definitions
PROJECT := adaptive_fpu
TOP_MODULE ?= WildcatTop
TEST_MODULE ?= test_memory

# Directory layout
SRC_DIR := ../wildcat/generated
TB_DIR := .           # Testbench directory is current
OBJ_DIR := obj_dir    # Verilator will generate obj_dir/

# File lists
SRCS := $(wildcard $(SRC_DIR)/*.v)
TB   := $(TEST_MODULE).v

# Verilator compilation
$(OBJ_DIR)/V$(TEST_MODULE): $(TB) $(SRCS)
	verilator --cc $(TB) $(SRCS) \
		--top-module $(TEST_MODULE) \
		--Mdir $(OBJ_DIR) \
		--exe --trace

	# Build the C++ simulation executable
	make -C $(OBJ_DIR) -f V$(TEST_MODULE).mk V$(TEST_MODULE)

# Run simulation
test: $(OBJ_DIR)/V$(TEST_MODULE)
	./$(OBJ_DIR)/V$(TEST_MODULE)

# Clean
clean:
	rm -rf $(OBJ_DIR) *.vcd

.PHONY: compile clean test