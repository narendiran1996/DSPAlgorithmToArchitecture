`timescale 1ns / 1ps

module tbNonRestoringDivision_V1();

localparam N = 32;

reg clk, rst, start;
reg [N-1:0]Dividend, Divisor;
wire [N-1:0]Quotient;
wire done;


NonRestoringDivisionV1
                    #
                    (
                        .N(N)
                    )
                    DUT
                    (
                        clk,
                        rst,
                        start,
                        Dividend,
                        Divisor,
                        Quotient,
                        done
                    );


always
    begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

integer i;
integer Qval;

    
 
initial
    begin
        rst = 1;
        start = 0;
        Dividend = 0;
        Divisor = 0;
        #143
        rst = 0;
        #76;

        for(i=0;i<1000;i=i+1)
            begin
                @(posedge clk);
                @(posedge clk);
                 Dividend = $urandom%256;
                 Divisor = 1+($urandom%255);
//                Dividend = 10;
                Divisor = 3;
                Qval = Dividend / Divisor;
                start = 1;
                @(posedge clk);
                start = 0;
                wait(done==1);
                
                if(Qval != Quotient) 
                    begin
                        $error("It's gone wrong");
                        $finish;
                    end
            end
        $finish;
        
    end

endmodule

