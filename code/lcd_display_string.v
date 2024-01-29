module lcd_display_string(
	 	clk,rst,
		index,
		
		hour,
		min, 
		sec, 
		year,
		month, 
		day,
		week,
		ampm,
		out,
		
		en_watch, 
		set_watch, 
		set_date, 
		set_alarm, 
		stop_watch, 
		set_timer,
		
		bin_date, 
		bin_watch,
		
		save_hour,
		save_min, 
		save_sec,
		save_year, 
		save_mon, 
		save_day,
		
		bcd_stop_hour, 
		bcd_stop_min, 
		bcd_stop_sec,
		bin_timer_hour,
		bin_timer_min,
		bin_timer_sec
	);
	input		[16:0]	bin_watch;
	input		[22:0]	bin_date;
	input					set_watch,en_watch,set_date,set_alarm,stop_watch,set_timer;
	input					clk;
	input					rst;
	input		[4:0]		index;
	input		[7:0]		hour, min, sec;
   input		[15:0]	year;
   input		[7:0]		month, day;
	input		[2:0]		week;
	input					ampm;
	input		[7:0]		save_hour, save_min, save_sec;
	input		[15:0]	save_year;
	input		[7:0]		save_mon, save_day;
	input		[15:0]	bcd_stop_hour, bcd_stop_min, bcd_stop_sec;
	input		[4:0]		bin_timer_hour;
	input		[5:0]		bin_timer_min, bin_timer_sec;
	output	[7:0]		out;
	
	//dow
	wire		[7:0]		month, day;
	wire		[15:0]	year;
	wire		[7:0]		hour, min, sec;
	
	wire		[7:0]		bcd_month, bcd_day;
	wire		[15:0]	bcd_year;
	wire		[7:0]		bcd_hour, bcd_min, bcd_sec;
	wire		[4:0]		index;
	
	wire		[7:0]		set_month, set_day;
	wire		[15:0]	set_year;
	wire		[7:0]		set_hour, set_min, set_sec;
	wire		[15:0]	bcd_stop_hour, bcd_stop_min, bcd_stop_sec;
	wire		[15:0]	bcd_timer_hour, bcd_timer_min, bcd_timer_sec;
	
	reg		[7:0]		out;
	reg		[15:0]	lcd_month, lcd_day;
	reg		[31:0]	lcd_year;
	reg		[15:0]	lcd_hour, lcd_min, lcd_sec;
	reg		[7:0]		lcd_ampm;
	reg		[23:0]	lcd_week;
	reg		[5:0]		bin_sec, bin_min;
	reg		[4:0]		bin_hour;
	reg		[4:0]		bin_day;
	reg		[3:0]		bin_month;
	reg		[13:0]	bin_year;
	
	/*-----------------------------------------------------------------------------
	--									ASCII HEX TABLE
	--	HEX							 LOW HEX DIGIT
	-- value		0	1	2	3	4	5	6	7	8	9	A	B	C	D	E	F
	-----------------------------------------------------------
	--		2:	   Sp	!	"	#	$	%	&	'	(	)	*	+	,	-	.	/
	--	H	3:		0	1	2	3	4	5	6	7	8	9	:	;	<	=	>	?
	-- i	4:		@	A	B	C	D	E	F	G	H	I	X	K	L	M	N	O
	--	g	5:		P 	Q	R	S	T	U	V	W	X	Y	Z	[	\	]	^	_
	-- h  6:		`	a	b	c	d	e	f	g	h	i	j	k	l	m	n	o
	-- 	7:		p	q	r	s	t	u	v	w	x	y	z	{	|	}	~	DEL
	-------------------------------------------------------------
	*/
	always @ (posedge clk) begin
		bin_year		<=	bin_date[22:10];
		bin_month	<= bin_date[9:6];
		bin_day		<= bin_date[4:0];
		bin_sec		<=	bin_watch[5:0];
		bin_min		<= bin_watch[11:6];
		bin_hour		<= bin_watch[16:12];
	end
	
	
	bin2bcd #(.BINARY_LENGTH(5), .NUM_OF_DIGIT(2)) SET_HOUR (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(hour),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(set_hour));
	 
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) SET_MIN (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(min),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(set_min));
	 
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) SET_SEC (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(sec),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(set_sec));

	bin2bcd #(.BINARY_LENGTH(14), .NUM_OF_DIGIT(4)) SET_YEAR (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(year),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(set_year));
	 
	bin2bcd #(.BINARY_LENGTH(4), .NUM_OF_DIGIT(2)) SET_MONTH (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(month),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(set_month));
	 
	bin2bcd #(.BINARY_LENGTH(5), .NUM_OF_DIGIT(2)) SET_DAY (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(day),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(set_day));	
	
	
	
	bin2bcd #(.BINARY_LENGTH(5), .NUM_OF_DIGIT(2)) BCD_HOUR (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(hour),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_hour)
    );
	 
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) BCD_MIN (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(min),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_min)
    );
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) BCD_SEC (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(sec),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_sec)
    );

	bin2bcd #(.BINARY_LENGTH(14), .NUM_OF_DIGIT(4)) BCD_YEAR (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(year),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_year)
    );
	 
	bin2bcd #(.BINARY_LENGTH(4), .NUM_OF_DIGIT(2)) BCD_MONTH (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(month),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_month)
    );
	 
	bin2bcd #(.BINARY_LENGTH(5), .NUM_OF_DIGIT(2)) BCD_DAY (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(day),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_day)
	 );
	 
	
	
//-----------------------------timer----------------------------------

	bin2bcd #(.BINARY_LENGTH(5), .NUM_OF_DIGIT(2)) BCD_TIMER_HOUR (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(bin_timer_hour),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_timer_hour)
    );
	 
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) BCD_TIMER_MIN (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(bin_timer_min),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_timer_min)
    );
	 
	bin2bcd #(.BINARY_LENGTH(6), .NUM_OF_DIGIT(2)) BCD_TIMER_SEC (
		/* input		[BINARY_LENGTH-1:0]	*/ .binary	(bin_timer_sec),
		/* output	[NUM_OF_DIGIT*4-1:0]	*/ .bcd		(bcd_timer_sec)
    );
	 

	
	always @ (posedge clk or negedge rst) begin
		if(!rst)
			out<= 8'h00; //NULL
			
