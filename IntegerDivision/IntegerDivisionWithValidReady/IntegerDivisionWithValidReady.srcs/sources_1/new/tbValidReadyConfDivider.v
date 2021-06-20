`timescale 1ns / 1ps

module tbValidReadyConfDividery();

localparam N =32;

reg clk, rst, IN_valid, OUT_ready;
wire IN_ready, OUT_valid;

reg [N-1:0]Dividend;
reg [N-1:0]Divisor;

wire [N-1:0]Quotient;
wire [N-1:0]Remainder;

IntegerDivisionWithValidReady
                #
                (
                    .N(N)
                )
                DUT
                (
                    clk,
                    rst,
                    IN_ready,
                    Dividend,
                    Divisor,
                    IN_valid,
                    
                    OUT_valid,
                    Quotient,
                    Remainder,
                    OUT_ready
                );
                

always 
    begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

task giveNecesarrySignals;
    begin
        OUT_ready = 0;
        IN_valid = 0;
        wait(IN_ready == 1);
        IN_valid = 1;
        @(posedge clk);
        IN_valid = 0;
        wait(OUT_valid == 1);
        OUT_ready = 1;
        @(posedge clk);
        OUT_ready = 0;
    end
endtask


initial 
    begin
        rst = 1;
        #157;
        rst = 0;
        

        Dividend = 87;
        Divisor = 5;
        giveNecesarrySignals;
        
        Dividend = -1287;
        Divisor = -35;
        giveNecesarrySignals;
    end



endmodule
