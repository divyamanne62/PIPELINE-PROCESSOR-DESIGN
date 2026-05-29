`timescale 1ns/1ps

module processor_tb;

    reg clk;
    reg reset;

    // Instantiate Processor
    processor uut(
        .clk(clk),
        .reset(reset)
    );

    // =====================================
    // CLOCK GENERATION
    // =====================================

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // =====================================
    // SIMULATION CONTROL
    // =====================================

    initial begin

        reset = 1;

        #10;
        reset = 0;

        #100;

        $finish;

    end

    // =====================================
    // MONITOR OUTPUT
    // =====================================

    initial begin

        $monitor(
            "TIME=%0t | PC=%d | IF=%h | OPCODE=%b | RESULT=%d | R1=%d | R2=%d | R3=%d | R4=%d",
            $time,
            uut.PC,
            uut.IF_ID_instr,
            uut.ID_EX_opcode,
            uut.EX_WB_result,
            uut.reg_file[1],
            uut.reg_file[2],
            uut.reg_file[3],
            uut.reg_file[4]
        );

    end

    // =====================================
    // DUMP WAVEFORM
    // =====================================

    initial begin

        $dumpfile("pipeline.vcd");
        $dumpvars(0, processor_tb);

    end

endmodule
