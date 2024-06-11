module RgbImageLoader #( 
    parameter init_file = "kodim23.mif",
    parameter IMAGE_WIDTH = 116,
    parameter IMAGE_HEIGHT = 78,
    parameter MEMORY_SIZE = 9048,
    parameter ADDRESS_WIDTH = 14
)(
    input wire clk,
    input wire [31:0] column,
    input wire [31:0] row,
    output wire [23:0] pixel
);

    wire [23:0] pixel_data;
    wire [ADDRESS_WIDTH-1:0] pixel_address; // Declare as wire for continuous assignment
    integer pixel_index;
    reg should_draw;

    // ROM module instantiation
    ROM1 image (
        .address(pixel_address),
        .clock(clk),
        .q(pixel_data)
    );

    always @(posedge clk) begin
        // Image is serialized column-major
        pixel_index <= row + (column * IMAGE_HEIGHT);

        // Converting conditions into should_draw logic
        should_draw <= (column < IMAGE_WIDTH) && (row < IMAGE_HEIGHT) && (pixel_index < MEMORY_SIZE);
    end

    // Convert integer to std_logic_vector equivalent
    assign pixel_address = pixel_index[ADDRESS_WIDTH-1:0]; 

    // Assigning pixel values based on should_draw condition
    assign pixel[7:0]   = (should_draw) ? pixel_data[7:0] : 8'h00;    // Red
    assign pixel[15:8]  = (should_draw) ? pixel_data[15:8] : 8'h00;   // Green
    assign pixel[23:16] = (should_draw) ? pixel_data[23:16] : 8'h00;  // Blue

endmodule
