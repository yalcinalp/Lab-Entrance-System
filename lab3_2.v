
`timescale 1ns / 1ps 
module lab3_2(
			input[4:0] smartCode,
			input CLK, 
			input lab, //0:Digital, 1:Mera
			input [1:0] mode, //00:exit, 01:enter, 1x: idle 
			output reg [5:0] numOfStuInMera,
			output reg [5:0] numOfStuInDigital,
			output reg restrictionWarnMera,//1:show warning, 0:do not show warning
			output reg isFullMera, //1:full, 0:not full
			output reg isEmptyMera, //1: empty, 0:not empty
			output reg unlockMera,	//1:door is open, 0:closed
			output reg restrictionWarnDigital,//1:show warning, 0:do not show warning
			output reg isFullDigital, //1:full, 0:not full
			output reg isEmptyDigital, //1: empty, 0:not empty
			output reg unlockDigital //1:door is open, 0:closed
	);
	 
	// You may declare your variables below
	
			reg isodd;
			reg[2:0] tmp_var;

	
	initial begin
			numOfStuInMera=0;
			numOfStuInDigital=0;
			restrictionWarnMera=0;
			isFullMera=0;
			isEmptyMera=1'b1;
			unlockMera=0;		
			restrictionWarnDigital=0;
			isFullDigital=0;
			isEmptyDigital=1'b1;
			unlockDigital=0;
			
			isodd = 0;
			tmp_var = 0;
	end
	//Modify the lines below to implement your design
	
	//always @(posedge CLK) 
	//...
	
	always @(posedge CLK)
	begin
	
	unlockMera=0;
	unlockDigital=0;
	restrictionWarnMera=0;
	restrictionWarnDigital=0;
	
	// BU 4 SATIRLIK YORUM SU ANKI ISIM VE ONEMLI 
	//isFullMera isEmptyMera durumlarını ger clock cycle ın basında nasıl degismesi gerektigi hakkında bir yorumum yok, onu halledebilmem lazım
	//isempty ve isfull durumlarını ekleme ve çıkarma ile degistirmem lazım ledlerin yanması icin ?
	// sonucta fpga de bir sekilde mode 2 ya da 3 yapılacak, bu anlmada benim bir if else icinde onu da handle edebilmem lazım
	// cıkıs yapmak isteyen bir ogrenci oldugunda da unlock ledini yakmalı mıyım 
	
	
	tmp_var = smartCode[0] + smartCode[1] + smartCode[2] + smartCode[3] + smartCode[4];
	
	if(tmp_var % 2 == 1)
	begin
	    isodd = 1; 
	end
	
	if(mode == 1)
	begin
	// mod kontrol for getting into the lab
	
		if(lab == 1)
		begin
		//Merada
		
			if(isFullMera == 1)
			begin
			//Doluysa hicbir sey yapma
			end
			
			if(numOfStuInMera < 30)
			begin
			//Lab bos is islemlere devam
				
				if(numOfStuInMera < 15)
				begin 
				//15 kisiden az ise kontrol yapmadan direkt iceri alıyoruz
				unlockMera=1;
				numOfStuInMera = numOfStuInMera + 1;
				isEmptyMera = 0;
					
					if(numOfStuInMera == 30)
					begin
					//eger iceri gelen yeni ogrenci ile birlikte kapasite dolduysa
					//isFullMera degiskeni bir yapılacak
					
					isFullMera = 1;
					
					end
				
				end
				
				
				else if(numOfStuInMera >= 15)
				begin
				
					if(^smartCode == 1)
					begin
					// isodd == 0 demek cift sayı demek
					// ogrenci iceri alınmamalı
					
					restrictionWarnMera = 1;
					
					
					end
					
					if(^smartCode == 0)
					begin
					// isodd == 1 demek tek sayı demek
					// o zaman restrictionWarnMera 0 yapılmalı ? 0 kalmalı
					// ogrenci iceri girebilmeli
					//125. satırda yanlıslık var aga ismen
					// hep mera ismi kullanmısım neredeyse bu case i mera diye degistirsem iyi olur 
					
					restrictionWarnMera = 0;
					unlockMera=1;
					numOfStuInMera = numOfStuInMera + 1;
					isEmptyMera = 0;
					
					
						if(numOfStuInMera == 30)
						begin
						//eger iceri gelen yeni ogrenci ile birlikte kapasite dolduysa
						//isFullMera degiskeni bir yapılacak
					
						isFullMera = 1;
					
						end


					end
					
					
				end
			
			
			end
			
			
		end
		
		if(lab == 0)
		begin
		//mod digitalde
		
		//BURALARIN İCLERİNİ DOLDURMAYI UNUTMA copy paste yap fakat isodd durumundaki farklı davranısı bil!
		
			if(isFullDigital == 1)
			begin
			//Doluysa hicbir sey yapma
			end
			
			if(numOfStuInDigital < 30)
			begin
			//Lab bos is islemlere devam
				
				if(numOfStuInDigital < 15)
				begin 
				//15 kisiden az ise kontrol yapmadan direkt iceri alıyoruz
				unlockDigital=1;
				numOfStuInDigital = numOfStuInDigital + 1;
				isEmptyDigital = 0;
					
					if(numOfStuInDigital == 30)
					begin
					//eger iceri gelen yeni ogrenci ile birlikte kapasite dolduysa
					//isFullMera degiskeni bir yapılacak
					
					isFullDigital = 1;
					
					end
				
				end
				
				
				else if(numOfStuInDigital >= 15)
				begin
				
					if(^smartCode == 0)
					begin
					// isodd == 0 demek cift sayı demek
					// ogrenci iceri alınmamalı
					
					restrictionWarnDigital = 1;
					
					
					end
					
					else if(^smartCode == 1)
					begin
					// isodd == 1 demek tek sayı demek
					// o zaman restrictionWarnMera 0 yapılmalı ? 0 kalmalı
					// ogrenci iceri girebilmeli
					//125. satırda yanlıslık var aga ismen
					// hep mera ismi kullanmısım neredeyse bu case i mera diye degistirsem iyi olur 
					
					restrictionWarnDigital = 0;
					unlockDigital=1;
					numOfStuInDigital = numOfStuInDigital + 1;
					isEmptyDigital = 0;
					
					
						if(numOfStuInDigital == 30)
						begin
						//eger iceri gelen yeni ogrenci ile birlikte kapasite dolduysa
						//isFullMera degiskeni bir yapılacak
					
						isFullDigital = 1;
					
						end


					end
					
					
				end
			
			
			end		
		
		
		end
		
	end

	if(mode == 0)
	begin 
	// getting out from the lab 
	
		if(lab == 0)
		begin
		//mod Digitalde 
		
		//BURALARIN İCLERİNİ DOLDURMAYI UNUTMA!
		//sayı azalt with just one kontrol which is "isemptylab"
		
			if(isEmptyDigital == 0) //Lab bos degil ise cikis yapılabilsin!
			begin
			
			unlockDigital = 1;
			numOfStuInDigital = numOfStuInDigital-1;
			isFullDigital = 0;
			//Cıkıs yapma izleminden sonra iceride kimse kalmadıysa lab_bos ledi yanmalı
			
				if(numOfStuInDigital == 0)
				begin
				
					isEmptyDigital = 1;
				
				end
			
			end
		
		end
		
		if(lab == 1)
		begin
		//mod Merada
		
		//BURALARIN İCLERİNİ DOLDURMAYI UNUTMA!

		//sayı azalt with just one kontrol which is "isemptylab"		
		
			if(isEmptyMera == 0) //Lab bos degil ise cikis yapılabilsin!
			begin
			
				unlockMera = 1;
				numOfStuInMera = numOfStuInMera-1;
				isFullMera = 0;
				
				if(numOfStuInMera == 0)
				begin
				
					isEmptyMera = 1;
				
				end
			
			end
		
		end
	
	end
	
	
	else
	begin
	
	
	//bu mod is just for clearing and locking the doors?
	//Zaten en basta 0 ladıgımız icin bu duruma icerik yazmama gerek yok degil mi?
	//BURALARIN İCLERİNİ DOLDURMAYI UNUTMA!
	
	
	end 
	
	
	end	//posedge clk icin olan end bu knk

endmodule

