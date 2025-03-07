# N-Bit-Full-Adder Design Using Verilog
# N-bit Ripple Carry Adder in Verilog

This repository contains a **parameterizable N-bit Ripple Carry Adder** implemented in Verilog. The design is hierarchical and scalable, allowing flexible bit-width configurations.

## Overview

The design consists of three key modules:

- **Full_Adder** - A 1-bit full adder module.
- **Full_Adder_N** - A parameterizable **N-bit ripple carry adder** using multiple **Full_Adder** instances.
- **Adder** - A **32-bit adder** implemented using four **8-bit adders** with pipelined output storage.

## Module Descriptions

### Full_Adder (1-bit Full Adder)
This module implements a **1-bit Full Adder** with **gate delays**.

#### Inputs:
- `in1`  : First input bit  
- `in2`  : Second input bit  
- `cin`  : Carry input  

#### Outputs:
- `Sum`  : Sum output  
- `cout` : Carry output  

#### Logic:
- Sum = `in1 XOR in2 XOR cin` (with a delay of 4 units)  
- Carry = `(in1 & in2) | (in1 & cin) | (in2 & cin)` (with a delay of 2 units)  

---

### Full_Adder_N (N-bit Ripple Carry Adder)
This module builds an **N-bit Ripple Carry Adder** using **N instances of Full_Adder**.

#### Inputs:
- `ra [N-1:0]` : First N-bit operand  
- `rb [N-1:0]` : Second N-bit operand  
- `cin`        : Carry input  

#### Outputs:
- `Sum [N-1:0]` : N-bit sum output  
- `Cout`        : Carry-out of the final full adder stage  

#### Logic:
- The carry propagates through **N** stages using **Full_Adder** instances.  
- The first stage takes `cin` as input, and subsequent stages propagate the carry to the next.

---

### Adder (32-bit Adder Using 8-bit Blocks & Pipelining)
This module extends the adder to **32-bit**, using **four 8-bit adders (Full_Adder_N)** and registers for pipelined storage.

#### Inputs:
- `ra [31:0]`  : First 32-bit operand  
- `rb [31:0]`  : Second 32-bit operand  
- `cin`        : Initial carry input  
- `TClk`       : Clock signal for pipelining  

#### Outputs:
- `Sum [31:0]` : 32-bit sum output  
- `Cout`       : Final carry output  

#### Logic:
- The 32-bit addition is split into **four 8-bit blocks**.
- Carry propagates through each block in a ripple-carry manner.
- A **register-based pipeline** ensures `Sum` and `Cout` are stored on the **rising edge** of `TClk`, improving timing performance.

---

## Parameterization
- The design can be easily scaled to **any N-bit width** by modifying `Full_Adder_N`.
- To change the adder size, replace `8` or `32` with a variable `N` and instantiate `Full_Adder_N` accordingly.

---

## Simulation & Testing
To verify the functionality:
1. Write a **testbench** (`Adder_tb.v`) to apply test vectors.
2. Use tools like **ModelSim**, **Xilinx Vivado**, or **Icarus Verilog** for simulation.
3. Check waveforms using **GTKWave** or built-in tools.

### Running the Simulation (Using Icarus Verilog)
```sh
# Clone the repository
git clone https://github.com/your-username/N-bit-ripple-carry-adder.git
cd N-bit-ripple-carry-adder

# Compile the design and testbench
iverilog -o adder_test Adder.v Adder_tb.v

# Run the simulation
vvp adder_test

# View waveforms (if VCD dump is enabled)
gtkwave dump.vcd

