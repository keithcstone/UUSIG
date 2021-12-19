begin                                                                   00001000          
% Conversion of streamfile to aligned180.                               00001100          
% If boolean(value.[0:1]) NO ascii to ebcdic conversion                 00001200          
% If boolean(value.[1:1]) DON'T write a record for every new-line.      00001300          
% If boolean(value.[2:1]) DON'T expand tab.                             00001400          
 $INCLUDE "S/EXP/UTILS"                                                 00001500          
 file                                                                   00001600          
        streamfile      % Input file, supposed to be ASCII stream       00001700          
            (kind=disk, myuse=1, dependentspecs,                        00001800          
             newfile=false, dependentintmode=true),                     00001900          
        alignedfile                                                     00002000          
            (kind=disk, protection=save);                               00002100          
 integer                                                                00002200          
        i,                                                              00002300          
        splitcnt,       % # lines split                                 00002400          
        tab_sz,                                                         00002500          
        nl_cnt,                                                         00002600          
        alignedrecsz,                                                   00002700          
        alignedchars,                                                   00002800          
        inputchars;                                                     00002900          
 array                                                                  00003000          
        alignedrecord[0:0],                                             00003100          
        streamrecord[0:0];                                              00003200          
 pointer                                                                00003300          
        pa,                                                             00003400          
        ps;                                                             00003500          
 boolean                                                                00003600          
        nl_to_newrec,                                                   00003700          
        expanding_tab,                                                  00003800          
        translating;                                                    00003900          
                                                                        00004000          
 interrupt afp;                                                         00004100          
 begin                                                                  00004200          
 % Agence France Presse. Gives some infos.                              00004300          
  display(string(inputchars, *) !! " chars read from 'streamfile', "    00004400          
       !! string(alignedfile.nextrecord, *)                             00004500          
       !! " records written on 'alignedfile'");                         00004600          
  reset(myself.exceptionevent);                                         00004700          
 end;                                                                   00004800          
                                                                        00004900          
% Outer block                                                           00005000          
                                                                        00005100          
 alignedrecsz := alignedfile.maxrecsize;                                00005200          
 if alignedfile.framesize = 8 then                                      00005300          
     alignedchars := alignedrecsz                                       00005400          
 else                                                                   00005500          
     alignedchars := alignedrecsz * 6;                                  00005600          
 if (alignedchars = 0) then                                             00005700          
    begin                                                               00005800          
    alignedchars := 84;                                                 00005900          
    alignedfile.maxrecsize := 14;                                       00006000          
    alignedrecsz := 14;                                                 00006100          
    alignedfile.blocksize := 420;                                       00006200          
    SAY("Set 'alignedfile' to default alignement (84X30)");             00006300          
    end                                                                 00006400          
 else                                                                   00006500          
    SAY("Record size for 'alignedfile' set to " C                       00006600          
            alignedchars for * numeric C " chars");                     00006700          
                                                                        00006800          
 if translating := not boolean(myself.taskvalue.[0:1]) then             00006900          
    SAY("File 'streamfile' is ASCII, 'alignedfile' is EBCDIC")          00007000          
 else                                                                   00007100          
    SAY("File 'streamfile' and 'alignedfile' are EBCDIC");              00007200          
 if nl_to_newrec:= not boolean(myself.taskvalue.[1:1]) then             00007300          
    SAY("Will write a record on New-line");                             00007400          
 if expanding_tab:= not boolean(myself.taskvalue.[2:1]) then            00007500          
    SAY("Will expand Tab");                                             00007600          
 tab_sz := 8;                                                           00007700          
                                                                        00007800          
 % Resize w. room for NL & TAB                                          00007900          
 resize(alignedrecord, ((alignedchars+5+1+tab_sz) div 6), discard);     00008000          
 rabp(pa, alignedrecord);                                               00008100          
 rabp(ps, streamrecord);                                                00008200          
                                                                        00008300          
 attach afp to myself.exceptionevent;                                   00008400          
 enable afp;                                                            00008500          
                                                                        00008600          
 while not read(streamfile, 1, streamrecord) do                         00008700          
       begin                                                            00008800          
       inputchars := *+1;                                               00008900          
       if translating then                                              00009000          
          replace pa:pa by ps for 1 with asciitoebcdic                  00009100          
       else                                                             00009200          
          replace pa:pa by ps for 1;                                    00009300          
       if (expanding_tab and real(pa-1,1) = 5) then  % Got a tab        00009400          
          begin                                                         00009500          
          nl_cnt := *+1;                                                00009600          
          pa := *-1;                                                    00009700          
          replace pa:pa by " " for (tab_sz - (offset(pa) mod tab_sz));  00009800          
          end;                                                          00009900          
       if (nl_to_newrec and real(pa-1,1) = 37) then  % Got a NL         00010000          
          begin                                                         00010100          
          nl_cnt := *+1;                                                00010200          
          pa := *-1;                                                    00010300          
          replace pa by " ";                                            00010400          
          end                                                           00010500          
       else                                                             00010600          
          nl_cnt := 0;                                                  00010700          
       if (nl_cnt > 0)                                                  00010800          
       or (offset(pa) geq alignedchars) then                            00010900          
          begin                                                         00011000          
          if (nl_cnt = 1) and (offset(pa) = 0) then                     00011100          
          else                                                          00011200          
             write(alignedfile, alignedrecsz, alignedrecord);           00011300          
         if (offset(pa) geq alignedchars) then                          00011400          
            splitcnt := *+1;                                            00011500          
          rabp(pa, alignedrecord);                                      00011600          
          end;                                                          00011700          
       end;                                                             00011800          
 if offset(pa) > 0 then                                                 00011900          
    begin                                                               00012000          
    write(alignedfile, alignedrecsz, alignedrecord);                    00012100          
    SAY("WARNING: Number of chars read from 'streamfile' is not " C     00012200          
        "modulo 'alignedfile' record size!..");                         00012300          
    end;                                                                00012400          
 if splitcnt > 0 then                                                   00012500          
    SAY("WARNING: " C splitcnt for * numeric C " lines split");         00012600          
    SAY(inputchars for * numeric C " chars read from 'streamfile', "    00012700          
        C alignedfile.nextrecord for * numeric                          00012800          
        C " records written on 'alignedfile'");                         00012900          
 close(alignedfile, crunch);                                            00013000          
end.                                                                    00013100          
