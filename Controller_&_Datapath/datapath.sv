`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2020 08:52:46 PM
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module datapath #(
    parameter Nloc = 32,
    parameter Dbits = 32
)(
    input wire clk, reset, enable,
    
    output logic [31:0] pc = 32'h0040_0000,
    input wire [31:0] instr,
    
    input wire [1:0] pcsel, wasel, wdsel, asel,
    input wire [4:0] alufn,
    input wire sgnext, bsel, werf, Z,
    
    output wire [31:0] mem_addr, mem_writedata,
    input wire [31:0] mem_readdata = 32'h1001_0000
    );
    
    
    // register file wires    
    wire [4:0] Rs = instr[25:21];
    wire [4:0] Rt = instr[20:16];
    wire [4:0] reg_writeaddr; 
    wire [31:0] reg_writedata;
    wire [31:0] ReadData1, ReadData2;
    
    // pc wires
    logic [31:0] newPC;
    wire [31:0] JT, BT;
    wire [25:0] J;
    logic [31:0] pcPlus4;
    
    // imm wires
    wire [15:0] imm;
    wire [31:0] signImm;
    
    // alu wires
    wire [31:0] aluA, aluB;
    wire [4:0] shamt;
    wire [31:0] alu_result;    
    
    // pc wire assignments
    assign pcPlus4 = pc + 4;                                        // +4
    assign J = instr[25:0];                                         // J
    assign JT = ReadData1;                                          // JT
    assign BT = pcPlus4 + (signImm << 2);                           // BT
    assign newPC =  (pcsel == 2'b11) ? JT :                         // pcsel mux
                    (pcsel == 2'b10) ? {pc[31:28],J[25:0],2'b00} :
                    (pcsel == 2'b01) ? BT :
                    pcPlus4;               
            
    // register file wire assignments & memory wires
    assign reg_writeaddr =  (wasel == 2'b00) ? instr[15:11] :   // wasel mux
                            (wasel == 2'b01) ? instr[20:16] :
                            31;
    assign reg_writedata =  (wdsel == 2'b00) ? pcPlus4 :        // wdsel mux
                            (wdsel == 2'b01) ? alu_result :
                            mem_readdata;
    assign mem_addr = alu_result;
    assign mem_writedata = ReadData2;

    // imm wire assignments
    assign imm = instr[15:0];
    assign signImm = {{16{(sgnext & imm[15])}},imm};     //SgnExt                          
                        
    // alu wire assignments
    assign shamt = instr[10:6];
    assign aluA =   (asel == 2'b00) ? ReadData1 :       // asel mux
                    (asel == 2'b01) ? shamt:
                    16;
    assign aluB =   (bsel == 1'b0) ? ReadData2 :        // bsel mux
                    signImm;
                    
    // PC
    always_ff @(posedge clk)
        pc <= reset ? 32'h0040_0000 : !enable ? pc : newPC;
                 
    // ALU                   
    ALU #(Dbits) myALU(
        aluA,aluB,
        alu_result,
        alufn,
        Z);
                            
    // REGISTER FILE
    register_file #(Nloc,Dbits) reg_files(
        clk,werf,
        Rs,Rt,reg_writeaddr,
        reg_writedata,
        ReadData1,ReadData2);
        

    
endmodule
