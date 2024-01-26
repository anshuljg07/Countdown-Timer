# Countdown Timer

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technical Details](#technical-details)
- [Conclusion](#conclusion)

## Overview
The Embedded Countdown Timer is a hands-on project that integrates hardware and software to create a functional countdown timer. This project leverages 7-segment displays driven by 8-bit shift registers, offering a practical learning experience for embedded systems enthusiasts.

## Features
- Countdown timer from 0 to 25 seconds.
- User-friendly buttons (Button A and Button B) for control.
- Real-time display using two 7-segment displays.
- Educational opportunity for assembly programming.
- Circuit design with precise component interfacing.
- Hardware and software debugging skills development.

## Technical Details
In-depth technical aspects of this project include:

### Hardware
- **Circuit Design:** The project follows datasheets meticulously to create a circuit for two 7-segment displays. Each display is connected to an 8-bit shift register, ensuring precise connectivity and diode protection to prevent damage.

- **Button Debouncing:** Button A and Button B are integrated into the design with button debouncing. This ensures accurate and reliable user input by eliminating noise and jitter from button presses.

- **LED Testing:** During development, LED testing was employed to verify the correct current flow through the circuit. This step was essential to ensure the functionality of both the display and button components.

### Software
The software component is structured as follows:

#### Display Control
- **Display Subroutine:** The heart of the software is the display subroutine, responsible for showing numbers on the 7-segment displays. It utilizes bit manipulation to set the correct segments and generates SRCLK and RCLK pulses for both display digits.

#### Button Handling
- **Button Input Sampling:** The software includes mechanisms for button input sampling to detect button presses accurately. This ensures that user actions are interpreted correctly.

- **Button A and B Logic:** Button A allows users to adjust the countdown time, and Button B initiates the countdown. The software handles various scenarios based on button press durations, making it versatile and user-friendly.

#### Delays
- **Sample Delay:** A sample delay of 10 milliseconds is introduced to accurately sample button inputs without missing any signals. This ensures that button presses are detected promptly.

#### Countdown Logic
- **Countdown Timer:** The project implements a countdown timer with a range of 0 to 25 seconds. The timer is synchronized with one-second intervals and provides a visual countdown on the 7-segment displays.

#### Value Display
- **Change Value Subroutine:** This subroutine updates the displayed number based on the current countdown value. It efficiently manages the display to represent the remaining time.

## Conclusion
This Countdown Timer built using Assembly served as a comprehensive learning experience in embedded systems development. It provides insights into assembly programming, circuit design, and debugging skills for both hardware and software components. Starting as a beginner this project equipped me with practical knowledge in the field of embedded systems and even computer architecture!



