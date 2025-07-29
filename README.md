# Execution Scheduling Module (ESM) Documentation

## Overview

The **Execution Scheduling Module (ESM)** manages instruction dispatching within a 32-bit CPU pipeline, specifically at the execute stage. It aims to maximize throughput by dynamically analyzing and issuing independent instructions in parallel, while managing data dependencies and instruction readiness.

---

## Key Architectural Parameters

- **Instruction Set:** 32-bit (RV32I ISA)
- **Instruction Buffer Size:** 16 instructions
- **Register File Size:** 32 registers
- **Decoded Input Signals:** Separate control lines for `regwrite`, `alusrc`, etc., as this unit is integrated after the decode stage

---

## Module Components

### 1. Instruction Buffer
Stores incoming instructions post-decode, up to a maximum of 16.

### 2. BufferValidator
Marks instructions as valid or invalid based on decoding and buffer integrity.

### 3. ESM_Core

Composed of two submodules:
- **ESM_CORE_IDA (Instruction Dependency Analyzer)**
- **ESM_CORE_IIM (Instruction Issue Manager)**

#### 3.1 ESM_CORE_IDA Internals

- **IRT (Instruction Register Tracker)**
  - Tracks source/destination register dependencies.
  - Uses bitmasks (`1 << reg_address`) for tracking register usage.
  - Outputs a dependency mask for each instruction.

- **IDT (Instruction Dependency Table)**
  - Accepts dependency masks from IRT and valid bits from `BufferValidator`.
  - Updates dependencies when instructions are replaced or executed.
  - Iterates over all instructions to generate an independence mask:
    - `1` = independent and valid
    - `0` = dependent or invalid

#### 3.2 ESM_CORE_IIM Internals

- **Mapping Table**
  - Collects buffer indices of independent instructions into a contiguous list.

- **Pseudo-Random Number Generator (PRNG)**
  - Implements an LFSR (Linear Feedback Shift Register) to randomize candidate selection.
  - Ensures fairness and prevents starvation.

- **Index Selection Logic**
  - Selects next instruction index using:
    ```verilog
    next_buffer_index = mapping_table[random_number % candidate_count];
    ```
  - Opportunities exist to eliminate modulo for performance gains.

---

## Instruction Dispatch Protocol

### Execution Start Trigger

- **Trigger Mechanism:** Controlled via a `proceed` signal.
- **Buffer Fill Phase:** When `proceed = 0`, instructions are sequentially stored in buffer.
- **Execution Phase:** When `proceed = 1` (all inputs valid or null instruction detected), control is handed over to `ESM_Core`.

This design avoids premature execution and hazards by ensuring the system is fully ready before issuing instructions.

---

## Design Decisions

### Execution Start Trigger

- **Problem:** Premature execution due to immediate issuing of single instructions.
- **Solution:** Introduce `proceed` signal to gate execution until readiness is verified.

---

## Improvement Areas

| Area                        | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| Issuing Protocol            | Improve balancing of throughput vs correctness.                            |
| Index Mapping Optimization  | Remove `modulo` operation (e.g., use power-of-two buffer sizes, direct hashing). |

