`timescale 1ns / 1ps


module ab(input A, input B, input clk, output reg Q);

    initial Q = 0; 

    always @(posedge clk)

	 begin

    case({A,B})
    2'b01 : Q <= 1;
    2'b00 : Q <= Q;
	 2'b11 : Q <= ~Q;
	 2'b10 : Q <= 0;
	 
	 endcase
    
	 end

endmodule

module ic1337(
              input I0,
              input I1,
              input I2,
              input clk,
              
              output Q0,
              output Q1,
              output Z);
	 
	assign W2 = !(I0 ^ !(I2 || !I1));
	
	assign W =  !(!I1 || I0) & !I2;
	
	wire tiempo;
	wire tiempo2;
	 
	 ab ff2(
	 .A(!I2),
	 .B(W2),
	 .clk(clk),
	 .Q(tiempo2)
	 );
	 
	 
	 ab ff1(
	 .A(W),
	 .B(I2),
	 .clk(clk),
	 .Q(tiempo)
	 );
	 

	 assign Q0 = tiempo;
	 assign Z = tiempo ^ tiempo2;
	 assign Q1 = tiempo2;

endmodule