//-----------------------------------------------------------------en_watch
		else if(en_watch) begin
				case(bcd_year[15:12])
					4'b0000 : lcd_year[31:24] <= 8'h30 ;
					4'b0001 : lcd_year[31:24] <= 8'h31 ;
					4'b0010 : lcd_year[31:24] <= 8'h32 ;
					4'b0011 : lcd_year[31:24] <= 8'h33 ;
					4'b0100 : lcd_year[31:24] <= 8'h34 ;
					4'b0101 : lcd_year[31:24] <= 8'h35 ;
					4'b0110 : lcd_year[31:24] <= 8'h36 ;
					4'b0111 : lcd_year[31:24] <= 8'h37 ;
					4'b1000 : lcd_year[31:24] <= 8'h38 ;
					4'b1001 : lcd_year[31:24] <= 8'h39 ;
					default : lcd_year[31:24] <= 8'h30 ;
				endcase
				case(bcd_year[11:8])
					4'b0000 : lcd_year[23:16] <= 8'h30 ;
					4'b0001 : lcd_year[23:16] <= 8'h31 ;
					4'b0010 : lcd_year[23:16] <= 8'h32 ;
					4'b0011 : lcd_year[23:16] <= 8'h33 ;
					4'b0100 : lcd_year[23:16] <= 8'h34 ;
					4'b0101 : lcd_year[23:16] <= 8'h35 ;
					4'b0110 : lcd_year[23:16] <= 8'h36 ;
					4'b0111 : lcd_year[23:16] <= 8'h37 ;
					4'b1000 : lcd_year[23:16] <= 8'h38 ;
					4'b1001 : lcd_year[23:16] <= 8'h39 ;
					default : lcd_year[23:16] <= 8'h30 ;
				endcase
			
				case(bcd_year[7:4])
					4'b0000 : lcd_year[15:8] <= 8'h30 ;
					4'b0001 : lcd_year[15:8] <= 8'h31 ;
					4'b0010 : lcd_year[15:8] <= 8'h32 ;
					4'b0011 : lcd_year[15:8] <= 8'h33 ;
					4'b0100 : lcd_year[15:8] <= 8'h34 ;
					4'b0101 : lcd_year[15:8] <= 8'h35 ;
					4'b0110 : lcd_year[15:8] <= 8'h36 ;
					4'b0111 : lcd_year[15:8] <= 8'h37 ;
					4'b1000 : lcd_year[15:8] <= 8'h38 ;
					4'b1001 : lcd_year[15:8] <= 8'h39 ;
					default : lcd_year[15:8] <= 8'h30 ;
				endcase
				case(bcd_year[3:0])
					4'b0000 : lcd_year[7:0] <= 8'h30 ;
					4'b0001 : lcd_year[7:0] <= 8'h31 ;
					4'b0010 : lcd_year[7:0] <= 8'h32 ;
					4'b0011 : lcd_year[7:0] <= 8'h33 ;
					4'b0100 : lcd_year[7:0] <= 8'h34 ;
					4'b0101 : lcd_year[7:0] <= 8'h35 ;
					4'b0110 : lcd_year[7:0] <= 8'h36 ;
					4'b0111 : lcd_year[7:0] <= 8'h37 ;
					4'b1000 : lcd_year[7:0] <= 8'h38 ;
					4'b1001 : lcd_year[7:0] <= 8'h39 ;
					default : lcd_year[7:0] <= 8'h30 ;
				endcase
				case(bcd_month[7:4])
					4'b0000 : lcd_month[15:8] <= 8'h30 ;
					4'b0001 : lcd_month[15:8] <= 8'h31 ;
					4'b0010 : lcd_month[15:8] <= 8'h32 ;
					4'b0011 : lcd_month[15:8] <= 8'h33 ;
					4'b0100 : lcd_month[15:8] <= 8'h34 ;
					4'b0101 : lcd_month[15:8] <= 8'h35 ;
					4'b0110 : lcd_month[15:8] <= 8'h36 ;
					4'b0111 : lcd_month[15:8] <= 8'h37 ;
					4'b1000 : lcd_month[15:8] <= 8'h38 ;
					4'b1001 : lcd_month[15:8] <= 8'h39 ;
					default : lcd_month[15:8] <= 8'h30 ;
				endcase
				case(bcd_month[3:0])
					4'b0000 : lcd_month[7:0] <= 8'h30 ;
					4'b0001 : lcd_month[7:0] <= 8'h31 ;
					4'b0010 : lcd_month[7:0] <= 8'h32 ;
					4'b0011 : lcd_month[7:0] <= 8'h33 ;
					4'b0100 : lcd_month[7:0] <= 8'h34 ;
					4'b0101 : lcd_month[7:0] <= 8'h35 ;
					4'b0110 : lcd_month[7:0] <= 8'h36 ;
					4'b0111 : lcd_month[7:0] <= 8'h37 ;
					4'b1000 : lcd_month[7:0] <= 8'h38 ;
					4'b1001 : lcd_month[7:0] <= 8'h39 ;
					default : lcd_month[7:0] <= 8'h30 ;
				endcase
				case(bcd_day[7:4])
					4'b0000 : lcd_day[15:8] <= 8'h30 ;
					4'b0001 : lcd_day[15:8] <= 8'h31 ;
					4'b0010 : lcd_day[15:8] <= 8'h32 ;
					4'b0011 : lcd_day[15:8] <= 8'h33 ;
					4'b0100 : lcd_day[15:8] <= 8'h34 ;
					4'b0101 : lcd_day[15:8] <= 8'h35 ;
					4'b0110 : lcd_day[15:8] <= 8'h36 ;
					4'b0111 : lcd_day[15:8] <= 8'h37 ;
					4'b1000 : lcd_day[15:8] <= 8'h38 ;
					4'b1001 : lcd_day[15:8] <= 8'h39 ;
					default : lcd_day[15:8] <= 8'h30 ;
				endcase
				case(bcd_day[3:0])
					4'b0000 : lcd_day[7:0] <= 8'h30 ;
					4'b0001 : lcd_day[7:0] <= 8'h31 ;
					4'b0010 : lcd_day[7:0] <= 8'h32 ;
					4'b0011 : lcd_day[7:0] <= 8'h33 ;
					4'b0100 : lcd_day[7:0] <= 8'h34 ;
					4'b0101 : lcd_day[7:0] <= 8'h35 ;
					4'b0110 : lcd_day[7:0] <= 8'h36 ;
					4'b0111 : lcd_day[7:0] <= 8'h37 ;
					4'b1000 : lcd_day[7:0] <= 8'h38 ;
					4'b1001 : lcd_day[7:0] <= 8'h39 ;
					default : lcd_day[7:0] <= 8'h30 ;
				endcase
				case(week)
					4'd0 : lcd_week[23:16] <= 8'h53 ;//S
					4'd1 : lcd_week[23:16] <= 8'h53 ;//S
					4'd2 : lcd_week[23:16] <= 8'h4D ;//M
					4'd3 : lcd_week[23:16] <= 8'h54 ;//T
					4'd4 : lcd_week[23:16] <= 8'h57 ;//W
					4'd5 : lcd_week[23:16] <= 8'h54 ;//T
					4'd6 : lcd_week[23:16] <= 8'h46 ;//F
					default : lcd_week[23:16] <= 8'h53 ;//S
				endcase
				case(week)
					4'd0 : lcd_week[15:8] <= 8'h41 ;//A
					4'd1 : lcd_week[15:8] <= 8'h55 ;//U
					4'd2 : lcd_week[15:8] <= 8'h4F ;//O
					4'd3 : lcd_week[15:8] <= 8'h55 ;//U
					4'd4 : lcd_week[15:8] <= 8'h45 ;//E
					4'd5 : lcd_week[15:8] <= 8'h48 ;//H
					4'd6 : lcd_week[15:8] <= 8'h52 ;//R
					default : lcd_week[15:8] <= 8'h41 ;//A
				endcase
				case(week)
					4'd0 : lcd_week[7:0] <= 8'h54 ;//T
					4'd1 : lcd_week[7:0] <= 8'h4E ;//N
					4'd2 : lcd_week[7:0] <= 8'h4E ;//N
					4'd3 : lcd_week[7:0] <= 8'h45 ;//E
					4'd4 : lcd_week[7:0] <= 8'h44 ;//D
					4'd5 : lcd_week[7:0] <= 8'h55 ;//U
					4'd6 : lcd_week[7:0] <= 8'h49 ;//I
					default : lcd_week[7:0] <= 8'h54 ;//T
				endcase
				case(ampm)
					1'd0 :	lcd_ampm[7:0] <= 8'h41;
					1'd1 :	lcd_ampm[7:0] <= 8'h50;
					default : lcd_ampm[7:0] <= 8'h41;
				endcase
				case(bcd_hour[7:4])
					4'b0000 : lcd_hour[15:8] <= 8'h30 ;
					4'b0001 : lcd_hour[15:8] <= 8'h31 ;
					4'b0010 : lcd_hour[15:8] <= 8'h32 ;
					4'b0011 : lcd_hour[15:8] <= 8'h33 ;
					4'b0100 : lcd_hour[15:8] <= 8'h34 ;
					4'b0101 : lcd_hour[15:8] <= 8'h35 ;
					4'b0110 : lcd_hour[15:8] <= 8'h36 ;
					4'b0111 : lcd_hour[15:8] <= 8'h37 ;
					4'b1000 : lcd_hour[15:8] <= 8'h38 ;
					4'b1001 : lcd_hour[15:8] <= 8'h39 ;
					default : lcd_hour[15:8] <= 8'h30 ;
				endcase		
				case(bcd_hour[3:0])
					4'b0000 : lcd_hour[7:0] <= 8'h30 ;
					4'b0001 : lcd_hour[7:0] <= 8'h31 ;
					4'b0010 : lcd_hour[7:0] <= 8'h32 ;
					4'b0011 : lcd_hour[7:0] <= 8'h33 ;
					4'b0100 : lcd_hour[7:0] <= 8'h34 ;
					4'b0101 : lcd_hour[7:0] <= 8'h35 ;
					4'b0110 : lcd_hour[7:0] <= 8'h36 ;
					4'b0111 : lcd_hour[7:0] <= 8'h37 ;
					4'b1000 : lcd_hour[7:0] <= 8'h38 ;
					4'b1001 : lcd_hour[7:0] <= 8'h39 ;
					default : lcd_hour[7:0] <= 8'h30 ;
				endcase
				case(bcd_min[7:4])
					4'b0000 : lcd_min[15:8] <= 8'h30 ;
					4'b0001 : lcd_min[15:8] <= 8'h31 ;
					4'b0010 : lcd_min[15:8] <= 8'h32 ;
					4'b0011 : lcd_min[15:8] <= 8'h33 ;
					4'b0100 : lcd_min[15:8] <= 8'h34 ;
					4'b0101 : lcd_min[15:8] <= 8'h35 ;
					4'b0110 : lcd_min[15:8] <= 8'h36 ;
					4'b0111 : lcd_min[15:8] <= 8'h37 ;
					4'b1000 : lcd_min[15:8] <= 8'h38 ;
					4'b1001 : lcd_min[15:8] <= 8'h39 ;
					default : lcd_min[15:8] <= 8'h30 ;
				endcase
				case(bcd_min[3:0])
					4'b0000 : lcd_min[7:0] <= 8'h30 ;
					4'b0001 : lcd_min[7:0] <= 8'h31 ;
					4'b0010 : lcd_min[7:0] <= 8'h32 ;
					4'b0011 : lcd_min[7:0] <= 8'h33 ;
					4'b0100 : lcd_min[7:0] <= 8'h34 ;
					4'b0101 : lcd_min[7:0] <= 8'h35 ;
					4'b0110 : lcd_min[7:0] <= 8'h36 ;
					4'b0111 : lcd_min[7:0] <= 8'h37 ;
					4'b1000 : lcd_min[7:0] <= 8'h38 ;
					4'b1001 : lcd_min[7:0] <= 8'h39 ;
					default : lcd_min[7:0] <= 8'h30 ;
				endcase
				case(bcd_sec[7:4])
					4'b0000 : lcd_sec[15:8] <= 8'h30 ;
					4'b0001 : lcd_sec[15:8] <= 8'h31 ;
					4'b0010 : lcd_sec[15:8] <= 8'h32 ;
					4'b0011 : lcd_sec[15:8] <= 8'h33 ;
					4'b0100 : lcd_sec[15:8] <= 8'h34 ;
					4'b0101 : lcd_sec[15:8] <= 8'h35 ;
					4'b0110 : lcd_sec[15:8] <= 8'h36 ;
					4'b0111 : lcd_sec[15:8] <= 8'h37 ;
					4'b1000 : lcd_sec[15:8] <= 8'h38 ;
					4'b1001 : lcd_sec[15:8] <= 8'h39 ;
					default : lcd_sec[15:8] <= 8'h30 ;
				endcase
				case(bcd_sec[3:0])
					4'b0000 : lcd_sec[7:0] <= 8'h30 ;
					4'b0001 : lcd_sec[7:0] <= 8'h31 ;
					4'b0010 : lcd_sec[7:0] <= 8'h32 ;
					4'b0011 : lcd_sec[7:0] <= 8'h33 ;
					4'b0100 : lcd_sec[7:0] <= 8'h34 ;
					4'b0101 : lcd_sec[7:0] <= 8'h35 ;
					4'b0110 : lcd_sec[7:0] <= 8'h36 ;
					4'b0111 : lcd_sec[7:0] <= 8'h37 ;
					4'b1000 : lcd_sec[7:0] <= 8'h38 ;
					4'b1001 : lcd_sec[7:0] <= 8'h39 ;
					default : lcd_sec[7:0] <= 8'h30 ;
				endcase
				case(index)
					00	:	out	<=	8'h59; //Y
					01	:	out	<=	8'h3A; //:
					02	:	out	<= lcd_year[31:24];
					03	:	out	<= lcd_year[23:16];
					04	:	out	<= lcd_year[15:8];
					05	:	out	<= lcd_year[7:0];					
					06	:	out	<=	8'h20; //sp
					07	:	out	<=	8'h4D; //M
					08	:	out	<=	8'h3A; //:
					09	:	out	<= lcd_month[15:8];
					10	:	out	<= lcd_month[7:0];
					11	:	out	<=	8'h20; //sp
					12	:	out	<=	8'h44; //D
					13	:	out	<=	8'h3A; //:
					14	:	out	<= lcd_day[15:8];
					15	:	out	<= lcd_day[7:0];
	
					
					//LINE 2
					16	:	out	<= lcd_ampm[7:0];
					17	:	out	<= 8'h4D; //SP
					18	:	out	<= 8'h20; //SP
					19	:	out	<=	lcd_hour[15:8];
					20	:	out	<=	lcd_hour[7:0];
					21	:	out	<= 8'h3A; //:
					22	:	out	<=	lcd_min[15:8];
					23	:	out	<=	lcd_min[7:0];
					24	:	out	<= 8'h3A; //:
					25	:	out	<= lcd_sec[15:8];
					26	:	out	<=	lcd_sec[7:0];
					27	:	out	<= 8'h20; //SP
					28	:	out	<= 8'h20; //SP
					29	:	out	<=	lcd_week[23:16];
					30	:	out	<= lcd_week[15:8];
					31	:	out	<= lcd_week[7:0];
				endcase
		end	
