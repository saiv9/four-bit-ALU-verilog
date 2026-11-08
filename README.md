# 4-Bit Arithmetic Logic Unit (ALU) — Verilog HDL

A beginner-level VLSI / digital-design project for B.Tech ECE students. The project implements a **4-bit combinational ALU** using Verilog-2001 and verifies it with a self-checking testbench.

## Features

- 4-bit inputs `a` and `b`
- Six operations: addition, subtraction, AND, OR, XOR and NOT-A
- `carry_out` flag for addition
- `borrow_out` flag for subtraction
- `zero` flag when the result is `0000`
- Default output for the two reserved operation codes
- Exhaustive testbench over all 16 × 16 input combinations for the six operations

## Operation table

| `alu_sel` | Operation | Result | Flags |
|---|---|---|---|
| `000` | Addition | `a + b` (4-bit result) | `carry_out` reports the fifth bit |
| `001` | Subtraction | `a - b` (4-bit result) | `borrow_out = 1` when `a < b` |
| `010` | AND | `a & b` | Carry and borrow are 0 |
| `011` | OR | `a \| b` | Carry and borrow are 0 |
| `100` | XOR | `a ^ b` | Carry and borrow are 0 |
| `101` | NOT-A | `~a` | Carry and borrow are 0 |
| `110` | Reserved | `0000` | Carry and borrow are 0 |
| `111` | Reserved | `0000` | Carry and borrow are 0 |

`zero` is 1 whenever `result` is `0000`, including for a reserved operation code.

## Repository structure

```text
four_bit_alu_vlsi/
├── rtl/
│   └── alu_4bit.v
├── tb/
│   └── tb_alu_4bit.v
├── docs/
│   └── DESIGN_NOTES.md
├── .github/workflows/
│   └── simulation.yml
├── Makefile
├── .gitignore
├── README.md
└── LINKEDIN_POST.md
```

## Run simulation

Install [Icarus Verilog](https://steveicarus.github.io/iverilog/) and GNU Make. From the project root, run:

```bash
make sim
```

Or compile and run directly:

```bash
iverilog -g2005 -o alu_sim rtl/alu_4bit.v tb/tb_alu_4bit.v
vvp alu_sim
```

Expected successful output:

```text
PASS: all ALU tests completed successfully.
```

The testbench checks every pair of 4-bit input values for all six supported operations, plus both reserved operation codes. It checks the result and all three flags.

## View waveforms (optional)

```bash
make wave
```

This creates `alu.vcd`. Open it with GTKWave. The waveform target requires GTKWave to be installed.

## Synthesis (optional)

Install [Yosys](https://yosyshq.net/yosys/) and run:

```bash
make synth
```

This performs a simple synthesis/statistics pass. It is not a placement, routing, or timing-closure result.

## What to learn from this project

1. How a combinational RTL block is described using `always @(*)` and `case`.
2. How to avoid latch inference by assigning defaults to outputs.
3. How to represent arithmetic carry and subtraction borrow.
4. How to write a self-checking testbench and compare outputs with expected values.
5. How simulation and synthesis fit into a basic RTL design flow.

## Limitations / possible improvements

This is an educational 4-bit ALU, not a production processor datapath. Possible extensions include a parameterized width, signed arithmetic and overflow flag, logical shifts, a registered ALU, and constrained-random verification.

## Author checklist

Before adding this to a portfolio, run the simulation yourself, inspect a few waveforms, and make sure you can explain the operation table, carry/borrow behavior, and testbench. Do not claim FPGA implementation or physical silicon testing unless you actually complete those steps.
