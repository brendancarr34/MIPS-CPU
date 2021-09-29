//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 1/31/2020
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"

module vgadisplaydriver(
    input wire clk,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );

   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   wire activevideo;

   vgatimer myvgatimer(clk, hsync, vsync, activevideo, x, y);
   
   assign red[3:0]   = (activevideo == 1) ? x[5:2] : 4'b0;
   assign green[3:0] = (activevideo == 1) ? y[5:2] : 4'b0;
   assign blue[3:0]  = (activevideo == 1) ? {y[5:2]+x[5:2]} : 4'b0;

endmodule
