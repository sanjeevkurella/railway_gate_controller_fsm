module railway_gate_controller #(
parameter WARNING_TICKS = 2,
parameter GATE_TICKS = 3)(
input clk,
input rst,
input train_detected,
input train_passed,
input obstruction,

output reg gate_down,
output reg warning_light,
output reg buzzer,


output reg [7:0] Seven_Seg,
output reg [3:0] digit);

wire [2:0] state_dbg;

wire rst_db;

reg [26:0] sec_counter;
wire one_sec_tick;

debounce u_rst_debounce(.clk(clk),.btn(rst),.btn_db(rst_db));

parameter S_OPEN = 3'b000,
S_WARNING = 3'b001,
S_CLOSING = 3'b010,
S_CLOSED = 3'b011,
S_OPENING = 3'b100,
S_OBSTRUCTED = 3'b101;

reg [2:0]currentstate,nextstate;

assign state_dbg=currentstate;

reg [7:0] timer;

reg [15:0] refresh_counter;
wire [1:0] sel;

always @(posedge clk)
begin
    if(rst_db)
        sec_counter <= 0;

    else if(sec_counter == 99999999)
        sec_counter <= 0;

    else
        sec_counter <= sec_counter + 1;
end

assign one_sec_tick = (sec_counter == 99999999);

always @(posedge clk)
begin
    refresh_counter <= refresh_counter + 1;
end

assign sel = refresh_counter[15:14];

function [7:0] char_decode;
input [7:0]ch;
begin
    case(ch)
	"O" : char_decode = 8'b11000000;
	"P" : char_decode = 8'b10001100;
	"E" : char_decode = 8'b10000110;
	"n" : char_decode = 8'b10101011;
	"A" : char_decode = 8'b10001000;
	"L" : char_decode = 8'b11000111;
	"r" : char_decode = 8'b10101111;
	"t" : char_decode = 8'b10000111;
	"C" : char_decode = 8'b11000110;
	"S" : char_decode = 8'b10010010;
	"d" : char_decode = 8'b10100001;
	"b" : char_decode = 8'b10000011;

	default : char_decode = 8'b11111111;
    endcase
end
endfunction

always @ (posedge clk)
begin
	if(rst_db)
		currentstate<=S_OPEN;
	else
		currentstate<=nextstate;
end

always @ (posedge clk)
begin
	if(rst_db)
		timer<=0;
	else if(one_sec_tick)
	begin
		case(currentstate)



			S_WARNING : begin
				if(nextstate!=S_WARNING)
					timer<=0;
				else
					timer<=timer+1;
			end

			S_CLOSING : begin
				if(nextstate!=S_CLOSING)
					timer<=0;
				else
					timer<=timer+1;
			end
		
			S_OPENING : begin
				if(nextstate!=S_OPENING)
					timer<=0;
				else
					timer<=timer+1;
			end

			default : timer<=0;
		endcase
	end
end


		


always @(*) begin
	nextstate=currentstate;
	case(currentstate)
		S_OPEN : begin
			if(~train_detected)
				nextstate=S_OPEN;

			else
				nextstate=S_WARNING;

			end

		S_WARNING :begin
			if(obstruction)
        			nextstate = S_OBSTRUCTED;

    			else if(~train_detected)
        			nextstate = S_OPEN;

			else if(timer<WARNING_TICKS)
				nextstate=S_WARNING;

			else 
				nextstate=S_CLOSING;
		end

		S_OBSTRUCTED: begin
			if (obstruction)
				nextstate = S_OBSTRUCTED;

			else if(~obstruction & ~train_detected)
				nextstate = S_OPEN;

			else
				nextstate = S_WARNING;
		end

		S_CLOSING: begin
			if(obstruction)
				nextstate=S_OBSTRUCTED;

			else if(timer < GATE_TICKS)
				nextstate=S_CLOSING;

			else
				nextstate=S_CLOSED;
		end

		S_CLOSED: begin
			if(~train_passed | train_detected )
				nextstate=S_CLOSED;
			else
				nextstate=S_OPENING;
		end

		S_OPENING: begin
			if(timer<GATE_TICKS) begin
				if(train_detected)
					nextstate=S_WARNING;
				else
					nextstate=S_OPENING;
			end
			else begin
				if(train_detected)
					nextstate=S_WARNING;
				else
					nextstate=S_OPEN;
			end
		end
		default : 
            nextstate = S_OPEN;

			
	endcase
