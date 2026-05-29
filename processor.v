`timescale 1ns/1ps

module processor(
    input clk,
    input reset
);

    // Opcodes
    parameter ADD  = 4'b0001;
    parameter SUB  = 4'b0010;
    parameter LOAD = 4'b0011;

    // Program Counter
    reg [3:0] PC;

    // Instruction Memory
    reg [15:0] instr_mem [0:15];

    // Data Memory
    reg [7:0] data_mem [0:15];

    // Register File
    reg [7:0] reg_file [0:7];

    // =====================================
    // Pipeline Registers
    // =====================================

    // IF/ID
    reg [15:0] IF_ID_instr;

    // ID/EX
    reg [3:0] ID_EX_opcode;
    reg [2:0] ID_EX_rd;
    reg [7:0] ID_EX_data1;
    reg [7:0] ID_EX_data2;
    reg [7:0] ID_EX_imm;

    // EX/WB
    reg [2:0] EX_WB_rd;
    reg [7:0] EX_WB_result;
    reg EX_WB_regwrite;

    integer i;

    // =====================================
    // INITIALIZATION
    // =====================================

    initial begin

        // Clear Registers
        for(i = 0; i < 8; i = i + 1)
            reg_file[i] = 0;

        // Clear Data Memory
        for(i = 0; i < 16; i = i + 1)
            data_mem[i] = 0;

        // Initialize Data Memory
        data_mem[2] = 8'd25;

        // =====================================
        // PROGRAM INSTRUCTIONS
        // =====================================

        // Instruction Format:
        // [15:12] Opcode
        // [11:9]  Destination Register
        // [8:6]   Source Register 1
        // [5:3]   Source Register 2
        // [7:0]   Immediate for LOAD

        // LOAD R1, 2
        instr_mem[0] = {LOAD, 3'b001, 8'd2};

        // LOAD R2, 2
        instr_mem[1] = {LOAD, 3'b010, 8'd2};

        // ADD R3 = R1 + R2
        instr_mem[2] = {ADD, 3'b011, 3'b001, 3'b010, 3'b000};

        // SUB R4 = R2 - R1
        instr_mem[3] = {SUB, 3'b100, 3'b010, 3'b001, 3'b000};

        // Empty Instructions
        instr_mem[4] = 16'b0;
        instr_mem[5] = 16'b0;
        instr_mem[6] = 16'b0;

    end

    // =====================================
    // PIPELINE OPERATION
    // =====================================

    always @(posedge clk or posedge reset)
    begin

        if(reset)
        begin

            PC <= 0;

            IF_ID_instr <= 0;

            ID_EX_opcode <= 0;
            ID_EX_rd <= 0;
            ID_EX_data1 <= 0;
            ID_EX_data2 <= 0;
            ID_EX_imm <= 0;

            EX_WB_rd <= 0;
            EX_WB_result <= 0;
            EX_WB_regwrite <= 0;

        end

        else
        begin

            // =====================================
            // STAGE 4 : WRITE BACK (WB)
            // =====================================

            if(EX_WB_regwrite)
            begin
                reg_file[EX_WB_rd] <= EX_WB_result;
            end

            // =====================================
            // STAGE 3 : EXECUTE (EX)
            // =====================================

            EX_WB_rd <= ID_EX_rd;
            EX_WB_regwrite <= 1'b1;

            case(ID_EX_opcode)

                ADD:
                    EX_WB_result <= ID_EX_data1 + ID_EX_data2;

                SUB:
                    EX_WB_result <= ID_EX_data1 - ID_EX_data2;

                LOAD:
                    EX_WB_result <= data_mem[ID_EX_imm];

                default:
                    begin
                        EX_WB_result <= 0;
                        EX_WB_regwrite <= 0;
                    end

            endcase

            // =====================================
            // STAGE 2 : INSTRUCTION DECODE (ID)
            // =====================================

            ID_EX_opcode <= IF_ID_instr[15:12];
            ID_EX_rd <= IF_ID_instr[11:9];

            // Source Registers
            ID_EX_data1 <= reg_file[IF_ID_instr[8:6]];
            ID_EX_data2 <= reg_file[IF_ID_instr[5:3]];

            // Immediate Value
            ID_EX_imm <= IF_ID_instr[7:0];

            // =====================================
            // STAGE 1 : INSTRUCTION FETCH (IF)
            // =====================================

            IF_ID_instr <= instr_mem[PC];

            PC <= PC + 1;

        end

    end

endmodule