//-----------------------------------------------------------------set_watch
		else if(set_watch) begin
				case(set_year[15:12])
					4'b0000 : lcd_year[31:24] <= 8'h30 ;
					4'b0001 : lcd_year[31:24] <= 8'h31 ;
					4'b0010 : lcd_year[31:24] <= 8'h32 ;
					4'b0011 : lcd_year[31:24] <= 8'h33 ;
					4'b0100 : lcd_year[31:24] <= 8'h34 ;
					4'b0101 : lcd_year[31:24] <= 8'h35 ;
					4'b0110 : lcd_year[31:24] <= 8'h36 ;
					4'b0111 : lcd_year[31:24] <= 8'h37 ;
					4'b1000 : lcd_year[31:24] <= 8'h38 ;
					4'b1001 : lcd_year[31:24] <= 8'h39 ;
					default : lcd_year[31:24] <= 8'h30 ;
				endcase
				case(set_year[11:8])
					4'b0000 : lcd_year[23:16] <= 8'h30 ;
					4'b0001 : lcd_year[23:16] <= 8'h31 ;
					4'b0010 : lcd_year[23:16] <= 8'h32 ;
					4'b0011 : lcd_year[23:16] <= 8'h33 ;
					4'b0100 : lcd_year[23:16] <= 8'h34 ;
					4'b0101 : lcd_year[23:16] <= 8'h35 ;
					4'b0110 : lcd_year[23:16] <= 8'h36 ;
					4'b0111 : lcd_year[23:16] <= 8'h37 ;
					4'b1000 : lcd_year[23:16] <= 8'h38 ;
					4'b1001 : lcd_year[23:16] <= 8'h39 ;
					default : lcd_year[23:16] <= 8'h30 ;
				endcase
			
				case(set_year[7:4])
					4'b0000 : lcd_year[15:8] <= 8'h30 ;
					4'b0001 : lcd_year[15:8] <= 8'h31 ;
					4'b0010 : lcd_year[15:8] <= 8'h32 ;
					4'b0011 : lcd_year[15:8] <= 8'h33 ;
					4'b0100 : lcd_year[15:8] <= 8'h34 ;
					4'b0101 : lcd_year[15:8] <= 8'h35 ;
					4'b0110 : lcd_year[15:8] <= 8'h36 ;
					4'b0111 : lcd_year[15:8] <= 8'h37 ;
					4'b1000 : lcd_year[15:8] <= 8'h38 ;
					4'b1001 : lcd_year[15:8] <= 8'h39 ;
					default : lcd_year[15:8] <= 8'h30 ;
				endcase
				case(set_year[3:0])
					4'b0000 : lcd_year[7:0] <= 8'h30 ;
					4'b0001 : lcd_year[7:0] <= 8'h31 ;
					4'b0010 : lcd_year[7:0] <= 8'h32 ;
					4'b0011 : lcd_year[7:0] <= 8'h33 ;
					4'b0100 : lcd_year[7:0] <= 8'h34 ;
					4'b0101 : lcd_year[7:0] <= 8'h35 ;
					4'b0110 : lcd_year[7:0] <= 8'h36 ;
					4'b0111 : lcd_year[7:0] <= 8'h37 ;
					4'b1000 : lcd_year[7:0] <= 8'h38 ;
					4'b1001 : lcd_year[7:0] <= 8'h39 ;
					default : lcd_year[7:0] <= 8'h30 ;
				endcase
				case(set_month[7:4])
					4'b0000 : lcd_month[15:8] <= 8'h30 ;
					4'b0001 : lcd_month[15:8] <= 8'h31 ;
					4'b0010 : lcd_month[15:8] <= 8'h32 ;
					4'b0011 : lcd_month[15:8] <= 8'h33 ;
					4'b0100 : lcd_month[15:8] <= 8'h34 ;
					4'b0101 : lcd_month[15:8] <= 8'h35 ;
					4'b0110 : lcd_month[15:8] <= 8'h36 ;
					4'b0111 : lcd_month[15:8] <= 8'h37 ;
					4'b1000 : lcd_month[15:8] <= 8'h38 ;
					4'b1001 : lcd_month[15:8] <= 8'h39 ;
					default : lcd_month[15:8] <= 8'h30 ;
				endcase
				case(set_month[3:0])
					4'b0000 : lcd_month[7:0] <= 8'h30 ;
					4'b0001 : lcd_month[7:0] <= 8'h31 ;
					4'b0010 : lcd_month[7:0] <= 8'h32 ;
					4'b0011 : lcd_month[7:0] <= 8'h33 ;
					4'b0100 : lcd_month[7:0] <= 8'h34 ;
					4'b0101 : lcd_month[7:0] <= 8'h35 ;
					4'b0110 : lcd_month[7:0] <= 8'h36 ;
					4'b0111 : lcd_month[7:0] <= 8'h37 ;
					4'b1000 : lcd_month[7:0] <= 8'h38 ;
					4'b1001 : lcd_month[7:0] <= 8'h39 ;
					default : lcd_month[7:0] <= 8'h30 ;
				endcase
				case(set_day[7:4])
					4'b0000 : lcd_day[15:8] <= 8'h30 ;
					4'b0001 : lcd_day[15:8] <= 8'h31 ;
					4'b0010 : lcd_day[15:8] <= 8'h32 ;
					4'b0011 : lcd_day[15:8] <= 8'h33 ;
					4'b0100 : lcd_day[15:8] <= 8'h34 ;
					4'b0101 : lcd_day[15:8] <= 8'h35 ;
					4'b0110 : lcd_day[15:8] <= 8'h36 ;
					4'b0111 : lcd_day[15:8] <= 8'h37 ;
					4'b1000 : lcd_day[15:8] <= 8'h38 ;
					4'b1001 : lcd_day[15:8] <= 8'h39 ;
					default : lcd_day[15:8] <= 8'h30 ;
				endcase
				case(set_day[3:0])
					4'b0000 : lcd_day[7:0] <= 8'h30 ;
					4'b0001 : lcd_day[7:0] <= 8'h31 ;
					4'b0010 : lcd_day[7:0] <= 8'h32 ;
					4'b0011 : lcd_day[7:0] <= 8'h33 ;
					4'b0100 : lcd_day[7:0] <= 8'h34 ;
					4'b0101 : lcd_day[7:0] <= 8'h35 ;
					4'b0110 : lcd_day[7:0] <= 8'h36 ;
					4'b0111 : lcd_day[7:0] <= 8'h37 ;
					4'b1000 : lcd_day[7:0] <= 8'h38 ;
					4'b1001 : lcd_day[7:0] <= 8'h39 ;
					default : lcd_day[7:0] <= 8'h30 ;
				endcase
				case(week)
					4'd0 : lcd_week[23:16] <= 8'h53 ;//S
					4'd1 : lcd_week[23:16] <= 8'h53 ;//S
					4'd2 : lcd_week[23:16] <= 8'h4D ;//M
					4'd3 : lcd_week[23:16] <= 8'h54 ;//T
					4'd4 : lcd_week[23:16] <= 8'h57 ;//W
					4'd5 : lcd_week[23:16] <= 8'h54 ;//T
					4'd6 : lcd_week[23:16] <= 8'h46 ;//F
					default : lcd_week[23:16] <= 8'h53 ;//S
				endcase
				case(week)
					4'd0 : lcd_week[15:8] <= 8'h41 ;//A
					4'd1 : lcd_week[15:8] <= 8'h55 ;//U
					4'd2 : lcd_week[15:8] <= 8'h4F ;//O
					4'd3 : lcd_week[15:8] <= 8'h55 ;//U
					4'd4 : lcd_week[15:8] <= 8'h45 ;//E
					4'd5 : lcd_week[15:8] <= 8'h48 ;//H
					4'd6 : lcd_week[15:8] <= 8'h52 ;//R
					default : lcd_week[15:8] <= 8'h41 ;//A
				endcase
				case(week)
					4'd0 : lcd_week[7:0] <= 8'h54 ;//T
					4'd1 : lcd_week[7:0] <= 8'h4E ;//N
					4'd2 : lcd_week[7:0] <= 8'h4E ;//N
					4'd3 : lcd_week[7:0] <= 8'h45 ;//E
					4'd4 : lcd_week[7:0] <= 8'h44 ;//D
					4'd5 : lcd_week[7:0] <= 8'h55 ;//U
					4'd6 : lcd_week[7:0] <= 8'h49 ;//I
					default : lcd_week[7:0] <= 8'h54 ;//T
				endcase
				case(ampm)
					1'd0 :	lcd_ampm[7:0] <= 8'h41;
					1'd1 :	lcd_ampm[7:0] <= 8'h50;
					default : lcd_ampm[7:0] <= 8'h41;
				endcase
				case(set_hour[7:4])
					4'b0000 : lcd_hour[15:8] <= 8'h30 ;
					4'b0001 : lcd_hour[15:8] <= 8'h31 ;
					4'b0010 : lcd_hour[15:8] <= 8'h32 ;
					4'b0011 : lcd_hour[15:8] <= 8'h33 ;
					4'b0100 : lcd_hour[15:8] <= 8'h34 ;
					4'b0101 : lcd_hour[15:8] <= 8'h35 ;
					4'b0110 : lcd_hour[15:8] <= 8'h36 ;
					4'b0111 : lcd_hour[15:8] <= 8'h37 ;
					4'b1000 : lcd_hour[15:8] <= 8'h38 ;
					4'b1001 : lcd_hour[15:8] <= 8'h39 ;
					default : lcd_hour[15:8] <= 8'h30 ;
				endcase		
				case(set_hour[3:0])
					4'b0000 : lcd_hour[7:0] <= 8'h30 ;
					4'b0001 : lcd_hour[7:0] <= 8'h31 ;
					4'b0010 : lcd_hour[7:0] <= 8'h32 ;
					4'b0011 : lcd_hour[7:0] <= 8'h33 ;
					4'b0100 : lcd_hour[7:0] <= 8'h34 ;
					4'b0101 : lcd_hour[7:0] <= 8'h35 ;
					4'b0110 : lcd_hour[7:0] <= 8'h36 ;
					4'b0111 : lcd_hour[7:0] <= 8'h37 ;
					4'b1000 : lcd_hour[7:0] <= 8'h38 ;
					4'b1001 : lcd_hour[7:0] <= 8'h39 ;
					default : lcd_hour[7:0] <= 8'h30 ;
				endcase
				case(set_min[7:4])
					4'b0000 : lcd_min[15:8] <= 8'h30 ;
					4'b0001 : lcd_min[15:8] <= 8'h31 ;
					4'b0010 : lcd_min[15:8] <= 8'h32 ;
					4'b0011 : lcd_min[15:8] <= 8'h33 ;
					4'b0100 : lcd_min[15:8] <= 8'h34 ;
					4'b0101 : lcd_min[15:8] <= 8'h35 ;
					4'b0110 : lcd_min[15:8] <= 8'h36 ;
					4'b0111 : lcd_min[15:8] <= 8'h37 ;
					4'b1000 : lcd_min[15:8] <= 8'h38 ;
					4'b1001 : lcd_min[15:8] <= 8'h39 ;
					default : lcd_min[15:8] <= 8'h30 ;
				endcase
				case(set_min[3:0])
					4'b0000 : lcd_min[7:0] <= 8'h30 ;
					4'b0001 : lcd_min[7:0] <= 8'h31 ;
					4'b0010 : lcd_min[7:0] <= 8'h32 ;
					4'b0011 : lcd_min[7:0] <= 8'h33 ;
					4'b0100 : lcd_min[7:0] <= 8'h34 ;
					4'b0101 : lcd_min[7:0] <= 8'h35 ;
					4'b0110 : lcd_min[7:0] <= 8'h36 ;
					4'b0111 : lcd_min[7:0] <= 8'h37 ;
					4'b1000 : lcd_min[7:0] <= 8'h38 ;
					4'b1001 : lcd_min[7:0] <= 8'h39 ;
					default : lcd_min[7:0] <= 8'h30 ;
				endcase
				case(set_sec[7:4])
					4'b0000 : lcd_sec[15:8] <= 8'h30 ;
					4'b0001 : lcd_sec[15:8] <= 8'h31 ;
					4'b0010 : lcd_sec[15:8] <= 8'h32 ;
					4'b0011 : lcd_sec[15:8] <= 8'h33 ;
					4'b0100 : lcd_sec[15:8] <= 8'h34 ;
					4'b0101 : lcd_sec[15:8] <= 8'h35 ;
					4'b0110 : lcd_sec[15:8] <= 8'h36 ;
					4'b0111 : lcd_sec[15:8] <= 8'h37 ;
					4'b1000 : lcd_sec[15:8] <= 8'h38 ;
					4'b1001 : lcd_sec[15:8] <= 8'h39 ;
					default : lcd_sec[15:8] <= 8'h30 ;
				endcase
				case(set_sec[3:0])
					4'b0000 : lcd_sec[7:0] <= 8'h30 ;
					4'b0001 : lcd_sec[7:0] <= 8'h31 ;
					4'b0010 : lcd_sec[7:0] <= 8'h32 ;
					4'b0011 : lcd_sec[7:0] <= 8'h33 ;
					4'b0100 : lcd_sec[7:0] <= 8'h34 ;
					4'b0101 : lcd_sec[7:0] <= 8'h35 ;
					4'b0110 : lcd_sec[7:0] <= 8'h36 ;
					4'b0111 : lcd_sec[7:0] <= 8'h37 ;
					4'b1000 : lcd_sec[7:0] <= 8'h38 ;
					4'b1001 : lcd_sec[7:0] <= 8'h39 ;
					default : lcd_sec[7:0] <= 8'h30 ;
				endcase
			
				case(index)
					00	:	out	<=	8'h54;				//	T
					01 :	out	<=	8'h69;				//	i
					02	:	out	<=	8'h6D;				//	m
					03	:	out	<= 8'h65;				// e
					04	:	out	<= 8'h20;				// sp
					05	:	out	<= 8'h53;				// S
					06	:	out	<=	8'h65;				//	e
					07	:	out	<=	8'h74;				// t
					08	:	out	<=	8'h20;				//	sp
					09	:	out	<= 8'h4D;				// M
					10	:	out	<= 8'h6F;				// o
					11	:	out	<=	8'h64;				// d
					12	:	out	<=	8'h65;				// e
					13	:	out	<=	8'h20;				// sp
					14	:	out	<= 8'h20;				// sp
					15	:	out	<=	8'h20;				// sp
	
					
					//LINE 2
					16	:	out	<= lcd_week[23:16];
					17	:	out	<= lcd_week[15:8];
					18	:	out	<= lcd_week[7:0];
					19	:	out	<=	8'h20; //SP
					20	:	out	<=	8'h20; //SP
					21	:	out	<= lcd_ampm[7:0];
					22	:	out	<=	8'h4D; //SP
					23	:	out	<=	8'h20; //SP
					24	:	out	<= lcd_hour[15:8];
					25	:	out	<= lcd_hour[7:0];
					26	:	out	<=	8'h3A; //:
					27	:	out	<= lcd_min[15:8];
					28	:	out	<= lcd_min[7:0];
					29	:	out	<=	8'h3A; //:
					30	:	out	<= lcd_sec[15:8];
					31	:	out	<= lcd_sec[7:0];
					default : out	<= 8'h00;
				endcase
		end
		
