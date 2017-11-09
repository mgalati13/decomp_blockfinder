libname lib '\\orgrdnfs01\data\miplib';
%let maxtime = 60;
%let hybrid  = false;
/*%let instance=z10teams;*/
%let instance=aflow30a;
/*%let instance=aflow40b;*/
%let instance=modglob;

proc optmilp data=lib.&instance maxtime=&maxtime;  
  decomp hybrid=&hybrid;
run;
PROC IMPORT OUT= &instance._blocks(rename=(var1=_row_ var2=_block_))
            DATAFILE= "\\orgrdnfs01\data\miplib\&instance..blocks_comm" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
     DATAROW=1;
	 guessingrows=2147483647; 
RUN;

data WORK.AFLOW30A_BLOCKS (rename=(var1=_row_ var2=_block_))   ;
 infile '\\orgrdnfs01\data\miplib\aflow30a.blocks_comm' delimiter='09'x MISSOVER DSD lrecl=32767 ;
          informat VAR1 $200. ;
          informat VAR2 best32. ;
          format VAR1 $200. ;
          format VAR2 best12. ;
       input
                   VAR1  $
                   VAR2
       ;
       run;


proc optmilp data=lib.&instance maxtime=&maxtime;
  decomp blocks=&instance._blocks hybrid=&hybrid;
run;

