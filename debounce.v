module debounce(
    input clk,
    input btn,
    output reg btn_db
);

reg btn_sync0, btn_sync1;
reg [19:0] counter;

always @(posedge clk)
begin
    btn_sync0 <= btn;
    btn_sync1 <= btn_sync0;
end

always @(posedge clk)
begin
    if(btn_sync1 == btn_db)
        counter <= 20'd0;

    else
    begin
        counter <= counter + 1'b1;

        if(counter == 20'd999999)
        begin
            btn_db <= btn_sync1;
            counter <= 20'd0;
        end
    end
end

endmodule
