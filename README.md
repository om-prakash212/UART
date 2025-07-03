UART Protocol Implementation in Verilog
Overview

This repository contains a Verilog implementation of the Universal Asynchronous Receiver-Transmitter (UART) protocol, a widely used serial communication interface. The design includes both transmitter and receiver modules that can be synthesized on FPGA platforms.

Features

Configurable baud rate (9600, 19200, 38400, 115200, etc.)
8-bit data frame with optional parity bit
1 stop bit (configurable to 2 bits)
Full-duplex communication (simultaneous transmit and receive)
FIFO buffering (optional) for better data handling
Ready/valid handshaking for flow control
Module Description

UART Transmitter (uart_tx.v)

Serializes parallel data into UART frames
Includes start bit, data bits, optional parity, and stop bits
Status signals for transmission completion
UART Receiver (uart_rx.v)

Samples and deserializes incoming UART frames
Includes start bit detection and sampling at mid-point
Error detection for framing and parity errors
Outputs valid signal when data is correctly received
Top Module (uart_top.v)

Instantiates both transmitter and receiver
Provides unified interface for external modules
Optional FIFO integration
Simulation Results

The repository includes testbenches (tb_uart_tx.v, tb_uart_rx.v) demonstrating:

Basic transmission and reception
Error condition handling
Different baud rate configurations
