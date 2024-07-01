module risc1200_tb;
    reg clk1, clk2;
    integer k;

    // Instantiate the main module
    main risc1200(clk1, clk2);

    // Clock generation
    initial begin
        clk1 = 0; 
        clk2 = 0; 
        repeat(20) begin 
            #5 clk1 = 1; 
            #5 clk1 = 0;
            #5 clk2 = 1; 
            #5 clk2 = 0;
        end
    end

    initial begin
        // Initialize registers
        for (k = 0; k < 32; k = k + 1) risc1200.Reg_[k] = k+3;  // Changed Reg to Reg_
        
        risc1200.pc = 32'b0;
       risc1200.Mem[0] = 32'b00000100001000100001100000000000;  // ADD R1, R2, R3
        risc1200.Mem[1] = 32'b00100100100001010000000000001010;  // ADDI R4, R5, 10
        risc1200.Mem[2] = 32'b00001011110001110010000000000000;  // SUB R30, R7, R4
        risc1200.Mem[3] = 32'b00101101001010100000000000001111;  // ANDI R9, R10, 15
        risc1200.Mem[4] = 32'b00110001011011000000000000010100;  // ORI R11, R12, 20
        risc1200.Mem[5] = 32'b00011000000000100000000000000000;  // LW R13, 0(R2)
        risc1200.Mem[6] = 32'b00011101111000000000000000000100;  // SW R15, 4(R0)
        risc1200.Mem[7] = 32'b00101000111010110000000000000100;  // SUBI R7, R11, 4
        risc1200.Mem[8] = 32'b00110101000011010000000000000001;  // SLI R8, R13, 1
        risc1200.Mem[9] = 32'b00111001011011110000000000000010; // SRI R11, R15, 2

        $monitor("Time: %d, R1: %h, R2: %h, R3: %h, R4: %h, R5: %h, R6: %h, R7: %h, R8: %h, R9: %h, R10: %h, R11: %h, R12: %h ,R13 : %h, Mem22 :%h,R15 :%h ",
                 $time, risc1200.Reg_[1], risc1200.Reg_[2], risc1200.Reg_[3], risc1200.Reg_[4], risc1200.Reg_[5], 
                 risc1200.Reg_[6], risc1200.Reg_[7], risc1200.Reg_[8], risc1200.Reg_[9], risc1200.Reg_[10], risc1200.Reg_[11], risc1200.Reg_[12],risc1200.Reg_[13],risc1200.Mem[22],risc1200.Reg_[15]);
end
endmodule