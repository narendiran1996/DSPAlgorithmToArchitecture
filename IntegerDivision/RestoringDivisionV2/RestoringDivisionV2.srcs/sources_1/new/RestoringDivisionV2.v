`timescale 1ns / 1ps


module RestoringDivisionV2
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

wire signBit;
assign signBit = Dividend[N-1] ^ Divisor[N-1];


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
                Q <= (Dividend[N-1] == 1) ? ~Dividend + 1 :Dividend;
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
assign M = (Divisor[N-1] == 1) ? ~Divisor + 1 : Divisor;


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
assign Rc = Rb - M;



assign Rd = (Rc[N-1] ==1 ) ? Rb : Rc;
assign Qd = (Rc[N-1] ==1 ) ? {Qb[N-1:1], 1'b0} : {Qb[N-1:1], 1'b1};



assign Quotient = (signBit == 1)? ~Q + 1  : Q;

assign done = (canCount == 1 && count == 0);

endmodule
