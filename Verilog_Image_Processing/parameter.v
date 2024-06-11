/*************************** **********************************************/
/*************************** Definition file ******************************/
/*************************** **********************************************/
// By FPGA4student.com
`define INPUTFILENAME		 "kodim23.hex" // Input file name
`define OUTPUTFILENAME		 "9_SoberFilter.bmp"		// Output file name

// Choose the operation of code by delete // in the beginning of the selected line


//`define RGB2Gray_OPERATION
//`define BRIGHTNESS_OPERATION
//`define INVERT_OPERATION
//`define THRESHOLD_OPERATION 
//`define NEGATIVE_OPERATION
//`define RED_FILTER_OPERATION    // Green, Blue: do the same
//`define EMBOSS_OPERATION
`define SOBEL_OPERATION