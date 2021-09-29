{\rtf1\ansi\ansicpg1252\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\margl1440\margr1440\vieww21700\viewh10380\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs26 \cf0 \expnd0\expndtw0\kerning0
`timescale 1ns / 1ps\
\
//////////////////////////////////////////////////////////////////////////////////\
//\
// Montek Singh\
// 11/12/2015 \
//\
// Modified 4/18/2015 as follows:\
//   - changed logic so partial scancodes are buffered;\
//       output is updated only when a complete scancode has been recieved\
//   - changed output keyb_char to be 32 bits instead of 24 bits;\
//       earlier version had the 8 msb bits floating in the tester\
//\
//////////////////////////////////////////////////////////////////////////////////\
\
`timescale 1ns / 1ps\
`default_nettype none\
\
module keyboard(\
   input wire clk,\
   input wire ps2_clk,\
   input wire ps2_data,\
   output logic [31:0] keyb_char = 0\
   );\
\
   logic [31:0] temp_char = 0;\
   logic [9:0] bits = 0;\
   logic [3:0] count = 0;\
   logic [1:0] ps2_clk_prev2 = 2'b11;\
   logic [19:0] timeout = 0;\
   \
   always_ff @(posedge clk)\
      ps2_clk_prev2 <= \{ps2_clk_prev2[0], ps2_clk\};\
      \
   always_ff @(posedge clk)\
   begin\
      if((count == 11) || (timeout[19] == 1))\
      begin\
         count <= 0;\
         if((temp_char[7:0] == 8'hE0) || (temp_char[7:0] == 8'hF0)) begin       // if previous byte was E0 or F0\
            temp_char[31:0] <= \{temp_char[23:0], bits[7:0]\};                    // shift the new byte in from the right, i.e., continue scancode\
            if((bits[7:0] != 8'hE0) && (bits[7:0] != 8'hF0))                    // if new byte is not E0 or F0\
               keyb_char <= \{temp_char[23:0], bits[7:0]\};                       // update output\
         end\
         else begin                                                             // previous byte was not E0 or F0\
            temp_char[31:0] <= \{24'b0, bits[7:0]\};                              // new byte is the start of a new scancode\
            if((bits[7:0] != 8'hE0) && (bits[7:0] != 8'hF0))                    // if new byte is not E0 or F0\
               keyb_char <= \{24'b0, bits[7:0]\};                                 // update output      \
         end\
      end\
      else\
      begin\
         if(ps2_clk_prev2 == 2'b10)\
         begin\
            count <= count + 1;\
            bits <= \{ps2_data, bits[9:1]\};\
         end\
      end\
   end\
   \
   always_ff @(posedge clk)\
      timeout <= (count != 0) ? timeout + 1 : 0;\
\
endmodule}