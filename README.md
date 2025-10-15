# ⚙️ MIPS-16: 16-bit Pipelined Processor in VHDL  
> 🎓 *Educational MIPS CPU Architecture Implementation with Bubble Sort Demo*

---

## 🧭 Table of Contents
1. [Overview](#-overview)
2. [✨ Features](#-features)
3. [🧩 Architecture](#-architecture)
4. [🧠 Instruction Set](#-instruction-set)
5. [🚀 Pipeline Stages](#-pipeline-stages)
6. [🧱 Data Path & Control Logic](#-data-path--control-logic)
7. [⚔️ Hazard Management](#-hazard-management)
8. [🌀 Bubble Sort Demo Program](#-bubble-sort-demo-program)
9. [🧪 Simulation Guide](#-simulation-guide)
10. [💻 Synthesis & FPGA Notes](#-synthesis--fpga-notes)
11. [📂 Project Structure](#-project-structure)
12. [🧰 Extending the CPU](#-extending-the-cpu)
13. [🐞 Debugging Tips](#-debugging-tips)
14. [🤝 Contributing](#-contributing)
15. [📜 License & Credits](#-license--credits)

---

## 🧭 Overview

**MIPS-16** is a custom **16-bit pipelined CPU** written in **VHDL**, implementing a subset of the MIPS instruction set architecture.  
It is designed for **educational purposes**, demonstrating core CPU concepts such as pipelining, hazard resolution, control flow, and memory operations.

> 🧮 The processor executes a working **Bubble Sort** algorithm — proving its support for loops, branching, and memory access.

📘 **Repository:** [danielgavrila2/MIPS-16](https://github.com/danielgavrila2/MIPS-16)

---

## ✨ Features

| Feature | Description |
|----------|-------------|
| 🧠 **16-bit datapath** | Compact instruction set and architecture |
| 🪄 **5-stage pipeline** | IF → ID → EX → MEM → WB |
| ⚙️ **Hazard detection unit** | Manages stalls, bubbles, and forwarding |
| 🧾 **Harvard memory model** | Separate instruction & data memories |
| 💡 **VHDL-2008 compliant** | Portable across FPGA vendors |
| 🧪 **Testbenches included** | Behavioral & timing simulations |
| 🔄 **Bubble sort example** | Demonstrates full program execution |

---

## 🧩 Architecture

![MIPS-16 Datapath Diagram](https://raw.githubusercontent.com/danielgavrila2/MIPS-16/main/docs/images/datapath.png)

### 🔍 Overview
The MIPS-16 architecture includes:
- Register file with 8 general-purpose registers (r0–r7)
- ALU supporting arithmetic & logic ops
- Program Counter (PC)
- Separate instruction and data memory modules
- Control unit for decoding and pipeline control

---

## 🧠 Instruction Set

| Type | Mnemonic | Description |
|------|-----------|-------------|
| **R-Type** | `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLT` | Register operations |
| **I-Type** | `ADDI`, `ANDI`, `ORI`, `LW`, `SW`, `BEQ`, `BNE` | Immediate and memory operations |
| **J-Type** | `J`, `JAL` | Jumps and subroutine calls |
| **Special** | `NOP`, `HALT` | No-operation and stop execution |

🧾 *Instruction encodings are defined in `src/constants.vhd`.*

---

## 🚀 Pipeline Stages

| Stage | Abbrev. | Description |
|--------|----------|-------------|
| **Instruction Fetch** | IF | Fetch instruction & PC+1 |
| **Instruction Decode** | ID | Decode opcode, read registers |
| **Execute** | EX | Perform ALU operation or branch |
| **Memory Access** | MEM | Load or store data |
| **Write Back** | WB | Write results to register file |

![Pipeline](https://raw.githubusercontent.com/danielgavrila2/MIPS-16/main/docs/images/pipeline_stages.png)

### ⏱️ Pipeline Registers
- `IF/ID` → holds instruction + PC  
- `ID/EX` → holds decoded fields, operands, control bits  
- `EX/MEM` → holds ALU result, memory target address  
- `MEM/WB` → holds memory output or ALU result for writeback

---

## 🧱 Data Path & Control Logic

![Datapath Detail](https://raw.githubusercontent.com/danielgavrila2/MIPS-16/main/docs/images/datapath_detail.png)

- **Register File:** 2 read ports, 1 write port  
- **ALU:** Supports arithmetic, logic, comparisons  
- **Sign Extension:** 8→16-bit for immediates  
- **Control Unit:** Decodes instructions, issues control signals  
- **Memory Units:** Synchronous BRAM-style read/write operations  

---

## ⚔️ Hazard Management

| Hazard Type | Technique Used |
|--------------|----------------|
| **Data Hazard** | Forwarding (EX→EX, MEM→EX) |
| **Load-Use Hazard** | Stall & bubble insertion |
| **Control Hazard** | Flush IF/ID on taken branch |
| **Structural Hazard** | Avoided with dual-memory design |

### 🔁 Forwarding Paths
- EX/MEM → ALU input (for previous instruction results)
- MEM/WB → ALU input (for memory loaded results)

---

## 🌀 Bubble Sort Demo Program

The **Bubble Sort** routine demonstrates correct instruction sequencing, memory access, branching, and data hazards.

### 🧮 Pseudo Assembly

```asm
        LA   r1, arr        ; Base address of array
        LI   r2, N          ; Array size
outer:  LI   r3, 0          ; i = 0
loop1:  SUB  r4, r2, r3
        ADDI r4, r4, -1     ; N - i - 1
        LI   r5, 0          ; j = 0
loop2:  ADD  r6, r1, r5
        LW   r7, 0(r6)      ; A[j]
        ADDI r6, r6, 1
        LW   r8, 0(r6)      ; A[j+1]
        SLT  r9, r8, r7     ; if (A[j+1] < A[j])
        BEQ  r9, r0, noswap
        SW   r8, -1(r6)
        ADDI r6, r6, -1
        SW   r7, 0(r6)
noswap: ADDI r5, r5, 1
        SUB  r4, r4, 1
        BNE  r4, r0, loop2
        ADDI r3, r3, 1
        SUB  r2, r2, 1
        BNE  r2, r0, loop1
        HALT
```

### 🗂️ Memory Initialization
Place the encoded instructions in a memory file (e.g. `instruction.mem`, `init.coe`, or `prog.hex`).

Example line:
```
0x1234
0xABCD
0xCDEF
```

---

## 🧪 Simulation Guide

### 🔹 Vivado / XSIM
```bash
vivado
# Open or create project
add_files src/*.vhd
add_files sim/tb_mips16.vhd
set_property top tb_mips16 [current_fileset]
launch_simulation
run 2000 ns
```

### 🔹 ModelSim
```bash
vcom -2008 src/*.vhd
vcom -2008 sim/tb_mips16.vhd
vsim work.tb_mips16
run 1 ms
```

📈 **Observe Signals:**
- `PC`, `instruction`, `regA/B`, `ALU_result`, `mem_data`
- Forwarding signals and control lines for hazards

---

## 💻 Synthesis & FPGA Notes

| Platform | Status | Notes |
|-----------|---------|-------|
| 🟩 **Xilinx (Vivado)** | ✅ | Tested on Artix-7, Spartan-6 |
| 🟨 **Intel (Quartus)** | ⚠️ | May need memory IP adaptation |
| 🟩 **Lattice / GHDL** | ✅ | Works for simulation & behavioral testing |

💡 *Ensure synchronous BRAM inference for instruction & data memory.*

---

## 📂 Project Structure

```
MIPS-16/
├── src/
│   ├── alu.vhd
│   ├── control_unit.vhd
│   ├── datapath.vhd
│   ├── regfile.vhd
│   ├── hazard_unit.vhd
│   ├── top_mips16.vhd
│   └── opcodes.vhd
├── sim/
│   ├── tb_mips16.vhd
│   ├── instruction.mem
│   └── data.mem
├── docs/
│   └── images/
│       ├── pipeline_stages.png
│       ├── datapath.png
│       └── mips_banner.png
└── README.md
```

---

## 🧰 Extending the CPU

Possible improvements:
- 🧮 Add **Multiply / Divide** units  
- 🧭 Implement **Branch Prediction**  
- 🧱 Introduce **Cache memory** or unified memory  
- 🔐 Add **Exception & Interrupt handling**  
- 🔊 Implement **UART / I/O peripherals**

---

## 🐞 Debugging Tips

| Symptom | Possible Cause |
|----------|----------------|
| Stuck in loop | Branch not taken due to hazard or control bug |
| Wrong data in registers | Missing forwarding path |
| Load delay bug | Missing stall for load-use |
| No instruction fetched | PC stuck / instruction memory not initialized |

🔍 *Check simulation waveforms and ensure memory initialization files are correctly referenced.*

---

## 🤝 Contributing

Pull requests and improvements are welcome!  
Please format VHDL using a consistent indentation style and comment your logic clearly.

1. Fork the repo  
2. Create a feature branch  
3. Commit descriptive messages  
4. Open a PR 🎉  

---

## 📜 License & Credits

This project is released under the **MIT License**.  
Original author: **Daniel Gavrilă**  
Contributors: Community & Open-Source enthusiasts 💙

> 📘 Inspired by the MIPS architecture and educational CPU projects at various universities.

---
