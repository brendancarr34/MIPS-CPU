`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2020 10:03:38 PM
// Design Name: 
// Module Name: memIO
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


module memIO #(
    parameter wordsize = 32,
    parameter dmem_size = 1024,
    parameter dmem_init =  "dmem_test.mem",
    parameter Nchars = 4,
    parameter smem_size = 1200,
    parameter smem_init = "smem_test.mem"
)(
    input wire clk,
    input wire cpu_wr,
    input wire [wordsize-1:0] cpu_addr,
    output wire [wordsize-1:0] cpu_readdata,
    input wire [wordsize-1:0] cpu_writedata,

    output logic [15:0] lights = 16'b0,
    output logic [31:0] period = 32'b0,
    input wire [31:0] accel_val,
    input wire [31:0] keyb_char,
    input wire [10:0] vga_addr,
    output wire [$clog2(Nchars)-1:0] vga_readdata
    );
    
    wire lights_wr,sound_wr,smem_wr,dmem_wr;
    wire [31:0] smem_readdata, dmem_readdata;
    
    mem_map #(.wordsize(wordsize)) my_mem_map(.cpu_wr(cpu_wr),
        .cpu_addr(cpu_addr),.cpu_readdata(cpu_readdata),
        .lights_wr(lights_wr),.sound_wr(sound_wr),
        .accel_val(accel_val),.keyb_char(keyb_char),
        .smem_wr(smem_wr),.smem_readdata(smem_readdata),
        .dmem_wr(dmem_wr),.dmem_readdata(dmem_readdata));
        
    ram_module #(.Nloc(dmem_size),.Dbits(wordsize),
            .initfile(dmem_init)) dmem(.clock(clk),.wr(dmem_wr),
            .addr(cpu_addr[31:2]),.din(cpu_writedata),.dout(dmem_readdata));
            
    wire [$clog2(Nchars)-1:0] charcode;        
            
    screenmem #(.Nloc(smem_size),.Dbits($clog2(Nchars)),
        .initfile(smem_init)) smem(.clock(clk),.wr(smem_wr),
        .addr2(vga_addr),.dout2(vga_readdata),
        .addr1(cpu_addr[31:2]),.din(cpu_writedata),
        .dout1(charcode));
        
    assign smem_readdata = {{30{1'b0}},charcode};

    always_ff @(posedge clk)
        period <= (sound_wr) ? cpu_writedata : period;
    
    always_ff @(posedge clk)
        lights <= (lights_wr) ? cpu_writedata[15:0] : lights;
     
endmodule