end
	
always @(*) begin
	case(currentstate)
	       S_OPEN : begin
		       gate_down=1'b0;
		       warning_light=1'b0;
		       buzzer=1'b0;
	       end

	       S_WARNING : begin
		       gate_down=1'b0;
		       warning_light=1'b1;
		       buzzer=1'b1;
	       end

	       S_OBSTRUCTED : begin
		       gate_down=1'b0;
		       warning_light=1'b1;
		       buzzer=1'b1;
	       end

	       S_CLOSING : begin
		       gate_down=1'b1;
		       warning_light=1'b1;
		       buzzer=1'b1;
	       end

	       S_CLOSED : begin
		       gate_down=1'b1;
		       warning_light=1'b1;
		       buzzer=1'b0;
	       end

	       S_OPENING : begin
		       gate_down=1'b0;
		       warning_light=1'b1;
		       buzzer=1'b0;
	       end

	       default : begin
		       gate_down=1'b0;
		       warning_light=1'b0;
		       buzzer=1'b0;
	       end


       endcase
end

always @(*)
begin
    case(currentstate)

        S_OPEN:
        begin
            case(sel)
                2'b00: begin digit=4'b1000; Seven_Seg=char_decode("n"); end
                2'b01: begin digit=4'b0100; Seven_Seg=char_decode("E"); end
                2'b10: begin digit=4'b0010; Seven_Seg=char_decode("P"); end
                2'b11: begin digit=4'b0001; Seven_Seg=char_decode("O"); end
            endcase
        end

        S_WARNING:
        begin
            case(sel)
                2'b00: begin digit=4'b1000; Seven_Seg=char_decode("t"); end
                2'b01: begin digit=4'b0100; Seven_Seg=char_decode("r"); end
                2'b10: begin digit=4'b0010; Seven_Seg=char_decode("L"); end
                2'b11: begin digit=4'b0001; Seven_Seg=char_decode("A"); end
            endcase
        end

        S_CLOSING:
        begin
            case(sel)
                2'b00: begin digit=4'b1000; Seven_Seg=char_decode("S"); end
                2'b01: begin digit=4'b0100; Seven_Seg=char_decode("O"); end
                2'b10: begin digit=4'b0010; Seven_Seg=char_decode("L"); end
                2'b11: begin digit=4'b0001; Seven_Seg=char_decode("C"); end
            endcase
        end

        S_CLOSED:
        begin
            case(sel)
                2'b00: begin digit=4'b1000; Seven_Seg=char_decode("d"); end
                2'b01: begin digit=4'b0100; Seven_Seg=char_decode("S"); end
                2'b10: begin digit=4'b0010; Seven_Seg=char_decode("L"); end
                2'b11: begin digit=4'b0001; Seven_Seg=char_decode("C"); end
            endcase
        end

        S_OPENING:
        begin
            case(sel)
                2'b00: begin digit=4'b1000; Seven_Seg=char_decode("n"); end
                2'b01: begin digit=4'b0100; Seven_Seg=char_decode("E"); end
                2'b10: begin digit=4'b0010; Seven_Seg=char_decode("P"); end
                2'b11: begin digit=4'b0001; Seven_Seg=char_decode("O"); end
            endcase
        end

        S_OBSTRUCTED:
        begin
            case(sel)
                2'b00: begin digit=4'b1000; Seven_Seg=char_decode("t"); end
                2'b01: begin digit=4'b0100; Seven_Seg=char_decode("S"); end
                2'b10: begin digit=4'b0010; Seven_Seg=char_decode("b"); end
                2'b11: begin digit=4'b0001; Seven_Seg=char_decode("O"); end
            endcase
        end

    endcase
end

endmodule



