`timescale 1ns / 1ns

module hdmi_test(
	
	input				sys_clk_p,
	input				sys_clk_n,
	input				reset,
	
	output	[1 : 0]		hdmi_clk,
	output	[1 : 0]		hdmi_d0,
	output	[1 : 0]		hdmi_d1,
	output	[1 : 0]		hdmi_d2
);
	
	wire				sys_clock;
	wire				dvi_pixel_clock;
	wire				dvi_bit_clock;
	
	wire				global_rst;
	
	wire				dvi_den;
	wire				dvi_hsync;
	wire				dvi_vsync;
	wire	[23 : 0]	dvi_data;
	
	IBUFGDS #(
		.DIFF_TERM("FALSE"),
		.IBUF_LOW_PWR("FALSE"),
		.IOSTANDARD("DIFF_SSTL15")
	) IBUFDS_inst (
		.I		(sys_clk_p),
		.IB		(sys_clk_n),
		.O		(sys_clock)
	);
	
	dvi_pll_v2 dvi_pll_v2_inst0(
		
		.sysclk				(sys_clock),
		.reset				(reset),
		.pixel_clock		(dvi_pixel_clock),
		.dvi_bit_clock		(dvi_bit_clock),
		
		.locked				(global_rst)
	);
	
	dvi_tx_top dvi_tx_top_inst0(
		
		.pixel_clock		(dvi_pixel_clock),
		.ddr_bit_clock		(dvi_bit_clock),
		.reset				(!global_rst),
		
		.den				(dvi_den),
		.hsync				(dvi_hsync),
		.vsync				(dvi_vsync),
		.pixel_data			(dvi_data),
		
		.tmds_clk			(hdmi_clk),
		.tmds_d0			(hdmi_d0),
		.tmds_d1			(hdmi_d1),
		.tmds_d2			(hdmi_d2)
	);
	
	test_pattern_gen test_gen0(
		
		.pixel_clock		(dvi_pixel_clock),
		.reset				(!global_rst),
		
		.video_vsync		(dvi_vsync),
		.video_hsync		(dvi_hsync),
		.video_den			(dvi_den),
		.video_pixel_even	(dvi_data)
	);
	
endmodule
