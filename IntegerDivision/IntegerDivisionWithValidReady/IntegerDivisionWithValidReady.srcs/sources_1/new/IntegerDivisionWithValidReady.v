`timescale 1ns / 1ps


module IntegerDivisionWithValidReady
                #
                (
                    parameter N = 8
                )
                (
                    input wire clk,
                    input wire rst,
                    output reg IN_ready,
                    input wire [N-1:0]Dividend,
                    input wire [N-1:0]Divisor,
                    input wire IN_valid,
                    
                    output reg OUT_valid,
                    output wire [N-1:0]Quotient,
                    output wire [N-1:0]Remainder,
                    input wire OUT_ready
                );

reg [1:0]presentState, nextState;

localparam INIT = 2'd0, DIV = 2'd1, DIVDONE = 2'd2;

reg [$clog2(N):0]count;


always @(posedge clk)
    begin
        if(rst  == 1)
            presentState <= INIT;
        else
            presentState <= nextState;
    end


always @(presentState, IN_valid, OUT_ready, count) 
    begin
        case (presentState)
            INIT: 
                begin
                    IN_ready = 1;
                    OUT_valid = 0;
                    if(IN_valid == 1)
                        nextState = DIV;
                    else
                        nextState = INIT;
                end
            DIV:
                begin
                    IN_ready = 0;
                    OUT_valid = 0;
                    if(count == (N-1))
                        nextState = DIVDONE;
                    else
                        nextState = DIV;
                end
            DIVDONE:
                begin
                    IN_ready = 0;
                    OUT_valid = 1;
                    if(OUT_ready == 1)
                        nextState = INIT;
                    else
                        nextState = DIVDONE;
                end
            default: 
                begin
                    IN_ready = 'hx;
                    OUT_valid = 'hx;
                    nextState = 'hx;
                end
        endcase
    end


always @(posedge clk)
    begin
        if(rst == 1 || presentState == INIT)
            count <= 0;
        else
            if(presentState == DIV)
                count <= count + 1;
    end


wire signBit;
assign signBit = Dividend[N-1] ^ Divisor[N-1];

wire [N-1:0]Rd, Qd;

reg [N-1:0]R, Q;
wire [N-1:0]M;
assign M = (Divisor[N-1] == 1) ? ~Divisor + 1 : Divisor;

always @(posedge clk)
    begin
        if(rst == 1 || presentState == INIT)
            begin
                R <= 0;
                Q <= (Dividend[N-1] == 1) ? ~Dividend + 1 :Dividend;
            end
        else
            begin
                if(presentState == DIV)
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



assign Quotient = (signBit == 1)? ~Q + 1  : Q;
assign Remainder = (R[N-1] == 1) ? R + M : R;


endmodule
