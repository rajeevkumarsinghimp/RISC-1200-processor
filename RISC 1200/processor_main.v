module main( clk1,  clk2);
input clk1,clk2;
    reg [31:0] pc, if_id_ir, if_id_npc;
    reg [31:0] id_ex_ir, id_ex_npc, A, B, id_ex_immediate;
    reg [2:0] id_ex_type, ex_mem_type, mem_wb_type;
    reg [31:0] ex_mem_ir, ex_mem_aluout, ex_mem_B;
    reg ex_mem_cond;
    reg [31:0] mem_wb_ir, mem_wb_aluout, mem_wb_temp;
    reg [31:0] Reg_[0:31];  // Changed Reg to Reg_
    reg [31:0] Mem[0:1023];
    
    // Define instruction opcodes
    parameter ADD = 6'b000001, SUB = 6'b000010, AND = 6'b000011, OR = 6'b000100, XOR = 6'b000101, 
              LW = 6'b000110, SW = 6'b000111, BNE = 6'b001000, ADDI = 6'b001001, SUBI = 6'b001010, 
              ANDI = 6'b001011, ORI = 6'b001100, SLI = 6'b001101, SRI = 6'b001110;
              
    // Define instruction types
    parameter RR_ALU = 3'b001, RI_ALU = 3'b010, LOAD = 3'b011, STORE = 3'b100, BRANCH = 3'b101;
    
    reg branch_taken;
    
    // Instruction Fetch Stage
    always @(posedge clk1) begin
        if ((ex_mem_ir[31:26] == BNE) && (ex_mem_cond == 1)) begin
            if_id_ir <= #2 Mem[ex_mem_aluout];
            branch_taken <= #2 1'b1;
            if_id_npc <= #2 ex_mem_aluout + 1;
            pc <= #2 ex_mem_aluout + 1;
        end else begin
            if_id_ir <= #2 Mem[pc];
            if_id_npc <= #2 pc + 1;
            pc <= #2 pc + 1;
        end
    end

    // Instruction Decode Stage
    always @(posedge clk2) begin
        A <= #2 Reg_[if_id_ir[25:21]];  // Changed Reg to Reg_
        B <= #2 Reg_[if_id_ir[20:16]];  // Changed Reg to Reg_
        id_ex_ir <= #2 if_id_ir;
        id_ex_npc <= #2 if_id_npc;
        id_ex_immediate <= #2 {{16{if_id_ir[15]}}, {if_id_ir[15:0]}};
        case(if_id_ir[31:26])
            ADD, SUB, AND, OR, XOR: id_ex_type <= #2 RR_ALU;
            BNE, ADDI, SUBI, ANDI, ORI, SLI, SRI: id_ex_type <= #2 RI_ALU;
            LW: id_ex_type <= #2 LOAD;
            SW: id_ex_type <= #2 STORE;
        endcase
    end

    // Execution Stage
    always @(posedge clk1) begin
        ex_mem_ir <= #2 id_ex_ir;
        ex_mem_type <= #2 id_ex_type;
        branch_taken <= #2 1'b0;
        case (id_ex_type)
            RR_ALU: begin
                case (id_ex_ir[31:26])
                    ADD: ex_mem_aluout <= #2 A + B;
                    SUB: ex_mem_aluout <= #2 A - B;
                    AND: ex_mem_aluout <= #2 A & B;
                    OR: ex_mem_aluout <= #2 A | B;
                    XOR: ex_mem_aluout <= #2 A ^ B;
                    default: ex_mem_aluout <= #2 32'hxxxxxxxx;
                endcase
            end
            RI_ALU: begin
                case (id_ex_ir[31:26])
                    ADDI: ex_mem_aluout <= #2 A + id_ex_immediate;
                    SUBI: ex_mem_aluout <= #2 A - id_ex_immediate;
                    ANDI: ex_mem_aluout <= #2 A & id_ex_immediate;
                    ORI: ex_mem_aluout <= #2 A | id_ex_immediate;
                    SLI: ex_mem_aluout <= #2 A << id_ex_immediate;
                    SRI: ex_mem_aluout <= #2 A >> id_ex_immediate;
                    BNE: if (A != B) begin
                        ex_mem_cond <= 1'b1;
                        ex_mem_aluout <= id_ex_immediate;
                    end
                    default: ex_mem_aluout <= #2 32'hxxxxxxxx;
                endcase
            end
            LOAD, STORE: begin
                ex_mem_aluout <= #2 A + id_ex_immediate;
                ex_mem_B <= #2 B;
            end
        endcase
    end

    // Memory Stage
    always @(posedge clk2) begin
        mem_wb_type <= #2 ex_mem_type;
        mem_wb_ir <= #2 ex_mem_ir;
        case (ex_mem_type)
            RR_ALU, RI_ALU: mem_wb_aluout <= #2 ex_mem_aluout;
            STORE: if (branch_taken == 0) begin
                Mem[ex_mem_aluout] <= #2 ex_mem_B;
            end
            LOAD: mem_wb_temp <= #2 Mem[ex_mem_aluout];
        endcase
    end

    // Write Back Stage
    always @(posedge clk1) begin
        if (branch_taken == 0) begin
            case (mem_wb_type)
                RR_ALU: Reg_[mem_wb_ir[15:11]] <= #2 mem_wb_aluout;  // Changed Reg to Reg_
                RI_ALU: Reg_[mem_wb_ir[20:16]] <= #2 mem_wb_aluout;  // Changed Reg to Reg_
                LOAD: Reg_[mem_wb_ir[20:16]] <= #2 mem_wb_temp;  // Changed Reg to Reg_
            endcase
        end
    end
endmodule