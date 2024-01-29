module converter (
	clk, rst,
	en_state,
	sw,
	cursor,
	hour,
	min, sec,
	year,
	month,
	day,
	max_date,
	
	bin_watch,
	bin_date,
	
	save_hour,
	save_min,
	save_sec,
	
	save_year,
	save_mon, 
	save_day,
	
	timer_hour, 
	timer_min, 
	timer_sec
    );
	 
	input					clk, rst;
	input		[5:0]		en_state;
	input		[4:0]		sw;
	input		[5:0]		cursor;
	input		[4:0]		hour;
	input		[5:0]		min, sec;
	input		[13:0]	year;
	input		[3:0]		month;
	input		[4:0]		day;
	input		[4:0]		max_date;
	output	[16:0]	bin_watch;
	output	[22:0]	bin_date;
	output	[7:0]		save_hour, save_min, save_sec;
	output	[15:0]	save_year;
	output	[7:0]		save_mon, save_day;
	output	[7:0]		timer_hour, timer_min, timer_sec;	 

	 
	wire					clk, rst;
	wire		[5:0]		en_state;
	wire		[4:0]		sw;
	wire		[5:0]		cursor;
	wire		[4:0]		hour;
	wire		[5:0]		min, sec;
	wire		[13:0]	year;
	wire		[3:0]		month;
	wire		[4:0]		day;
	wire		[4:0]		max_date;
	wire		[16:0]	bin_watch;
	wire		[22:0]	bin_date;
	wire		[7:0]		save_hour, save_min, save_sec;
	wire		[15:0]	save_year;
	wire		[7:0]		save_mon, save_day;
	wire		[7:0]		timer_hour, timer_min, timer_sec;		
		
		
		
	 
	 
	wire		[7:0]		bcd_hour, bcd_min, bcd_sec;
	wire		[15:0]	bcd_year;
	wire		[7:0]		bcd_month,bcd_day;

	set			SET (
		/* input					*/	.clk				(clk),
		/* input					*/	.rst				(rst),
		/* input		[2:0]		*/	.en_state		(en_state),
		/* input		[4:0]		*/	.sw				(sw),
		/* input		[2:0]		*/	.cursor			(cursor),
		/* input		[7:0]		*/	.bcd_hour		(bcd_hour), 
		/* input		[7:0]		*/	.bcd_min			(bcd_min),
		/* input		[7:0]		*/	.bcd_sec			(bcd_sec),
		/* input		[15:0]	*/	.bcd_year		(bcd_year),
		/* input		[7:0]		*/	.bcd_month		(bcd_month),
		/* input		[7:0]		*/	.bcd_day			(bcd_day),
		/* input		[4:0]		*/	.max_date		(max_date),
		/* output	[16:0]	*/	.bin_watch		(bin_watch),
		/* output	[22:0]	*/	.bin_date		(bin_date),
		/* output	[7:0]		*/	.save_hour		(save_hour),
		/* output	[7:0]		*/	.save_min		(save_min),
		/* output	[7:0]		*/	.save_sec		(save_sec),
		/* output	[15:0]	*/	.save_year		(save_year),
		/* output	[7:0]		*/	.save_mon		(save_mon),
		/* output	[7:0]		*/	.save_day		(save_day),
		/* output	[7:0]		*/	.timer_hour		(timer_hour),
		/* output	[7:0]		*/	.timer_min		(timer_min),
		/* output	[7:0]		*/	.timer_sec		(timer_sec)
    );

	bin2bcd #(.BINARY_LENGTH(5), .NUM_OF_DIGIT(2)) BCD_HOUR (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary		(hour),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd			(bcd_hour));
		
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) BCD_MIN (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary		(min),
		/* output 	NUM_OF_DIGIT*4-1:0]	*/ .bcd			(bcd_min));
		
    bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) BCD_SEC (
	    /* input	[BINARY_LENGTH-1:0]	*/ .binary		(sec),
	    /* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd			(bcd_sec));

	bin2bcd #(.BINARY_LENGTH(14), .NUM_OF_DIGIT(4)) BCD_YEAR (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary		(year),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd			(bcd_year));
		 
	bin2bcd #(.BINARY_LENGTH(4), .NUM_OF_DIGIT(2)) BCD_MONTH (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary		(month),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd			(bcd_month));
		
	bin2bcd #(.BINARY_LENGTH(5), .NUM_OF_DIGIT(2)) BCD_DAY (
		/*	input		[BINARY_LENGTH-1:0]	*/ .binary		(day),
		/*	output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd			(bcd_day));

endmodule 