//-----------------------------------------------------------------set_date
		else if(set_date) begin
				case(set_year[15:12])
					4'b0000 : lcd_year[31:24] <= 8'h30 ;
					4'b0001 : lcd_year[31:24] <= 8'h31 ;
					4'b0010 : lcd_year[31:24] <= 8'h32 ;
					4'b0011 : lcd_year[31:24] <= 8'h33 ;
					4'b0100 : lcd_year[31:24] <= 8'h34 ;
					4'b0101 : lcd_year[31:24] <= 8'h35 ;
					4'b0110 : lcd_year[31:24] <= 8'h36 ;
					4'b0111 : lcd_year[31:24] <= 8'h37 ;
					4'b1000 : lcd_year[31:24] <= 8'h38 ;
					4'b1001 : lcd_year[31:24] <= 8'h39 ;
					default : lcd_year[31:24] <= 8'h30 ;
				endcase
				case(set_year[11:8])
					4'b0000 : lcd_year[23:16] <= 8'h30 ;
					4'b0001 : lcd_year[23:16] <= 8'h31 ;
					4'b0010 : lcd_year[23:16] <= 8'h32 ;
					4'b0011 : lcd_year[23:16] <= 8'h33 ;
					4'b0100 : lcd_year[23:16] <= 8'h34 ;
					4'b0101 : lcd_year[23:16] <= 8'h35 ;
					4'b0110 : lcd_year[23:16] <= 8'h36 ;
					4'b0111 : lcd_year[23:16] <= 8'h37 ;
					4'b1000 : lcd_year[23:16] <= 8'h38 ;
					4'b1001 : lcd_year[23:16] <= 8'h39 ;
					default : lcd_year[23:16] <= 8'h30 ;
				endcase
			
				case(set_year[7:4])
					4'b0000 : lcd_year[15:8] <= 8'h30 ;
					4'b0001 : lcd_year[15:8] <= 8'h31 ;
					4'b0010 : lcd_year[15:8] <= 8'h32 ;
					4'b0011 : lcd_year[15:8] <= 8'h33 ;
					4'b0100 : lcd_year[15:8] <= 8'h34 ;
					4'b0101 : lcd_year[15:8] <= 8'h35 ;
					4'b0110 : lcd_year[15:8] <= 8'h36 ;
					4'b0111 : lcd_year[15:8] <= 8'h37 ;
					4'b1000 : lcd_year[15:8] <= 8'h38 ;
					4'b1001 : lcd_year[15:8] <= 8'h39 ;
					default : lcd_year[15:8] <= 8'h30 ;
				endcase
				case(set_year[3:0])
					4'b0000 : lcd_year[7:0] <= 8'h30 ;
					4'b0001 : lcd_year[7:0] <= 8'h31 ;
					4'b0010 : lcd_year[7:0] <= 8'h32 ;
					4'b0011 : lcd_year[7:0] <= 8'h33 ;
					4'b0100 : lcd_year[7:0] <= 8'h34 ;
					4'b0101 : lcd_year[7:0] <= 8'h35 ;
					4'b0110 : lcd_year[7:0] <= 8'h36 ;
					4'b0111 : lcd_year[7:0] <= 8'h37 ;
					4'b1000 : lcd_year[7:0] <= 8'h38 ;
					4'b1001 : lcd_year[7:0] <= 8'h39 ;
					default : lcd_year[7:0] <= 8'h30 ;
				endcase
				case(set_month[7:4])
					4'b0000 : lcd_month[15:8] <= 8'h30 ;
					4'b0001 : lcd_month[15:8] <= 8'h31 ;
					4'b0010 : lcd_month[15:8] <= 8'h32 ;
					4'b0011 : lcd_month[15:8] <= 8'h33 ;
					4'b0100 : lcd_month[15:8] <= 8'h34 ;
					4'b0101 : lcd_month[15:8] <= 8'h35 ;
					4'b0110 : lcd_month[15:8] <= 8'h36 ;
					4'b0111 : lcd_month[15:8] <= 8'h37 ;
					4'b1000 : lcd_month[15:8] <= 8'h38 ;
					4'b1001 : lcd_month[15:8] <= 8'h39 ;
					default : lcd_month[15:8] <= 8'h30 ;
				endcase
				case(set_month[3:0])
					4'b0000 : lcd_month[7:0] <= 8'h30 ;
					4'b0001 : lcd_month[7:0] <= 8'h31 ;
					4'b0010 : lcd_month[7:0] <= 8'h32 ;
					4'b0011 : lcd_month[7:0] <= 8'h33 ;
					4'b0100 : lcd_month[7:0] <= 8'h34 ;
					4'b0101 : lcd_month[7:0] <= 8'h35 ;
					4'b0110 : lcd_month[7:0] <= 8'h36 ;
					4'b0111 : lcd_month[7:0] <= 8'h37 ;
					4'b1000 : lcd_month[7:0] <= 8'h38 ;
					4'b1001 : lcd_month[7:0] <= 8'h39 ;
					default : lcd_month[7:0] <= 8'h30 ;
				endcase
				case(set_day[7:4])
					4'b0000 : lcd_day[15:8] <= 8'h30 ;
					4'b0001 : lcd_day[15:8] <= 8'h31 ;
					4'b0010 : lcd_day[15:8] <= 8'h32 ;
					4'b0011 : lcd_day[15:8] <= 8'h33 ;
					4'b0100 : lcd_day[15:8] <= 8'h34 ;
					4'b0101 : lcd_day[15:8] <= 8'h35 ;
					4'b0110 : lcd_day[15:8] <= 8'h36 ;
					4'b0111 : lcd_day[15:8] <= 8'h37 ;
					4'b1000 : lcd_day[15:8] <= 8'h38 ;
					4'b1001 : lcd_day[15:8] <= 8'h39 ;
					default : lcd_day[15:8] <= 8'h30 ;
				endcase
				case(set_day[3:0])
					4'b0000 : lcd_day[7:0] <= 8'h30 ;
					4'b0001 : lcd_day[7:0] <= 8'h31 ;
					4'b0010 : lcd_day[7:0] <= 8'h32 ;
					4'b0011 : lcd_day[7:0] <= 8'h33 ;
					4'b0100 : lcd_day[7:0] <= 8'h34 ;
					4'b0101 : lcd_day[7:0] <= 8'h35 ;
					4'b0110 : lcd_day[7:0] <= 8'h36 ;
					4'b0111 : lcd_day[7:0] <= 8'h37 ;
					4'b1000 : lcd_day[7:0] <= 8'h38 ;
					4'b1001 : lcd_day[7:0] <= 8'h39 ;
					default : lcd_day[7:0] <= 8'h30 ;
				endcase
				case(week)
					4'd0 : lcd_week[23:16] <= 8'h53 ;//S
					4'd1 : lcd_week[23:16] <= 8'h53 ;//S
					4'd2 : lcd_week[23:16] <= 8'h4D ;//M
					4'd3 : lcd_week[23:16] <= 8'h54 ;//T
					4'd4 : lcd_week[23:16] <= 8'h57 ;//W
					4'd5 : lcd_week[23:16] <= 8'h54 ;//T
					4'd6 : lcd_week[23:16] <= 8'h46 ;//F
					default : lcd_week[23:16] <= 8'h53 ;//S
				endcase
				case(week)
					4'd0 : lcd_week[15:8] <= 8'h41 ;//A
					4'd1 : lcd_week[15:8] <= 8'h55 ;//U
					4'd2 : lcd_week[15:8] <= 8'h4F ;//O
					4'd3 : lcd_week[15:8] <= 8'h55 ;//U
					4'd4 : lcd_week[15:8] <= 8'h45 ;//E
					4'd5 : lcd_week[15:8] <= 8'h48 ;//H
					4'd6 : lcd_week[15:8] <= 8'h52 ;//R
					default : lcd_week[15:8] <= 8'h41 ;//A
				endcase
				case(week)
					4'd0 : lcd_week[7:0] <= 8'h54 ;//T
					4'd1 : lcd_week[7:0] <= 8'h4E ;//N
					4'd2 : lcd_week[7:0] <= 8'h4E ;//N
					4'd3 : lcd_week[7:0] <= 8'h45 ;//E
					4'd4 : lcd_week[7:0] <= 8'h44 ;//D
					4'd5 : lcd_week[7:0] <= 8'h55 ;//U
					4'd6 : lcd_week[7:0] <= 8'h49 ;//I
					default : lcd_week[7:0] <= 8'h54 ;//T
				endcase
				case(ampm)
					1'd0 :	lcd_ampm[7:0] <= 8'h41;
					1'd1 :	lcd_ampm[7:0] <= 8'h50;
					default : lcd_ampm[7:0] <= 8'h41;
				endcase
				case(set_hour[7:4])
					4'b0000 : lcd_hour[15:8] <= 8'h30 ;
					4'b0001 : lcd_hour[15:8] <= 8'h31 ;
					4'b0010 : lcd_hour[15:8] <= 8'h32 ;
					4'b0011 : lcd_hour[15:8] <= 8'h33 ;
					4'b0100 : lcd_hour[15:8] <= 8'h34 ;
					4'b0101 : lcd_hour[15:8] <= 8'h35 ;
					4'b0110 : lcd_hour[15:8] <= 8'h36 ;
					4'b0111 : lcd_hour[15:8] <= 8'h37 ;
					4'b1000 : lcd_hour[15:8] <= 8'h38 ;
					4'b1001 : lcd_hour[15:8] <= 8'h39 ;
					default : lcd_hour[15:8] <= 8'h30 ;
				endcase		
				case(set_hour[3:0])
					4'b0000 : lcd_hour[7:0] <= 8'h30 ;
					4'b0001 : lcd_hour[7:0] <= 8'h31 ;
					4'b0010 : lcd_hour[7:0] <= 8'h32 ;
					4'b0011 : lcd_hour[7:0] <= 8'h33 ;
					4'b0100 : lcd_hour[7:0] <= 8'h34 ;
					4'b0101 : lcd_hour[7:0] <= 8'h35 ;
					4'b0110 : lcd_hour[7:0] <= 8'h36 ;
					4'b0111 : lcd_hour[7:0] <= 8'h37 ;
					4'b1000 : lcd_hour[7:0] <= 8'h38 ;
					4'b1001 : lcd_hour[7:0] <= 8'h39 ;
					default : lcd_hour[7:0] <= 8'h30 ;
				endcase
				case(set_min[7:4])
					4'b0000 : lcd_min[15:8] <= 8'h30 ;
					4'b0001 : lcd_min[15:8] <= 8'h31 ;
					4'b0010 : lcd_min[15:8] <= 8'h32 ;
					4'b0011 : lcd_min[15:8] <= 8'h33 ;
					4'b0100 : lcd_min[15:8] <= 8'h34 ;
					4'b0101 : lcd_min[15:8] <= 8'h35 ;
					4'b0110 : lcd_min[15:8] <= 8'h36 ;
					4'b0111 : lcd_min[15:8] <= 8'h37 ;
					4'b1000 : lcd_min[15:8] <= 8'h38 ;
					4'b1001 : lcd_min[15:8] <= 8'h39 ;
					default : lcd_min[15:8] <= 8'h30 ;
				endcase
				case(set_min[3:0])
					4'b0000 : lcd_min[7:0] <= 8'h30 ;
					4'b0001 : lcd_min[7:0] <= 8'h31 ;
					4'b0010 : lcd_min[7:0] <= 8'h32 ;
					4'b0011 : lcd_min[7:0] <= 8'h33 ;
					4'b0100 : lcd_min[7:0] <= 8'h34 ;
					4'b0101 : lcd_min[7:0] <= 8'h35 ;
					4'b0110 : lcd_min[7:0] <= 8'h36 ;
					4'b0111 : lcd_min[7:0] <= 8'h37 ;
					4'b1000 : lcd_min[7:0] <= 8'h38 ;
					4'b1001 : lcd_min[7:0] <= 8'h39 ;
					default : lcd_min[7:0] <= 8'h30 ;
				endcase
				case(set_sec[7:4])
					4'b0000 : lcd_sec[15:8] <= 8'h30 ;
					4'b0001 : lcd_sec[15:8] <= 8'h31 ;
					4'b0010 : lcd_sec[15:8] <= 8'h32 ;
					4'b0011 : lcd_sec[15:8] <= 8'h33 ;
					4'b0100 : lcd_sec[15:8] <= 8'h34 ;
					4'b0101 : lcd_sec[15:8] <= 8'h35 ;
					4'b0110 : lcd_sec[15:8] <= 8'h36 ;
					4'b0111 : lcd_sec[15:8] <= 8'h37 ;
					4'b1000 : lcd_sec[15:8] <= 8'h38 ;
					4'b1001 : lcd_sec[15:8] <= 8'h39 ;
					default : lcd_sec[15:8] <= 8'h30 ;
				endcase
				case(set_sec[3:0])
					4'b0000 : lcd_sec[7:0] <= 8'h30 ;
					4'b0001 : lcd_sec[7:0] <= 8'h31 ;
					4'b0010 : lcd_sec[7:0] <= 8'h32 ;
					4'b0011 : lcd_sec[7:0] <= 8'h33 ;
					4'b0100 : lcd_sec[7:0] <= 8'h34 ;
					4'b0101 : lcd_sec[7:0] <= 8'h35 ;
					4'b0110 : lcd_sec[7:0] <= 8'h36 ;
					4'b0111 : lcd_sec[7:0] <= 8'h37 ;
					4'b1000 : lcd_sec[7:0] <= 8'h38 ;
					4'b1001 : lcd_sec[7:0] <= 8'h39 ;
					default : lcd_sec[7:0] <= 8'h30 ;
				endcase
			
				case(index)
					00	:	out	<=	8'h59; //Y
					01	:	out	<=	8'h3A; //:
					02	:	out	<= lcd_year[31:24];
					03	:	out	<= lcd_year[23:16];
					04	:	out	<= lcd_year[15:8];
					05	:	out	<= lcd_year[7:0];					
					06	:	out	<=	8'h20; //sp
					07	:	out	<=	8'h4D; //M
					08	:	out	<=	8'h3A; //:
					09	:	out	<= lcd_month[15:8];
					10	:	out	<= lcd_month[7:0];
					11	:	out	<=	8'h20; //sp
					12	:	out	<=	8'h44; //D
					13	:	out	<=	8'h3A; //:
					14	:	out	<= lcd_day[15:8];
					15	:	out	<= lcd_day[7:0];
	
					
					//LINE 2
					16	:	out	<=	8'h44;				//	D
					17 :	out	<=	8'h61;				//	a
					18	:	out	<=	8'h74;				//	t
					19	:	out	<= 8'h65;				// e
					20	:	out	<= 8'h20;				// sp
					21	:	out	<= 8'h53;				// S
					22	:	out	<=	8'h65;				//	e
					23	:	out	<=	8'h74;				// t
					24	:	out	<=	8'h20;				//	sp
					25	:	out	<= 8'h4D;				// M
					26	:	out	<= 8'h6F;				// o
					27	:	out	<=	8'h64;				// d
					28	:	out	<=	8'h65;				// e
					29	:	out	<=	8'h20;				// sp
					30	:	out	<= 8'h20;				// sp
					31	:	out	<=	8'h20;				// sp
					default : out	<= 8'h00;
				endcase
		end
