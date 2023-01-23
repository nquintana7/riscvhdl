# riscvhdl
A simple RISC-V implementation in VHDL. It is a single cycle, no pipeline version, based on the version in the book "Digital Design and Computer Architecture RISC-V Ed.".
My goal is to expand it to support pipeline, interface with a external ddr3 ram and run a mini kernel on top of it.

For now it supports only the following instructions: add, sub, and, or, slt, addi, lw, sw, beq, jal
Which are tested on the test programm loaded to the instruction memory and verified on a simulation, it was also tested on an Arty A7 FPGA. It sends the last written value in memory over UART.
