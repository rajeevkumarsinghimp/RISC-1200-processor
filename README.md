# Please go to other branch for the code and seeing project
#

# RISC1200-processor
This project serves to simulate and validate the behavior of a RISC processor in Verilog, demonstrating the sequential execution of instructions through multiple pipeline stages (Fetch, Decode, Execute, Memory, Write Back). It includes handling of basic ALU operations, immediate operations, memory accesses, and branch instructions.
The processor nowadays have various stages of operation for increasing the overall speed for instruction execution by the use of pipelining
#
![stages used for pipelining](https://github.com/rajeevkumarsinghimp/RISC-1200-processor/assets/174273198/f564c956-2b19-47fb-83fe-7364d204f3ea)

#
The pipelining stages reduces the execution time by processing the instruction in various stages the instructions gets loaded like water once we get the first output through the processor in the next clock we get the output for the next instruction in general cases if there is no pipelining hazard 
#
![pipeline implemetation](https://github.com/rajeevkumarsinghimp/RISC-1200-processor/assets/174273198/8a8a273c-239a-4b05-9d65-1b61ea433fd9)

#
The overall general RISC block diagram or hardware looks like
#
![processor_final](https://github.com/rajeevkumarsinghimp/RISC-1200-processor/assets/174273198/44226a50-997b-43c0-8d75-62b4591c0963)
#
the tesbench output looks like this
#
![Testbench output](https://github.com/rajeevkumarsinghimp/RISC-1200-processor/assets/174273198/7c126fd2-35c8-417c-ae34-a075987905e5)
