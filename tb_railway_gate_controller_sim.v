`timescale 1ns/1ps

module tb_railway_gate_controller_sim;

reg clk;
reg rst;
reg train_detected;
reg train_passed;
reg obstruction;

wire gate_down;
wire warning_light;
wire buzzer;
wire [2:0] state_dbg;

railway_gate_controller dut(
    .clk(clk),
    .rst(rst),
    .train_detected(train_detected),
    .train_passed(train_passed),
    .obstruction(obstruction),
    .gate_down(gate_down),
    .warning_light(warning_light),
    .buzzer(buzzer),
    .state_dbg(state_dbg)
);

parameter S_OPEN       = 3'b000;
parameter S_WARNING    = 3'b001;
parameter S_CLOSING    = 3'b010;
parameter S_CLOSED     = 3'b011;
parameter S_OPENING    = 3'b100;
parameter S_OBSTRUCTED = 3'b101;

integer checks;

always #5 clk = ~clk;

initial
begin
    $dumpfile("wave_railway_gate_controller.vcd");
    $dumpvars(0,tb_railway_gate_controller_sim);

    clk = 0;
    rst = 0;
    train_detected = 0;
    train_passed = 0;
    obstruction = 0;
    checks = 0;

    //---------------- RESET ----------------
    rst = 1;
    #20;
    rst = 0;
    #20;

    if(state_dbg==S_OPEN &&
       gate_down==0 &&
       warning_light==0 &&
       buzzer==0)
    begin
        checks=checks+1;
        $display("TEST1 SUCCESS");
    end
    else
        $display("TEST1 FAILED");

    //---------------- TRAIN DETECTED ----------------
    train_detected = 1;

    wait(state_dbg==S_WARNING);
    #1;

    if(state_dbg==S_WARNING &&
       gate_down==0 &&
       warning_light==1 &&
       buzzer==1)
    begin
        checks=checks+1;
        $display("TEST2 SUCCESS");
    end
    else
        $display("TEST2 FAILED");

    //---------------- CLOSING ----------------
    wait(state_dbg==S_CLOSING);
    #1;

    if(state_dbg==S_CLOSING &&
       gate_down==1 &&
       warning_light==1 &&
       buzzer==1)
    begin
        checks=checks+1;
        $display("TEST3 SUCCESS");
    end
    else
        $display("TEST3 FAILED");

    //---------------- CLOSED ----------------
    wait(state_dbg==S_CLOSED);
    #1;

    if(state_dbg==S_CLOSED &&
       gate_down==1 &&
       warning_light==1 &&
       buzzer==0)
    begin
        checks=checks+1;
        $display("TEST4 SUCCESS");
    end
    else
        $display("TEST4 FAILED");

    //---------------- OPENING ----------------
    train_detected = 0;
    train_passed = 1;

    wait(state_dbg==S_OPENING);
    #1;

    if(state_dbg==S_OPENING &&
       gate_down==0 &&
       warning_light==1 &&
       buzzer==0)
    begin
        checks=checks+1;
        $display("TEST5 SUCCESS");
    end
    else
        $display("TEST5 FAILED");

    //---------------- OPEN ----------------
    wait(state_dbg==S_OPEN);
    #1;

    if(state_dbg==S_OPEN &&
       gate_down==0 &&
       warning_light==0 &&
       buzzer==0)
    begin
        checks=checks+1;
        $display("TEST6 SUCCESS");
    end
    else
        $display("TEST6 FAILED");

    //---------------- OBSTRUCTION ----------------
    train_passed = 0;
    train_detected = 1;

    wait(state_dbg==S_WARNING);

    obstruction = 1;

    wait(state_dbg==S_OBSTRUCTED);
    #1;

    if(state_dbg==S_OBSTRUCTED &&
       gate_down==0 &&
       warning_light==1 &&
       buzzer==1)
    begin
        checks=checks+1;
        $display("TEST7 SUCCESS");
    end
    else
        $display("TEST7 FAILED");

    //---------------- CLEAR OBSTRUCTION ----------------
    obstruction = 0;

    wait(state_dbg==S_WARNING);
    #1;

    if(state_dbg==S_WARNING &&
       gate_down==0 &&
       warning_light==1 &&
       buzzer==1)
    begin
        checks=checks+1;
        $display("TEST8 SUCCESS");
    end
    else
        $display("TEST8 FAILED");

    //---------------- SUMMARY ----------------
    if(checks==8)
        $display("SUMMARY: PASS (8/8)");
    else
        $display("SUMMARY: FAIL (%0d/8)", checks);

    $finish;
end

endmodule
