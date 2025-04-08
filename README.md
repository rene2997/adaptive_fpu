# Adaptive FPU
An adaptive that is integrated into the Wildcat design as an optional extension that handles floating-point operations. It is memory-mapped and controlled a via a memory arbiter. This enables the processor to offload FP computations while maintaning a simple, modular interface.


## Compile
To run setup the docker environment for x86_64 architectures you need to build and then run it. 
```bash
docker build -t wildcat-env .
````
```bash
docker run -it -v $(pwd):/app wildcat-env
````

For amd64 architectures use the following commands instead.
```bash
docker build --platform=linux/amd64 -t wildcat-env .
````
```bash
docker run --platform=linux/amd64 -it -v $(pwd):/app wildcat-env
````
To build, run, and test Wildcat use the following 
```bash
cd wildcat
make APP=asm/apps/fp_operation.s hw
```

## Test in verilator




## TCL-script in Vivado




## TCL-script in Vivado

To run the TCL-script ensure that Vivado is in your system path. 
```bash
vivado -mode batch -source setup.tcl
```



