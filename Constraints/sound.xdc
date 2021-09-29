{\rtf1\ansi\ansicpg1252\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs26 \cf0 \expnd0\expndtw0\kerning0
## Clock signal\
#  Use an XDC file for the clock signal\
\
##PWM Audio Amplifier\
set_property PACKAGE_PIN A11 [get_ports audPWM]					\
set_property IOSTANDARD LVCMOS33 [get_ports audPWM]\
\
# audEn = 1 means enable audio; 0 means disable\
set_property PACKAGE_PIN D12 [get_ports audEn]						\
set_property IOSTANDARD LVCMOS33 [get_ports audEn]}