//-----------------------------------------------------------------set_alarm
		else if(set_alarm) begin
				case(save_year[15:12])
					4'b0000 : lcd_year[31:24] <= 8'h30 ;
					4'b0001 : lcd_year[31:24] <= 8'h31 ;
					4'b0010 : lcd_year[31:24] <= 8'h32 ;
					4'b0011 : lcd_year[31:24] <= 8'h33 ;
					4'b0100 : lcd_year[31:24] <= 8'h34 ;
					4'b0101 : lcd_year[31:24] <= 8'h35 ;
					4'b0110 : lcd_year[31:24] <= 8'h36 ;
					4'b0111 : lcd_year[31:24] <= 8'h37 ;
					4'b1000 : lcd_year[31:24] <= 8'h38 ;
					4'b1001 : lcd_year[31:24] <= 8'h39 ;
					default : lcd_year[31:24] <= 8'h30 ;
				endcase
				case(save_year[11:8])
					4'b0000 : lcd_year[23:16] <= 8'h30 ;
					4'b0001 : lcd_year[23:16] <= 8'h31 ;
					4'b0010 : lcd_year[23:16] <= 8'h32 ;
					4'b0011 : lcd_year[23:16] <= 8'h33 ;
					4'b0100 : lcd_year[23:16] <= 8'h34 ;
					4'b0101 : lcd_year[23:16] <= 8'h35 ;
					4'b0110 : lcd_year[23:16] <= 8'h36 ;
					4'b0111 : lcd_year[23:16] <= 8'h37 ;
					4'b1000 : lcd_year[23:16] <= 8'h38 ;
					4'b1001 : lcd_year[23:16] <= 8'h39 ;
					default : lcd_year[23:16] <= 8'h30 ;
				endcase
			
				case(save_year[7:4])
					4'b0000 : lcd_year[15:8] <= 8'h30 ;
					4'b0001 : lcd_year[15:8] <= 8'h31 ;
					4'b0010 : lcd_year[15:8] <= 8'h32 ;
					4'b0011 : lcd_year[15:8] <= 8'h33 ;
					4'b0100 : lcd_year[15:8] <= 8'h34 ;
					4'b0101 : lcd_year[15:8] <= 8'h35 ;
					4'b0110 : lcd_year[15:8] <= 8'h36 ;
					4'b0111 : lcd_year[15:8] <= 8'h37 ;
					4'b1000 : lcd_year[15:8] <= 8'h38 ;
					4'b1001 : lcd_year[15:8] <= 8'h39 ;
					default : lcd_year[15:8] <= 8'h30 ;
				endcase
				case(save_year[3:0])
					4'b0000 : lcd_year[7:0] <= 8'h30 ;
					4'b0001 : lcd_year[7:0] <= 8'h31 ;
					4'b0010 : lcd_year[7:0] <= 8'h32 ;
					4'b0011 : lcd_year[7:0] <= 8'h33 ;
					4'b0100 : lcd_year[7:0] <= 8'h34 ;
					4'b0101 : lcd_year[7:0] <= 8'h35 ;
					4'b0110 : lcd_year[7:0] <= 8'h36 ;
					4'b0111 : lcd_year[7:0] <= 8'h37 ;
					4'b1000 : lcd_year[7:0] <= 8'h38 ;
					4'b1001 : lcd_year[7:0] <= 8'h39 ;
					default : lcd_year[7:0] <= 8'h30 ;
				endcase
				case(save_mon[7:4])
					4'b0000 : lcd_month[15:8] <= 8'h30 ;
					4'b0001 : lcd_month[15:8] <= 8'h31 ;
					4'b0010 : lcd_month[15:8] <= 8'h32 ;
					4'b0011 : lcd_month[15:8] <= 8'h33 ;
					4'b0100 : lcd_month[15:8] <= 8'h34 ;
					4'b0101 : lcd_month[15:8] <= 8'h35 ;
					4'b0110 : lcd_month[15:8] <= 8'h36 ;
					4'b0111 : lcd_month[15:8] <= 8'h37 ;
					4'b1000 : lcd_month[15:8] <= 8'h38 ;
					4'b1001 : lcd_month[15:8] <= 8'h39 ;
					default : lcd_month[15:8] <= 8'h30 ;
				endcase
				case(save_mon[3:0])
					4'b0000 : lcd_month[7:0] <= 8'h30 ;
					4'b0001 : lcd_month[7:0] <= 8'h31 ;
					4'b0010 : lcd_month[7:0] <= 8'h32 ;
					4'b0011 : lcd_month[7:0] <= 8'h33 ;
					4'b0100 : lcd_month[7:0] <= 8'h34 ;
					4'b0101 : lcd_month[7:0] <= 8'h35 ;
					4'b0110 : lcd_month[7:0] <= 8'h36 ;
					4'b0111 : lcd_month[7:0] <= 8'h37 ;
					4'b1000 : lcd_month[7:0] <= 8'h38 ;
					4'b1001 : lcd_month[7:0] <= 8'h39 ;
					default : lcd_month[7:0] <= 8'h30 ;
				endcase
				case(save_day[7:4])
					4'b0000 : lcd_day[15:8] <= 8'h30 ;
					4'b0001 : lcd_day[15:8] <= 8'h31 ;
					4'b0010 : lcd_day[15:8] <= 8'h32 ;
					4'b0011 : lcd_day[15:8] <= 8'h33 ;
					4'b0100 : lcd_day[15:8] <= 8'h34 ;
					4'b0101 : lcd_day[15:8] <= 8'h35 ;
					4'b0110 : lcd_day[15:8] <= 8'h36 ;
					4'b0111 : lcd_day[15:8] <= 8'h37 ;
					4'b1000 : lcd_day[15:8] <= 8'h38 ;
					4'b1001 : lcd_day[15:8] <= 8'h39 ;
					default : lcd_day[15:8] <= 8'h30 ;
				endcase
				case(save_day[3:0])
					4'b0000 : lcd_day[7:0] <= 8'h30 ;
					4'b0001 : lcd_day[7:0] <= 8'h31 ;
					4'b0010 : lcd_day[7:0] <= 8'h32 ;
					4'b0011 : lcd_day[7:0] <= 8'h33 ;
					4'b0100 : lcd_day[7:0] <= 8'h34 ;
					4'b0101 : lcd_day[7:0] <= 8'h35 ;
					4'b0110 : lcd_day[7:0] <= 8'h36 ;
					4'b0111 : lcd_day[7:0] <= 8'h37 ;
					4'b1000 : lcd_day[7:0] <= 8'h38 ;
					4'b1001 : lcd_day[7:0] <= 8'h39 ;
					default : lcd_day[7:0] <= 8'h30 ;
				endcase
				case(week)
					4'd0 : lcd_week[23:16] <= 8'h53 ;//S
					4'd1 : lcd_week[23:16] <= 8'h53 ;//S
					4'd2 : lcd_week[23:16] <= 8'h4D ;//M
					4'd3 : lcd_week[23:16] <= 8'h54 ;//T
					4'd4 : lcd_week[23:16] <= 8'h57 ;//W
					4'd5 : lcd_week[23:16] <= 8'h54 ;//T
					4'd6 : lcd_week[23:16] <= 8'h46 ;//F
					default : lcd_week[23:16] <= 8'h53 ;//S
				endcase
				case(week)
					4'd0 : lcd_week[15:8] <= 8'h41 ;//A
					4'd1 : lcd_week[15:8] <= 8'h55 ;//U
					4'd2 : lcd_week[15:8] <= 8'h4F ;//O
					4'd3 : lcd_week[15:8] <= 8'h55 ;//U
					4'd4 : lcd_week[15:8] <= 8'h45 ;//E
					4'd5 : lcd_week[15:8] <= 8'h48 ;//H
					4'd6 : lcd_week[15:8] <= 8'h52 ;//R
					default : lcd_week[15:8] <= 8'h41 ;//A
				endcase
				case(week)
					4'd0 : lcd_week[7:0] <= 8'h54 ;//T
					4'd1 : lcd_week[7:0] <= 8'h4E ;//N
					4'd2 : lcd_week[7:0] <= 8'h4E ;//N
					4'd3 : lcd_week[7:0] <= 8'h45 ;//E
					4'd4 : lcd_week[7:0] <= 8'h44 ;//D
					4'd5 : lcd_week[7:0] <= 8'h55 ;//U
					4'd6 : lcd_week[7:0] <= 8'h49 ;//I
					default : lcd_week[7:0] <= 8'h54 ;//T
				endcase
				case(ampm)
					1'd0 :	lcd_ampm[7:0] <= 8'h41;
					1'd1 :	lcd_ampm[7:0] <= 8'h50;
					default : lcd_ampm[7:0] <= 8'h41;
				endcase
				case(save_hour[7:4])
					4'b0000 : lcd_hour[15:8] <= 8'h30 ;
					4'b0001 : lcd_hour[15:8] <= 8'h31 ;
					4'b0010 : lcd_hour[15:8] <= 8'h32 ;
					4'b0011 : lcd_hour[15:8] <= 8'h33 ;
					4'b0100 : lcd_hour[15:8] <= 8'h34 ;
					4'b0101 : lcd_hour[15:8] <= 8'h35 ;
					4'b0110 : lcd_hour[15:8] <= 8'h36 ;
					4'b0111 : lcd_hour[15:8] <= 8'h37 ;
					4'b1000 : lcd_hour[15:8] <= 8'h38 ;
					4'b1001 : lcd_hour[15:8] <= 8'h39 ;
					default : lcd_hour[15:8] <= 8'h30 ;
				endcase		
				case(save_hour[3:0])
					4'b0000 : lcd_hour[7:0] <= 8'h30 ;
					4'b0001 : lcd_hour[7:0] <= 8'h31 ;
					4'b0010 : lcd_hour[7:0] <= 8'h32 ;
					4'b0011 : lcd_hour[7:0] <= 8'h33 ;
					4'b0100 : lcd_hour[7:0] <= 8'h34 ;
					4'b0101 : lcd_hour[7:0] <= 8'h35 ;
					4'b0110 : lcd_hour[7:0] <= 8'h36 ;
					4'b0111 : lcd_hour[7:0] <= 8'h37 ;
					4'b1000 : lcd_hour[7:0] <= 8'h38 ;
					4'b1001 : lcd_hour[7:0] <= 8'h39 ;
					default : lcd_hour[7:0] <= 8'h30 ;
				endcase
				case(save_min[7:4])
					4'b0000 : lcd_min[15:8] <= 8'h30 ;
					4'b0001 : lcd_min[15:8] <= 8'h31 ;
					4'b0010 : lcd_min[15:8] <= 8'h32 ;
					4'b0011 : lcd_min[15:8] <= 8'h33 ;
					4'b0100 : lcd_min[15:8] <= 8'h34 ;
					4'b0101 : lcd_min[15:8] <= 8'h35 ;
					4'b0110 : lcd_min[15:8] <= 8'h36 ;
					4'b0111 : lcd_min[15:8] <= 8'h37 ;
					4'b1000 : lcd_min[15:8] <= 8'h38 ;
					4'b1001 : lcd_min[15:8] <= 8'h39 ;
					default : lcd_min[15:8] <= 8'h30 ;
				endcase
				case(save_min[3:0])
					4'b0000 : lcd_min[7:0] <= 8'h30 ;
					4'b0001 : lcd_min[7:0] <= 8'h31 ;
					4'b0010 : lcd_min[7:0] <= 8'h32 ;
					4'b0011 : lcd_min[7:0] <= 8'h33 ;
					4'b0100 : lcd_min[7:0] <= 8'h34 ;
					4'b0101 : lcd_min[7:0] <= 8'h35 ;
					4'b0110 : lcd_min[7:0] <= 8'h36 ;
					4'b0111 : lcd_min[7:0] <= 8'h37 ;
					4'b1000 : lcd_min[7:0] <= 8'h38 ;
					4'b1001 : lcd_min[7:0] <= 8'h39 ;
					default : lcd_min[7:0] <= 8'h30 ;
				endcase
				case(save_sec[7:4])
					4'b0000 : lcd_sec[15:8] <= 8'h30 ;
					4'b0001 : lcd_sec[15:8] <= 8'h31 ;
					4'b0010 : lcd_sec[15:8] <= 8'h32 ;
					4'b0011 : lcd_sec[15:8] <= 8'h33 ;
					4'b0100 : lcd_sec[15:8] <= 8'h34 ;
					4'b0101 : lcd_sec[15:8] <= 8'h35 ;
					4'b0110 : lcd_sec[15:8] <= 8'h36 ;
					4'b0111 : lcd_sec[15:8] <= 8'h37 ;
					4'b1000 : lcd_sec[15:8] <= 8'h38 ;
					4'b1001 : lcd_sec[15:8] <= 8'h39 ;
					default : lcd_sec[15:8] <= 8'h30 ;
				endcase
				case(save_sec[3:0])
					4'b0000 : lcd_sec[7:0] <= 8'h30 ;
					4'b0001 : lcd_sec[7:0] <= 8'h31 ;
					4'b0010 : lcd_sec[7:0] <= 8'h32 ;
					4'b0011 : lcd_sec[7:0] <= 8'h33 ;
					4'b0100 : lcd_sec[7:0] <= 8'h34 ;
					4'b0101 : lcd_sec[7:0] <= 8'h35 ;
					4'b0110 : lcd_sec[7:0] <= 8'h36 ;
					4'b0111 : lcd_sec[7:0] <= 8'h37 ;
					4'b1000 : lcd_sec[7:0] <= 8'h38 ;
					4'b1001 : lcd_sec[7:0] <= 8'h39 ;
					default : lcd_sec[7:0] <= 8'h30 ;
				endcase
			
				case(index)
					00	:	out	<=	8'h59; //Y
					01	:	out	<=	8'h3A; //:
					02	:	out	<= lcd_year[31:24];
					03	:	out	<= lcd_year[23:16];
					04	:	out	<= lcd_year[15:8];
					05	:	out	<= lcd_year[7:0];					
					06	:	out	<=	8'h20; //sp
					07	:	out	<=	8'h4D; //M
					08	:	out	<=	8'h3A; //:
					09	:	out	<= lcd_month[15:8];
					10	:	out	<= lcd_month[7:0];
					11	:	out	<=	8'h20; //sp
					12	:	out	<=	8'h44; //D
					13	:	out	<=	8'h3A; //:
					14	:	out	<= lcd_day[15:8];
					15	:	out	<= lcd_day[7:0];
	
					
					//LINE 2
					16	:	out	<= 8'h61;//a
					17	:	out	<= 8'h6c;//l					
					18	:	out	<=	8'h61;//a
					19	:	out	<=	8'h72;//r
					20	:	out	<=	8'h6d;//m
					21	:	out	<= lcd_ampm[7:0];
					22	:	out	<=	8'h4D; //SP
					23	:	out	<=	8'h20; //SP
					24	:	out	<= lcd_hour[15:8];
					25	:	out	<= lcd_hour[7:0];
					26	:	out	<=	8'h3A; //:
					27	:	out	<= lcd_min[15:8];
					28	:	out	<= lcd_min[7:0];
					29	:	out	<=	8'h3A; //:
					30	:	out	<= lcd_sec[15:8];
					31	:	out	<= lcd_sec[7:0];
					default : out	<= 8'h00;
				endcase
		end
		
