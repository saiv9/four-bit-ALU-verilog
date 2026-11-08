# Design notes — 4-Bit ALU

## Block-level view

```text
        a[3:0] ─────┐
                    │
                    ▼
              ┌───────────┐       result[3:0]
        b[3:0] ─► 4-bit    ├──────────────────►
              │    ALU    │
   alu_sel[2:0]►           ├──► carry_out
              └───────────┘──► borrow_out
                       └──────► zero
```

## Design type

The ALU is combinational: its outputs respond to changes in the operands or operation-select input after normal combinational propagation delay. It has no clock, reset, or internal state.

## Flag definitions

- `carry_out`: the fifth bit of the unsigned addition result. It is cleared for every operation other than addition.
- `borrow_out`: asserted for subtraction when the unsigned value of `a` is smaller than `b`. It is cleared for every operation other than subtraction.
- `zero`: asserted whenever the four-bit `result` equals zero.

For example, `4'hF + 4'h1` produces `result = 4'h0` and `carry_out = 1`. `4'h2 - 4'h5` produces `result = 4'hD` and `borrow_out = 1`.

## Verification approach

The testbench iterates through all 256 possible operand pairs. For each pair it checks ADD, SUB, AND, OR, XOR and NOT-A, then checks the two reserved operation codes with representative inputs. Comparisons use case inequality (`!==`) so unknown (`X`/`Z`) values are treated as failures.
