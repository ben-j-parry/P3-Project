module codectest (input logic CLOCK_50,
					// Audio CODEC
           output logic AUD_XCK, 
		   
		   input logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, 
		   input logic reset, 
		   output logic AUD_DACDAT,
					// I2C Audio/Video config interface 
           output logic FPGA_I2C_SCLK, inout wire FPGA_I2C_SDAT,
		   //test LEDS
		   output logic rstled1, led2, led3, led4, led5
					);

	//these are my wires
	//i have used logic as they are controlled by combinational logic 
	//not sure if this is good practice
	
	logic key;
	assign key = ~reset;
		
	logic adc_left_ready, adc_right_ready;
	logic dac_left_ready, dac_right_ready;
	
	logic adc_left_valid, adc_right_valid;
	logic dac_left_valid, dac_right_valid;
	
	logic [31:0] adc_left_data, adc_right_data;
	logic [31:0] dac_left_data, dac_right_data;
	
	
	clock_config clk1 (
		.ref_clk_clk        (CLOCK_50),//input clock
		.ref_reset_reset    (key),   //input reset
		.audio_clk_clk      (AUD_XCK), //output clock
	);
	
	
	audio_video_config avcfg1 (
		.clk         (CLOCK_50),
		.reset       (key),       

		.I2C_SDAT    (FPGA_I2C_SDAT), //not sure point of this but it is needed for the codec
		.I2C_SCLK    (FPGA_I2C_SCLK)  
	);
	   
	 //if adc is valid and ready it will give data to read
	 //if dac is valid and ready it will read your data
	 
	audio_config acfg1 (
		.clk                          (CLOCK_50),            
		.reset                        (key),          
		//these are the control signals for the CODEC, I do not touch these
		.AUD_ADCDAT                   (AUD_ADCDAT),  
		.AUD_ADCLRCK                  (AUD_ADCLRCK),    
		.AUD_BCLK                     (AUD_BCLK),     
		.AUD_DACDAT                   (AUD_DACDAT), 
		.AUD_DACLRCK                  (AUD_DACLRCK), 
		
		//these are the data streams and control signals
		.from_adc_left_channel_ready  (adc_left_ready),  //input
		.from_adc_left_channel_data   (adc_left_data),   //output                           
		.from_adc_left_channel_valid  (adc_left_valid),  //output                          
		
		.from_adc_right_channel_ready (adc_right_ready), 
		.from_adc_right_channel_data  (adc_right_data),  
		.from_adc_right_channel_valid (adc_right_valid),
		
		.to_dac_left_channel_data     (dac_left_data),     //input    
		.to_dac_left_channel_valid    (dac_left_valid),    //input                          
		.to_dac_left_channel_ready    (dac_left_ready),    //output                         
 		
		.to_dac_right_channel_data    (dac_right_data),
		.to_dac_right_channel_valid   (dac_right_valid),
		.to_dac_right_channel_ready   (dac_right_ready) 
	);
	


	always_comb
	begin
	
	//This section of code will connect the ADC straight to the DAC
///////////////////////////////////////////////////////////
		if (adc_left_valid)
		begin
			adc_left_ready = 1'b1;
			dac_left_data = adc_left_data;
			dac_left_valid = 1'b1;
		end
		else
		begin
			dac_left_data = '0;
			adc_left_ready = 1'b0;
			dac_left_valid = 1'b0;
		end
		
		if(adc_right_valid)
		begin
			adc_right_ready = 1'b1;
			dac_right_data = adc_right_data;
			dac_right_valid = 1'b1;
		end
		else
		begin
			dac_right_data = '0;
			adc_right_ready = 1'b0;
			dac_right_valid = 1'b0;
		end
///////////////////////////////////////////////////////////
//	LEDS
//these are leds to indicate if the reset is working
		if (key) 
		begin
			rstled1 = 1'b1;
		end
		else 
		begin
			rstled1 = 1'b0;
		end
		
		if (adc_left_valid && adc_left_ready) 
		begin
			led2 = 1'b1;
		end
		else 
		begin
			led2 = 1'b0;
		end
		
		if (adc_right_valid && adc_right_ready) 
		begin
			led3 = 1'b1;
		end
		else 
		begin
			led3 = 1'b0;
		end
		
				
		if (dac_left_valid && dac_left_ready) 
		begin
			led4 = 1'b1;
		end
		else 
		begin
			led4 = 1'b0;
		end
		
		if (dac_right_valid && dac_right_ready) 
		begin
			led5 = 1'b1;
		end
		else 
		begin
			led5 = 1'b0;
		end
		
	end
	
	
endmodule