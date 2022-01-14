module TropicalALU(clk, Instr_code, ALU_result);
input clk; // you need to feed in the clock signal from module test_bench
reg [31:0] Instruction_memory[7:0];
reg [31:0] Data_memory[7:0]; // you will use data memory for next lab.
reg [31:0] Register_File[31:0];
reg [31:0] PC;
output reg [31:0] Instr_code;
reg [5:0] Func_code, OP_code;
reg [4:0] Rs, Rt, Rd;
reg [31:0] ALU_Input1,ALU_Input2;
output reg [31:0] ALU_result;

initial
begin
PC = 32'h0000_0000;
Instr_code = 32'h0000_0000;
ALU_result = 32'h00000000;
Register_File[0] = 32'h00000000; //R0 = 0x00000000;
Register_File[1] = 32'h80000000; //R1 = infinity;
Register_File[2] = 32'hFFFFFFFF; //R2 = also infinity;
Register_File[3] = 32'h7FFFFFFF; //R3 = 0x7FFFFFFF;
Register_File[4] = 32'h00000001; //R4 = 0x00000001;
Instruction_memory[0] = 32'h00220000; //R0 = R1&R2;
Instruction_memory[1] = 32'h00220001; //R0 = R1|R2;
Instruction_memory[2] = 32'h00640002; //R0 = min(R3,R4);
Instruction_memory[3] = 32'h00640004; //R0 = R3+R4;
Instruction_memory[4] = 32'h00220002; //R0 = min(R1,R2);
end


// declare a lot of other variables and initialize them
always@(posedge clk) //fetch instruction_code from Instruction_memory and decode it
begin
Instr_code= { Instruction_memory[PC/4]};
PC=PC+4;
OP_code= Instr_code[31:26];
Rs= Instr_code[25:21];
Rt= Instr_code[20:16];
Rd= Instr_code[15:11];
Func_code= Instr_code[5:0];
ALU_Input1= Register_File[Rs];
ALU_Input2= Register_File[Rt];
end

//DONE: infinity bit
//TODO: Signed arithmetic, logical shift, arithmetic rotate, overflow mode

always@(ALU_Input1 or ALU_Input2 or Func_code) //ALU to make a calculation
begin
case (Func_code)
0:  //AND: Rd = Rs AND Rt 
begin
ALU_result = ALU_Input1 & ALU_Input2;
end
1:  //OR: Rd = Rs OR Rt
begin 
ALU_result = ALU_Input1 | ALU_Input2;
end
2:  //Tropical ADD: Rd = Rs OPLUS Rt
begin
	if(ALU_Input1[31] == 1)
	begin
		ALU_result = ALU_Input2;
	end
	else if(ALU_Input2[31] == 1)
	begin
		ALU_result = ALU_Input1;
	end
	else if(ALU_Input1 < ALU_Input2)
	begin
		ALU_result = ALU_Input1;
	end
	else
	begin
		ALU_result = ALU_Input2;
	end
end
4:  //Tropical TIMES: Rd = Rs OTIMES Rt
	 //Overflow results in a 0, not an infinity
begin
	if(ALU_Input1[31] == 1 || ALU_Input2[31] == 1)
	begin
		ALU_result = 32'hFFFFFFFF;
	end
	else
	begin
		ALU_result <= ALU_Input1 + ALU_Input2;
		ALU_result[31] <= ALU_result[31] & 0;
	end
end
endcase
end

always@(negedge clk) //write the ALU_result back to Register File
begin
Register_File[Rd]=ALU_result;
end

endmodule
