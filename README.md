# 🚦 Railway Gate Controller using Verilog HDL on FPGA

## 📖 Overview

This project implements an Automated Railway Gate Controller using a Finite State Machine (FSM) in Verilog HDL on a Xilinx Artix-7 FPGA. The system simulates the operation of a railway crossing gate by responding to train detection, train passage, and obstruction signals.

To improve reliability and usability, the design includes:

- Debounced reset input
- 1-second clock divider
- FSM-based control logic
- Warning light and buzzer indication
- Seven-segment display for real-time state visualization

---

## 🎯 Features

- Finite State Machine based controller
- Automatic gate opening and closing
- Train detection and train passage handling
- Obstruction detection and safety handling
- Debounced push-button reset
- 1-second timing control using clock divider
- Seven-segment display showing current FSM state
- FPGA implementation on Xilinx Artix-7

---

## 🏗 System Architecture

```text
                   +------------------+
                   | Train Detected   |
                   +------------------+
                            |
                            v

+------------------------------------------------+
|        Railway Gate Controller FSM             |
+------------------------------------------------+
| OPEN -> WARNING -> CLOSING -> CLOSED           |
|   ^                                   |        |
|   |                                   v        |
| OPENING <----------- Train Passed <---+        |
|                                                |
| OBSTRUCTED (Safety State)                      |
+------------------------------------------------+

         |
         +----> Gate Control
         +----> Warning Light
         +----> Buzzer
         +----> Seven Segment Display
```

---

## 🔄 FSM States

| State | Description | Display |
|---------|------------|---------|
| OPEN | Gate open, no train detected | OPEN |
| WARNING | Warning before gate closes | ALrt |
| CLOSING | Gate closing operation | CLOS |
| CLOSED | Gate fully closed | CLSd |
| OPENING | Gate opening operation | OPEN |
| OBSTRUCTED | Obstruction detected | StOP |

---

## ⚙ Inputs

| Signal | Description |
|----------|-------------|
| clk | 100 MHz FPGA clock |
| rst | System reset |
| train_detected | Indicates approaching train |
| train_passed | Indicates train has passed |
| obstruction | Obstruction detected at gate |

---

## ⚙ Outputs

| Signal | Description |
|----------|-------------|
| gate_down | Gate control signal |
| warning_light | Warning indicator |
| buzzer | Audible alert |
| Seven_Seg | Seven-segment segment outputs |
| digit | Seven-segment digit select lines |
| state_dbg | Current FSM state (debug) |

---

## ⏱ Timing Logic

The FPGA board provides a 100 MHz clock.

A clock divider generates a 1-second timing pulse used by the FSM timers.

```text
100 MHz Clock
      ↓
Clock Divider
      ↓
1 Second Tick
      ↓
FSM Timer Control
```

---

## 🛡 Safety Features

### Obstruction Detection

If an obstruction is detected while the gate is closing:

```text
CLOSING → OBSTRUCTED
```

The system:

- Stops normal operation
- Activates warning indicators
- Waits until obstruction is removed

---

## 🖥 Seven Segment State Display

The current FSM state is displayed on the 4-digit seven-segment display.

| State | Display |
|---------|---------|
| OPEN | OPEN |
| WARNING | ALrt |
| CLOSING | CLOS |
| CLOSED | CLSd |
| OPENING | OPEN |
| OBSTRUCTED | StOP |

---

## 📁 Project Structure

```text
railway-gate-controller/
│
├── railway_gate_controller.v
├── debounce.v
├── tb_railway_gate_controller.v
├── railway_gate_controller.xdc
├── README.md
```

---

## 🧪 Simulation

The design was verified using a custom testbench covering:

- Reset operation
- Train detection
- Warning period
- Gate closing
- Gate closed state
- Gate opening
- Obstruction handling
- Recovery from obstruction

Result:

```text
TEST1 SUCCESS
TEST2 SUCCESS
TEST3 SUCCESS
TEST4 SUCCESS
TEST5 SUCCESS
TEST6 SUCCESS
TEST7 SUCCESS
TEST8 SUCCESS

SUMMARY: PASS (8/8)
```

---

## 🔧 Tools Used

- Verilog HDL
- Vivado 2025.2
- Icarus Verilog (iverilog)
- GTKWave
- Xilinx Artix-7 FPGA

---

## 🚀 Future Improvements

- LCD/OLED status display
- Servo motor controlled gate
- Real train sensor integration
- IoT monitoring dashboard
- Railway crossing traffic analytics

---

## 👨‍💻 Author

**Sanjeev Kurella**

B.Tech Electronics and Communication Engineering (ECE)  
Vellore Institute of Technology (VIT)
