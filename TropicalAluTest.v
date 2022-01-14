`timescale 1ns/1ps

module TropicalALUTest();
	reg clk;
	wire [31:0] Instr_code,ALU_result;
	
	TropicalALU uut(
		.clk(clk),
		.Instr_code(Instr_code),
		.ALU_result(ALU_result)
		);
	
	initial 
		begin
			clk = 0;		//set initial values for test bench functionality
		end
	
	always
		begin
		#10 clk = ~clk;		
		end

endmodule 
