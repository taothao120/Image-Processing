module image_processing (
    input wire clk, 
	 output wire [2:0] rgb, 
    output wire hsync, 
    output wire vsync 
);
    // VGA parameters (example values, please adjust to your needs)
    parameter H_SYNC_PULSE = 208;
    parameter H_BACK_PORCH = 336;
    parameter H_PIXELS = 1920;
    parameter H_FRONT_PORCH = 128;
    parameter H_SYNC_POLARITY = 1'b0;
    parameter V_SYNC_PULSE = 3;
    parameter V_BACK_PORCH = 38;
    parameter V_PIXELS = 1200;
    parameter V_FRONT_PORCH = 1;
    parameter V_SYNC_POLARITY = 1'b1;
	 reg vga_clk;
    wire vga_hsync, vga_vsync;
    wire display_enable;
    wire dithered_red_pixel, dithered_green_pixel, dithered_blue_pixel;
    wire [2:0] rgb_output;
    wire [31:0] column, row;

    wire [23:0] pixel; // Assuming pixel is a 24-bit RGB value

    // RgbImageLoader instance
    RgbImageLoader #(
        .init_file("./images/kodim23.mif"),
        .IMAGE_WIDTH(116),
        .IMAGE_HEIGHT(78),
        .MEMORY_SIZE(9048),
        .ADDRESS_WIDTH(14)
    ) img_color (
        .clk(clk),
        .column(column),
        .row(row),
        .pixel(pixel)
    );
	 
    // VgaController instance
    VgaController #(
        .h_pulse(H_SYNC_PULSE),
        .h_bp(H_BACK_PORCH),
        .h_pixels(H_PIXELS),
        .h_fp(H_FRONT_PORCH),
        .h_pol(H_SYNC_POLARITY),
        .v_pulse(V_SYNC_PULSE),
        .v_bp(V_BACK_PORCH),
        .v_pixels(V_PIXELS),
        .v_fp(V_FRONT_PORCH),
        .v_pol(V_SYNC_POLARITY)
    ) vga_controller (
        .pixel_clk(vga_clk),
        .reset_n(1'b1),
        .h_sync(vga_hsync),
        .v_sync(vga_vsync),
        .disp_ena(display_enable),
        .column(column),
        .row(row)
    );
	 

endmodule
