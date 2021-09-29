{\rtf1\ansi\ansicpg1252\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs26 \cf0 \expnd0\expndtw0\kerning0
## Clock signal\
## The next two lines specify the clock (100 MHz / 10 ns)\
set_property -dict \{ PACKAGE_PIN E3 IOSTANDARD LVCMOS33 \} [get_ports \{ clk \}]; # Sch name = CLK100MHZ\
create_clock -add -name sys_clk_pin -period 10.00 -waveform \{0 5\} [get_ports \{ clk \}];}