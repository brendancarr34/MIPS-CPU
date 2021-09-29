`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2020 10:05:12 PM
// Design Name: 
// Module Name: mem_map
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


module mem_map #(
    parameter wordsize = 32
)(
    input wire cpu_wr,
    input wire [wordsize-1:0] cpu_addr,
    output wire [wordsize-1:0] cpu_readdata,
    
    output wire lights_wr,
    output wire sound_wr,
    input wire [wordsize-1:0] accel_val,
    input wire [wordsize-1:0] keyb_char,
    output wire smem_wr,
    input wire [wordsize-1:0] smem_readdata,
    output wire dmem_wr,
    input wire [wordsize-1:0] dmem_readdata
    );
    
    logic [1:0] msSel;
    logic [1:0] lsSel;
    assign msSel = cpu_addr[17:16];
    assign lsSel = cpu_addr[3:2];
    
    assign lights_wr =  ((msSel == 2'b11) && (lsSel == 2'b11) && cpu_wr) ? 1'b1 : 1'b0;
    assign sound_wr =   ((msSel == 2'b11) && (lsSel == 2'b10) && cpu_wr) ? 1'b1 : 1'b0;
    assign smem_wr =    ((msSel == 2'b10) && (cpu_wr == 1'b1)) ? 1'b1 : 1'b0;
    assign dmem_wr =    ((msSel == 2'b01) && (cpu_wr == 1'b1)) ? 1'b1 : 1'b0;
    
    assign cpu_readdata =   ((msSel == 2'b11) && (lsSel == 2'b00)) ? keyb_char :
                            ((msSel == 2'b11) && (lsSel == 2'b01)) ? accel_val :
                            (msSel == 2'b10) ? smem_readdata :
                            (msSel == 2'b01) ? dmem_readdata :
                            32'b0; // error catch;
    
endmodule