//-----------------------------------------------------------------stop_watch
		else if(stop_watch) begin
				case(bcd_stop_hour[7:4])
					4'b0000 : lcd_hour[15:8] <= 8'h30 ;
					4'b0001 : lcd_hour[15:8] <= 8'h31 ;
					4'b0010 : lcd_hour[15:8] <= 8'h32 ;
					4'b0011 : lcd_hour[15:8] <= 8'h33 ;
					4'b0100 : lcd_hour[15:8] <= 8'h34 ;
					4'b0101 : lcd_hour[15:8] <= 8'h35 ;
					4'b0110 : lcd_hour[15:8] <= 8'h36 ;
					4'b0111 : lcd_hour[15:8] <= 8'h37 ;
					4'b1000 : lcd_hour[15:8] <= 8'h38 ;
					4'b1001 : lcd_hour[15:8] <= 8'h39 ;
					default : lcd_hour[15:8] <= 8'h30 ;
				endcase		
				case(bcd_stop_hour[3:0])
					4'b0000 : lcd_hour[7:0] <= 8'h30 ;
					4'b0001 : lcd_hour[7:0] <= 8'h31 ;
					4'b0010 : lcd_hour[7:0] <= 8'h32 ;
					4'b0011 : lcd_hour[7:0] <= 8'h33 ;
					4'b0100 : lcd_hour[7:0] <= 8'h34 ;
					4'b0101 : lcd_hour[7:0] <= 8'h35 ;
					4'b0110 : lcd_hour[7:0] <= 8'h36 ;
					4'b0111 : lcd_hour[7:0] <= 8'h37 ;
					4'b1000 : lcd_hour[7:0] <= 8'h38 ;
					4'b1001 : lcd_hour[7:0] <= 8'h39 ;
					default : lcd_hour[7:0] <= 8'h30 ;
				endcase
				case(bcd_stop_min[7:4])
					4'b0000 : lcd_min[15:8] <= 8'h30 ;
					4'b0001 : lcd_min[15:8] <= 8'h31 ;
					4'b0010 : lcd_min[15:8] <= 8'h32 ;
					4'b0011 : lcd_min[15:8] <= 8'h33 ;
					4'b0100 : lcd_min[15:8] <= 8'h34 ;
					4'b0101 : lcd_min[15:8] <= 8'h35 ;
					4'b0110 : lcd_min[15:8] <= 8'h36 ;
					4'b0111 : lcd_min[15:8] <= 8'h37 ;
					4'b1000 : lcd_min[15:8] <= 8'h38 ;
					4'b1001 : lcd_min[15:8] <= 8'h39 ;
					default : lcd_min[15:8] <= 8'h30 ;
				endcase
				case(bcd_stop_min[3:0])
					4'b0000 : lcd_min[7:0] <= 8'h30 ;
					4'b0001 : lcd_min[7:0] <= 8'h31 ;
					4'b0010 : lcd_min[7:0] <= 8'h32 ;
					4'b0011 : lcd_min[7:0] <= 8'h33 ;
					4'b0100 : lcd_min[7:0] <= 8'h34 ;
					4'b0101 : lcd_min[7:0] <= 8'h35 ;
					4'b0110 : lcd_min[7:0] <= 8'h36 ;
					4'b0111 : lcd_min[7:0] <= 8'h37 ;
					4'b1000 : lcd_min[7:0] <= 8'h38 ;
					4'b1001 : lcd_min[7:0] <= 8'h39 ;
					default : lcd_min[7:0] <= 8'h30 ;
				endcase
				case(bcd_stop_sec[7:4])
					4'b0000 : lcd_sec[15:8] <= 8'h30 ;
					4'b0001 : lcd_sec[15:8] <= 8'h31 ;
					4'b0010 : lcd_sec[15:8] <= 8'h32 ;
					4'b0011 : lcd_sec[15:8] <= 8'h33 ;
					4'b0100 : lcd_sec[15:8] <= 8'h34 ;
					4'b0101 : lcd_sec[15:8] <= 8'h35 ;
					4'b0110 : lcd_sec[15:8] <= 8'h36 ;
					4'b0111 : lcd_sec[15:8] <= 8'h37 ;
					4'b1000 : lcd_sec[15:8] <= 8'h38 ;
					4'b1001 : lcd_sec[15:8] <= 8'h39 ;
					default : lcd_sec[15:8] <= 8'h30 ;
				endcase
				case(bcd_stop_sec[3:0])
					4'b0000 : lcd_sec[7:0] <= 8'h30 ;
					4'b0001 : lcd_sec[7:0] <= 8'h31 ;
					4'b0010 : lcd_sec[7:0] <= 8'h32 ;
					4'b0011 : lcd_sec[7:0] <= 8'h33 ;
					4'b0100 : lcd_sec[7:0] <= 8'h34 ;
					4'b0101 : lcd_sec[7:0] <= 8'h35 ;
					4'b0110 : lcd_sec[7:0] <= 8'h36 ;
					4'b0111 : lcd_sec[7:0] <= 8'h37 ;
					4'b1000 : lcd_sec[7:0] <= 8'h38 ;
					4'b1001 : lcd_sec[7:0] <= 8'h39 ;
					default : lcd_sec[7:0] <= 8'h30 ;
				endcase
				case(index)
					00	:	out	<=	8'h73; //s
					01	:	out	<=	8'h74; //t
					02	:	out	<= 8'h6f;//o
					03	:	out	<= 8'h70;//p
					04	:	out	<= 8'h20;
					05	:	out	<= 8'h77;//w				
					06	:	out	<=	8'h61;//a
					07	:	out	<=	8'h74;//t
					08	:	out	<=	8'h63;//c
					09	:	out	<= 8'h68;//h
					10	:	out	<= 8'h20;
					11	:	out	<=	8'h20; //sp
					12	:	out	<=	8'h20; //D
					13	:	out	<=	8'h20; //:
					14	:	out	<= 8'h20;
					15	:	out	<= 8'h20;
	
					
					//LINE 2
					16	:	out	<= 8'h20;
					17	:	out	<= 8'h20;
					18	:	out	<= 8'h20;
					19	:	out	<=	8'h20; //SP
					20	:	out	<=	8'h20; //SP
					21	:	out	<= 8'h20;
					22	:	out	<=	8'h20; //SP
					23	:	out	<=	8'h20; //SP
					24	:	out	<= lcd_hour[15:8];
					25	:	out	<= lcd_hour[7:0];
					26	:	out	<=	8'h3A; //:
					27	:	out	<= lcd_min[15:8];
					28	:	out	<= lcd_min[7:0];
					29	:	out	<=	8'h3A; //:
					30	:	out	<= lcd_sec[15:8];
					31	:	out	<= lcd_sec[7:0];
					default : out	<= 8'h00;
				endcase
		end

