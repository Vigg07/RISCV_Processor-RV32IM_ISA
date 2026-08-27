# 32-bit RISC-V Processor (RV32IM)

This repository contains the RTL design and verification of a 32-bit RISC-V processor supporting the RV32IM instruction set, implemented in both **Single-Cycle** and **5-Stage Pipelined** architectures.

The processor is designed from scratch in Verilog, with a modular datapath and dedicated control logic. The 5-stage pipeline extends the single-cycle design with pipeline registers, data forwarding, hazard detection, and control-hazard handling.

## Features

* RV32IM Instruction Set Support
    * RV32I Base Integer Instructions
    * M Extension instructions for integer multiplication and division

* Two Processor Architectures
    * Single-Cycle RV32IM Processor
    * 5-Stage Pipelined RV32IM Processor

* 5-Stage Pipeline
    * Instruction Fetch (IF)
    * Instruction Decode (ID)
    * Execute (EX)
    * Memory Access (MEM)
    * Write Back (WB)

* Data Hazard Handling
    * EX/MEM forwarding
    * MEM/WB forwarding
    * Load-use hazard detection
    * Pipeline stalling

* Control Hazard Handling
    * Branch detection
    * Pipeline flushing
    * JAL handling
    * JALR handling

* Modular RTL Design
    * Separate instruction and data memories
    * Dedicated register file
    * Main decoder and ALU decoder
    * Immediate generator
    * Forwarding unit
    * Load-use hazard detection unit
    * Pipeline registers
    * Branch and jump control logic
    * Multiply/divide unit

* Synthesizable RTL
    * Written using standard Verilog constructs
    * Designed for simulation, synthesis, and future FPGA implementation

## Architecture Components

### Common Components

* ALU
    * Performs arithmetic and logical operations
    * Supports operations required by RV32I and RV32M

* ALU Decoder
    * Generates ALU control signals based on instruction fields

* Main Decoder
    * Generates control signals from the instruction opcode

* Register File
    * 32 × 32-bit registers
    * Two read ports
    * One write port
    * x0 is hardwired to zero

* Immediate Generator
    * Generates and sign-extends I-Type, S-Type, B-Type, and J-Type immediates

* Instruction Memory
    * Stores program instructions
    * Initialized using .mem files during simulation

* Data Memory
    * Handles load and store operations

* PC Control
    * Handles PC+4 execution
    * Branch target selection
    * JAL target selection
    * JALR target selection

* Multiply/Divide Unit
    * Implements RV32M integer multiplication and division operations


## Single-Cycle Processor

The single-cycle processor completes each instruction in one clock cycle.

The datapath contains:

* Program Counter
* Instruction Memory
* Register File
* Immediate Generator
* ALU
* Main Decoder
* ALU Decoder
* Data Memory
* Branch/Jump Control
* Write-Back Logic

The single-cycle implementation serves as the baseline architecture for understanding and validating the RV32IM instruction execution before introducing pipelining.


## 5-Stage Pipelined Processor

The pipelined processor divides instruction execution into five stages:

    IF  →  ID  →  EX  →  MEM  →  WB

### IF - Instruction Fetch

* Generates the current PC
* Fetches the instruction
* Calculates PC+4

### ID - Instruction Decode

* Decodes the instruction
* Reads register operands
* Generates the immediate value
* Generates control signals

### EX - Execute

* Performs ALU operations
* Calculates branch and jump targets
* Performs branch comparisons
* Handles operand forwarding

### MEM - Memory Access

* Performs load operations
* Performs store operations
* Interfaces with data memory

### WB - Write Back

* Selects ALU or memory result
* Writes the result back to the register file


## Pipeline Hazard Handling

The 5-stage pipeline includes hardware mechanisms to handle hazards introduced by overlapping instructions.

### Data Forwarding

The forwarding unit detects dependencies between instructions and forwards results from later pipeline stages directly to the EX stage.

Forwarding paths include:

    EX/MEM → EX
    MEM/WB → EX

This reduces unnecessary pipeline stalls for common data dependencies.

### Load-Use Hazard

When an instruction immediately uses a value loaded from memory by the previous instruction, forwarding alone is insufficient.

The hazard detection unit therefore:

* Detects the load-use dependency
* Stalls the pipeline
* Holds the PC and IF/ID pipeline register
* Inserts a bubble into the EX stage

### Control Hazards

Branches and jumps can cause instructions that were already fetched to become invalid.

The processor handles this using pipeline flushing for:

* Conditional branches
* JAL
* JALR


## Tools Used

* HDL: Verilog
* Simulation: Xilinx Vivado
* Target Architecture: RISC-V RV32IM
* Target Platform: FPGA-oriented synthesizable RTL


## Folder Structure

```text
rv32im-processor/
│
├── single_cycle/
│   ├── src/
│   │   ├── ALU/
│   │   ├── ID/
│   │   ├── MEM/
│   │   ├── WB/
│   │   ├── datapath.v
│   │   └── rv32im_processor.v
│   │
│   ├── sim/
│       ├── rv32im_processor_tb.v
│       └── instr.mem
│   
│   
│
├── pipelined/
│   ├── src/
│   │   ├── IF/
│   │   ├── ID/
│   │   ├── EX/
│   │   ├── MEM/
│   │   ├── WB/
│   │   ├── datapath.v
│   │   └── rv32im_processor.v
│   │
│   ├── sim/
│       ├── rv32im_processor_tb.v
│       └── instr.mem
│   
│   
│
├── docs/
│   ├── single_cycle_datapath.png
│   └── pipelined_datapath.png
│
└── README.md
