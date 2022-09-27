`timescale 1ns / 1ps

module testbench_lab3_2(
    );

	reg[4:0] smartCode;
	reg CLK;
	reg lab; //0:Digital, 1:Mera
	reg [1:0] mode; //00:exit, 01:enter, 1x: idle 
	wire [5:0] numOfStuInMera;
	wire [5:0] numOfStuInDigital;
	wire restrictionWarnMera;//1:show warning, 0:do not show warning
	wire isFullMera; //1:full, 0:not full
	wire isEmptyMera; //1: empty, 0:not empty
	wire unlockMera;	//1:door is open, 0:closed
	wire restrictionWarnDigital;//1:show warning, 0:do not show warning
	wire isFullDigital; //1:full, 0:not full
	wire isEmptyDigital; //1: empty, 0:not empty
	wire unlockDigital; //1:door is open, 0:closed
	integer i,result;

	lab3_2 INSTANCE(smartCode, CLK,  lab,  mode, numOfStuInMera, numOfStuInDigital, 
					restrictionWarnMera, isFullMera,  isEmptyMera, unlockMera, 
					restrictionWarnDigital, isFullDigital,  isEmptyDigital, unlockDigital);


	initial CLK = 1;
	always #5 CLK = ~CLK;


	initial begin
		$display("Starting Testbench");
		result=0;
		
		//Case 1: A student with odd number of 1’s (10101) wants to enter Digital.
		#1;
		smartCode=5'b10101; //odd 1's
		lab=1'b0; //digital
		mode=2'b01; //enter
		#10; //11
		if (numOfStuInDigital==6'b000001 && isEmptyDigital==0 && unlockDigital==1'b1) 
		begin
			result=result+1;
			$display("Case  1 PASSED <time:%3d>",$time);;
		end
		else $display("Case  1 FAILED!  <time:%3d>",$time);;
		
		//Case 2: A student with even number of 1’s (11101) wants to enter Digital.
		#1; //12
		smartCode=5'b11101; //even 1's
		lab=1'b0; //digital
		mode=2'b01; //enter
		#9; //21
		if (numOfStuInDigital==6'b000010 && unlockDigital==1'b1)
		begin
			result=result+1;
			$display("Case  2 PASSED <time:%3d>",$time);
		end
		else $display("Case  2 FAILED!  <time:%3d>",$time);
		
		//Case 3: A student with even number of 1's (11101) wants to enter Mera. 
		#1; //22
		smartCode=5'b11101; //even 1's
		lab=1'b1; //mera
		mode=2'b01; //enter
		#9; //31
		if (numOfStuInMera==6'b000001 && unlockMera==1'b1 && unlockDigital==1'b0)
		begin
			result=result+1;
			$display("Case  3 PASSED <time:%3d>",$time);
		end
		else $display("Case  3 FAILED!  <time:%3d>",$time);		
		
		
		//Case 4: A student with odd number of 1's (10101) wants to enter Mera.
		#1; //32
		smartCode=5'b10101; //odd 1's
		lab=1'b1; //mera
		mode=2'b01; //enter
		#9; //41
		if (numOfStuInMera==6'b000010 && unlockMera==1'b1)
		begin
			result=result+1;
			$display("Case  4 PASSED <time:%3d>",$time);
		end
		else $display("Case  4 FAILED!  <time:%3d>",$time);
		
		
		//Case 5: System is in idle mode.
		#1; //42
		mode=2'b11; //idle
		#9; //51
		if (unlockMera==1'b0)
		begin
			result=result+1;
			$display("Case 5 PASSED <time:%3d>",$time);
		end
		else $display("Case  5 FAILED!  <time:%3d>",$time);		


		//Case 6: 14 students with even number of 1’s  (11101) want to enter Digital
		#1; //52
		smartCode=5'b11101; //even 1's
		lab=1'b0; //digital
		mode=2'b01; //enter
		for (i=1;i<=14;i=i+1) #10; //192
		if (restrictionWarnDigital==1'b1 && numOfStuInDigital==6'b001111)
		begin
			result=result+1;
			$display("Case  6 PASSED <time:%3d>",$time);
		end
		else $display("Case  6 FAILED!  <time:%3d>",$time);			
		
		
		//Case 7: A student with even number of 1's (11101) want to enter Mera lab.
		#1; //193
		smartCode=5'b11101; //even 1's
		lab=1'b1; //mera
		mode=2'b01; //enter
		#8; //201
		if (restrictionWarnDigital==1'b0 && unlockMera==1'b1 &&  numOfStuInDigital==6'b001111 &&  numOfStuInMera==6'b000011)
		begin
			result=result+1;
			$display("Case  7 PASSED <time:%3d>",$time);
		end
		else $display("Case  7 FAILED!  <time:%3d>",$time);				
		
		
		//Case 8: A student leaves Digital.
		#1; //202
		smartCode=5'b11101; //even 1's
		lab=1'b0; //digital
		mode=2'b01; //enter
		#9; //211
		//restrictionWarnDigital is active now..
		lab=1'b0; //digital
		mode=2'b00; //leave
		#10//221
		if (restrictionWarnDigital==1'b0 && unlockDigital==1'b1 &&  numOfStuInDigital==6'b001110)
		begin
			result=result+1;
			$display("Case  8 PASSED <time:%3d>",$time);
		end
		else $display("Case  8 FAILED!  <time:%3d>",$time);		
		
		
		//Case 9: 14 students with odd number of 1's  (10101) want to enter Mera lab.
		#1; //222
		smartCode=5'b10101; //odd 1's
		lab=1'b1; //mera
		mode=2'b01; //enter
		for (i=1;i<=14;i=i+1) #10;//362
		if (restrictionWarnMera==1'b1 && numOfStuInMera==6'b001111)
		begin
			result=result+1;
			$display("Case  9 PASSED <time:%3d>",$time);
		end
		else $display("Case  9 FAILED!  <time:%3d>",$time);	
		

		//Case 10: System is in idle mode. 
		#1; //363
		mode=2'b11; //idle
		#8; //371
		if (restrictionWarnMera==1'b0)
		begin
			result=result+1;
			$display("Case 10 PASSED <time:%3d>",$time);
		end
		else $display("Case 10 FAILED!  <time:%3d>",$time);;	

		//Case 11: Let 16 students with odd number of 1's (10101) want to enter Digital.
		#1; //372
		smartCode=5'b10101; //odd 1's
		lab=1'b0; //digital
		mode=2'b01; //enter
		for (i=1;i<=16;i=i+1) #10;//532
		if (isFullDigital==1'b1 && numOfStuInDigital==6'b011110)
		begin
			result=result+1;
			$display("Case 11 PASSED <time:%3d>",$time);
		end
		else $display("Case 11 FAILED!  <time:%3d>",$time);;	
		

		//Case 12: A student with odd number of 1's  (10101) want to enter Digital lab.
		#1; //533
		smartCode=5'b10101; //odd 1's
		lab=1'b0; //digital
		mode=2'b01; //enter
		#8;//541
		if (isFullDigital==1'b1 && numOfStuInDigital==6'b011110 && unlockDigital==1'b0)
		begin
			result=result+1;
			$display("Case 12 PASSED <time:%3d>",$time);
		end
		else $display("Case 12 FAILED!  <time:%3d>",$time);		
		
		//Case 13: Let 15 students with even number of 1's (11101) want to enter Mera.
		#1; //542
		smartCode=5'b11101; //even 1's
		lab=1'b1; //mera
		mode=2'b01; //enter
		for (i=1;i<=15;i=i+1) #10;//692
		if (isFullMera==1'b1 && numOfStuInMera==6'b011110)
		begin
			result=result+1;
			$display("Case 13 PASSED <time:%3d>",$time);
		end
		else $display("Case 13 FAILED!  <time:%3d>",$time);			


		//Case 14: A student with even number of 1's  (11101) want to enter Mera lab.
		#1; //693
		smartCode=5'b11101; //even 1's
		lab=1'b1; //mera
		mode=2'b01; //enter
		#8;//701
		if (isFullMera==1'b1 && numOfStuInMera==6'b011110 && unlockMera==1'b0)
		begin
			result=result+1;
			$display("Case 14 PASSED <time:%3d>",$time);
		end
		else $display("Case 14 FAILED!  <time:%3d>",$time);	


		//Case 15: A student leaves Digital.
		#1; //702
		//smartCode=5'b10101; //odd 1's
		lab=1'b0; //digital
		mode=2'b00; //leave
		#9;//711
		if (isFullDigital==1'b0 && numOfStuInDigital==6'b011101 && unlockDigital==1'b1)
		begin
			result=result+1;
			$display("Case 15 PASSED <time:%3d>",$time);
		end
		else $display("Case 15 FAILED!  <time:%3d>",$time);	
		

		//Case 16: A student leaves Mera.
		#1; //712
		//smartCode=5'b10101; //odd 1's
		lab=1'b1; //Mera
		mode=2'b00; //leave
		#9;//721
		if (isFullMera==1'b0 && numOfStuInMera==6'b011101 && unlockMera==1'b1)
		begin
			result=result+1;
			$display("Case 16 PASSED <time:%3d>",$time);
		end
		else $display("Case 16 FAILED!  <time:%3d>",$time);	
		

		//Case 17 : 29 students leave Digital.
		#1; //722
		//smartCode=5'b10101; //odd 1's
		lab=1'b0; //digital
		mode=2'b00; //leave
		for (i=1;i<=29;i=i+1) #10;//1012
		if (isEmptyDigital==1'b1 && numOfStuInDigital==6'b000000 && unlockDigital==1'b1)
		begin
			result=result+1;
			$display("Case 17 PASSED <time:%3d>",$time);
		end
		else $display("Case 17 FAILED!  <time:%3d>",$time);		
		
		//Case 18: System is in idle mode.
		#1; //1013
		//smartCode=5'b10101; //odd 1's
		//lab=1'b1; //mera
		mode=2'b11; //idle
		#8; //1021
		if (isEmptyDigital==1'b1 && numOfStuInDigital==6'b000000 && unlockDigital==1'b0)
		begin
			result=result+1;
			$display("Case 18 PASSED <time:%3d>",$time);
		end
		else $display("Case 18 FAILED!  <time:%3d>",$time);	


		//Case 19: A student leaves digital.
		#1; //1022
		//smartCode=5'b10101; //odd 1's
		lab=1'b0; //digital
		mode=2'b00; //leave
		#9; //1031
		if (isEmptyDigital==1'b1 && numOfStuInDigital==6'b000000 && unlockDigital==1'b0)
		begin
			result=result+1;
			$display("Case 19 PASSED <time:%3d>",$time);
		end
		else $display("Case 19 FAILED!  <time:%3d>",$time);		



		//Case 20 : 31 students (29+2) leave mera.
		#1; //1032
		//smartCode=5'b10101; //odd 1's
		lab=1'b1; //mera
		mode=2'b00; //leave
		for (i=1;i<=32;i=i+1) #10;//1352
		if (isEmptyMera==1'b1 && numOfStuInMera==6'b000000 && unlockMera==1'b0)
		begin
			result=result+1;
			$display("Case 20 PASSED <time:%3d>",$time);
		end
		else $display("Case 20 FAILED!  <time:%3d>",$time);;	


		$display("Result %d",result*5); //max 100 
		$finish;
	end
 
endmodule