//-----------------------------------------------------------------set_timer
			else if(set_timer) begin
				case(bcd_timer_hour[7:4])
					4'b0000 : lcd_hour[15:8] <= 8'h30 ;
					4'b0001 : lcd_hour[15:8] <= 8'h31 ;
					4'b0010 : lcd_hour[15:8] <= 8'h32 ;
					4'b0011 : lcd_hour[15:8] <= 8'h33 ;
					4'b0100 : lcd_hour[15:8] <= 8'h34 ;
					4'b0101 : lcd_hour[15:8] <= 8'h35 ;
					4'b0110 : lcd_hour[15:8] <= 8'h36 ;
					4'b0111 : lcd_hour[15:8] <= 8'h37 ;
					4'b1000 : lcd_hour[15:8] <= 8'h38 ;
					4'b1001 : lcd_hour[15:8] <= 8'h39 ;
					default : lcd_hour[15:8] <= 8'h30 ;
				endcase		
				case(bcd_timer_hour[3:0])
					4'b0000 : lcd_hour[7:0] <= 8'h30 ;
					4'b0001 : lcd_hour[7:0] <= 8'h31 ;
					4'b0010 : lcd_hour[7:0] <= 8'h32 ;
					4'b0011 : lcd_hour[7:0] <= 8'h33 ;
					4'b0100 : lcd_hour[7:0] <= 8'h34 ;
					4'b0101 : lcd_hour[7:0] <= 8'h35 ;
					4'b0110 : lcd_hour[7:0] <= 8'h36 ;
					4'b0111 : lcd_hour[7:0] <= 8'h37 ;
					4'b1000 : lcd_hour[7:0] <= 8'h38 ;
					4'b1001 : lcd_hour[7:0] <= 8'h39 ;
					default : lcd_hour[7:0] <= 8'h30 ;
				endcase
				case(bcd_timer_min[7:4])
					4'b0000 : lcd_min[15:8] <= 8'h30 ;
					4'b0001 : lcd_min[15:8] <= 8'h31 ;
					4'b0010 : lcd_min[15:8] <= 8'h32 ;
					4'b0011 : lcd_min[15:8] <= 8'h33 ;
					4'b0100 : lcd_min[15:8] <= 8'h34 ;
					4'b0101 : lcd_min[15:8] <= 8'h35 ;
					4'b0110 : lcd_min[15:8] <= 8'h36 ;
					4'b0111 : lcd_min[15:8] <= 8'h37 ;
					4'b1000 : lcd_min[15:8] <= 8'h38 ;
					4'b1001 : lcd_min[15:8] <= 8'h39 ;
					default : lcd_min[15:8] <= 8'h30 ;
				endcase
				case(bcd_timer_min[3:0])
					4'b0000 : lcd_min[7:0] <= 8'h30 ;
					4'b0001 : lcd_min[7:0] <= 8'h31 ;
					4'b0010 : lcd_min[7:0] <= 8'h32 ;
					4'b0011 : lcd_min[7:0] <= 8'h33 ;
					4'b0100 : lcd_min[7:0] <= 8'h34 ;
					4'b0101 : lcd_min[7:0] <= 8'h35 ;
					4'b0110 : lcd_min[7:0] <= 8'h36 ;
					4'b0111 : lcd_min[7:0] <= 8'h37 ;
					4'b1000 : lcd_min[7:0] <= 8'h38 ;
					4'b1001 : lcd_min[7:0] <= 8'h39 ;
					default : lcd_min[7:0] <= 8'h30 ;
				endcase
				case(bcd_timer_sec[7:4])
					4'b0000 : lcd_sec[15:8] <= 8'h30 ;
					4'b0001 : lcd_sec[15:8] <= 8'h31 ;
					4'b0010 : lcd_sec[15:8] <= 8'h32 ;
					4'b0011 : lcd_sec[15:8] <= 8'h33 ;
					4'b0100 : lcd_sec[15:8] <= 8'h34 ;
					4'b0101 : lcd_sec[15:8] <= 8'h35 ;
					4'b0110 : lcd_sec[15:8] <= 8'h36 ;
					4'b0111 : lcd_sec[15:8] <= 8'h37 ;
					4'b1000 : lcd_sec[15:8] <= 8'h38 ;
					4'b1001 : lcd_sec[15:8] <= 8'h39 ;
					default : lcd_sec[15:8] <= 8'h30 ;
				endcase
				case(bcd_timer_sec[3:0])
					4'b0000 : lcd_sec[7:0] <= 8'h30 ;
					4'b0001 : lcd_sec[7:0] <= 8'h31 ;
					4'b0010 : lcd_sec[7:0] <= 8'h32 ;
					4'b0011 : lcd_sec[7:0] <= 8'h33 ;
					4'b0100 : lcd_sec[7:0] <= 8'h34 ;
					4'b0101 : lcd_sec[7:0] <= 8'h35 ;
					4'b0110 : lcd_sec[7:0] <= 8'h36 ;
					4'b0111 : lcd_sec[7:0] <= 8'h37 ;
					4'b1000 : lcd_sec[7:0] <= 8'h38 ;
					4'b1001 : lcd_sec[7:0] <= 8'h39 ;
					default : lcd_sec[7:0] <= 8'h30 ;
				endcase
				case(index)
					00	:	out	<=	8'h20;//
					01	:	out	<=	8'h20;//
					02	:	out	<= 8'h20;//
					03	:	out	<= 8'h20;//
					04	:	out	<= 8'h20;
					05	:	out	<= 8'h77;//t				
					06	:	out	<=	8'h61;//i
					07	:	out	<=	8'h74;//m
					08	:	out	<=	8'h63;//e
					09	:	out	<= 8'h68;//r
					10	:	out	<= 8'h20;
					11	:	out	<=	8'h20; //sp
					12	:	out	<=	8'h20; //D
					13	:	out	<=	8'h20; //:
					14	:	out	<= 8'h20;
					15	:	out	<= 8'h20;
	
					
					//LINE 2
					16	:	out	<= 8'h20;
					17	:	out	<= 8'h20;
					18	:	out	<= 8'h20;
					19	:	out	<=	8'h20; //SP
					20	:	out	<=	8'h20; //SP
					21	:	out	<= 8'h20;
					22	:	out	<=	8'h20; //SP
					23	:	out	<=	8'h20; //SP
					24	:	out	<= lcd_hour[15:8];
					25	:	out	<= lcd_hour[7:0];
					26	:	out	<=	8'h3A; //:
					27	:	out	<= lcd_min[15:8];
					28	:	out	<= lcd_min[7:0];
					29	:	out	<=	8'h3A; //:
					30	:	out	<= lcd_sec[15:8];
					31	:	out	<= lcd_sec[7:0];
					default : out	<= 8'h00;
				endcase
		end			
	end
	
		
endmodule
