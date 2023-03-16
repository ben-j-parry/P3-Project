
module audio_config (
	clk,
	reset,
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	from_adc_left_channel_ready,
	from_adc_left_channel_data,
	from_adc_left_channel_valid,
	from_adc_right_channel_ready,
	from_adc_right_channel_data,
	from_adc_right_channel_valid,
	to_dac_left_channel_data,
	to_dac_left_channel_valid,
	to_dac_left_channel_ready,
	to_dac_right_channel_data,
	to_dac_right_channel_valid,
	to_dac_right_channel_ready);	

	input		clk;
	input		reset;
	input		AUD_ADCDAT;
	input		AUD_ADCLRCK;
	input		AUD_BCLK;
	output		AUD_DACDAT;
	input		AUD_DACLRCK;
	input		from_adc_left_channel_ready;
	output	[31:0]	from_adc_left_channel_data;
	output		from_adc_left_channel_valid;
	input		from_adc_right_channel_ready;
	output	[31:0]	from_adc_right_channel_data;
	output		from_adc_right_channel_valid;
	input	[31:0]	to_dac_left_channel_data;
	input		to_dac_left_channel_valid;
	output		to_dac_left_channel_ready;
	input	[31:0]	to_dac_right_channel_data;
	input		to_dac_right_channel_valid;
	output		to_dac_right_channel_ready;
endmodule
