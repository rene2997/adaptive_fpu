# Adaptive FPU
An adaptive that is integrated into the Wildcat design as an optional extension that handles floating-point operations. It is memory-mapped and controlled a via a memory arbiter. This enables the processor to offload FP computations while maintaning a simple, modular interface.


## Compile
To run the TCL-script ensure that Vivado is in your system path. 
```bash
vivado -mode batch -source setup.tcl
```

