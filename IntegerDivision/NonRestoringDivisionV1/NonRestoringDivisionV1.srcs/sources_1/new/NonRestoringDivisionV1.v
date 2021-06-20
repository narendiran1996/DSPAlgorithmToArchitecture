`timescale 1ns / 1ps


module NonRestoringDivisionV1
                    #
                    (
                        parameter N = 4
                    )
                    (
                        input wire clk,
                        input wire rst,
                        input wire start,
                        input wire [N-1:0]Dividend,
                        input wire [N-1:0]Divisor,
                        output wire [N-1:0]Quotient,
                        output wire done
                    );


reg [$clog2(N):0]count;



reg canCount;
always@(posedge clk)
    begin
        if(rst == 1)
            canCount <= 0;
        else
            if(start == 1)
                canCount <= 1;
            else if(count == 0)
                canCount <= 0;
            else
                canCount <= canCount;
    end

always@(posedge clk)
    begin
        if(rst == 1)
            count <= N;
        else
            if(canCount == 1 && count != 0)
                count <= count - 1;
            else if(count == 0)
                count <= N;
            else
                count <= count;
    end


wire [N-1:0]Rd, Qd;
reg [N-1:0]R, Q;
wire [N-1:0]M;
always@(posedge clk)
    begin
        if(rst == 1 || start == 1)
            begin
                R <= 0;
                Q <= Dividend;
            end
        else
            begin
                if(canCount == 1 && count != 0)
                    begin
                        R <= Rd;
                        Q <= Qd;
                    end
                else
                    begin
                        R <= R;
                        Q <= Q;
                    end
            end
    end
assign M = Divisor;


wire[N-1:0]Ra, Qa;
wire [(2*N)-1:0]Ra_Qa;
assign Ra = R;
assign Qa = Q;
assign Ra_Qa = {Ra,Qa};


wire [N-1:0]Rb, Qb;
wire [(2*N)-1:0]Rb_Qb;
assign Rb_Qb = Ra_Qa << 1;
assign Rb = Rb_Qb[(2*N)-1:N];
assign Qb = Rb_Qb[N-1:0];

wire [N-1:0]Rc;
assign Rc = (Rb[N-1] == 1) ? Rb + M : Rb - M;



assign Rd = Rc;
assign Qd = (Rc[N-1] == 1) ? {Qb[N-1:1], 1'b0} : {Qb[N-1:1], 1'b1};



assign Quotient = Q;

assign done = (canCount == 1 && count == 0);

endmodule
