{\rtf1\ansi\ansicpg1252\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs26 \cf0 \expnd0\expndtw0\kerning0
`define WholeLine  800   // x lies in [0..WholeLine-1]\
`define WholeFrame 525   // y lies in [0..WholeFrame-1]\
\
`define xbits $clog2(`WholeLine)  // how many bits needed to count x?\
`define ybits $clog2(`WholeFrame) // how many bits needed to count y?\
\
\
`define hFrontPorch 16\
`define hBackPorch 48\
`define hSyncPulse 96\
`define vFrontPorch 10\
`define vBackPorch 33\
`define vSyncPulse 2\
\
`define hSyncPolarity 1'b1\
`define vSyncPolarity 1'b1\
\
`define hSyncStart (`WholeLine - `hBackPorch - `hSyncPulse)\
`define hSyncEnd (`hSyncStart + `hSyncPulse - 1)\
`define vSyncStart (`WholeFrame - `vBackPorch - `vSyncPulse)\
`define vSyncEnd (`vSyncStart + `vSyncPulse - 1)\
\
`define hVisible (`WholeLine  - `hFrontPorch - `hSyncPulse - `hBackPorch)\
`define vVisible (`WholeFrame - `vFrontPorch - `vSyncPulse - `vBackPorch)}