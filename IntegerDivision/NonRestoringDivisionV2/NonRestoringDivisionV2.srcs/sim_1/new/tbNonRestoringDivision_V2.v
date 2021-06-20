`timescale 1ns / 1ps

module tbNonRestoringDivision_V2();

localparam N = 32;

reg clk, rst, start;
reg [N-1:0]Dividend, Divisor;
wire [N-1:0]Quotient;
wire done;


NonRestoringDivisionV2
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
integer temDiv;
integer temDis;
 reg signBit;
always@(Divisor, Dividend)
    begin
     if(Divisor[N-1] ==1)
        temDis = -Divisor;
    else
        temDis = Divisor;  
          if(Dividend[N-1] ==1)
                    temDiv = -Dividend;
                else
                    temDiv = Dividend;
    signBit = Dividend[N-1] ^ Divisor[N-1];
                if(signBit==1)
                    Qval =-1*(temDiv / temDis);
                else
                    Qval = (temDiv / temDis);
    end
    

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
                Dividend = $random%1073741908;
                Divisor = 1+($random%255);
           
               
                
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

