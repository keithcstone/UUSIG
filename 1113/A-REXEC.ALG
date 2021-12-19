% A_REXEC : A Series REXEC client                                       00001000          
% Syntax:                                                               00001100          
%    RUN A_REXEC("<Remote host> <user> <password> <Remote command>")    00001200          
%    e.g. RUN A_REXEC("UNIXBOX uuu ppp /bin/ls -l /etc/passwd")         00001300          
%                                                                       00001400          
% A_REXEC opens a port file with MYNAME = "512." and YOURHOST eql to    00001500          
% the name specified in the parameter. Sends the command to the         00001600          
% remote server, wait for an ACK and then writes every byte received    00001700          
% to STREAMFILE.                                                        00001800          
%                                                                       00001900          
% Trace mode may be set using TASKVALUE=1.                              00002000          
%                                                                       00002100          
$ SET LEVEL 2                                                           00002200          
$ INSTALLATION 1                                                        00002300          
PROCEDURE WORK(CMD); ARRAY CMD[*];                                      00002400          
BEGIN                                                                   00002500          
 file                                                                   00002700          
        uclientport                                                     00002800          
                (KIND                  = PORT                           00002900          
                ,FILENAME              = "UCLIENTPORT."                 00003000          
                ,MYNAME                = "512."                         00003100          
                ,SERVICE               = TCPNATIVESERVICE               00003200          
                ,MAXRECSIZE            = 4098                           00003300          
                ,FRAMESIZE             = 8                              00003400          
                ,SECURITYTYPE          = PUBLIC                         00003500          
                ,BLOCKSTRUCTURE        = EXTERNAL                       00003600          
                ),                                                      00003700          
        streamfile                                                      00003800          
                (kind=pack,                                             00003900          
                  filestructure=stream,                                 00004000          
                  framesize=8,                                          00004100          
                  maxrecsize=1,                                         00004200          
                  newfile=true                                          00004300          
                  ),                                                    00004400          
        REM (KIND=REMOTE);                                              00004450          
 integer                                                                00004500          
        cnt,                                                            00004600          
        cmd_sz,                                                         00004700          
        io_size,                                                        00004800          
        TOTAL_CHARS_IN,                                                 00004900          
        user_sz,                                                        00004920          
        pass_sz;                                                        00004940          
 array                                                                  00005000          
        a_in[0:4097],                                                   00005100          
        command[0:100],                                                 00005110          
        user[0:16],                                                     00005120          
        pass[0:16],                                                     00005140          
        myzero[0:1];                                                    00005160          
 pointer                                                                00005200          
        pcmd,                                                           00005300          
        puser,                                                          00005320          
        ppass,                                                          00005340          
        pmyzero;                                                        00005360          
 boolean                                                                00005400          
        tracing;                                                        00005500          
                                                                        00005600          
 TRANSLATETABLE                                                         00005700          
        LOWERTOUPPER (EBCDIC TO EBCDIC,                                 00005800          
                      "abcdefghijklmnopqrstuvwxyz" TO                   00005900          
                      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"),                    00006000          
        NULLTOBLANK  (EBCDIC TO EBCDIC, 48"00" TO 48"40");              00006100          
                                                                        00006102          
$INCLUDE "UTILS/ALG"                                                    00006104          
                                                                        00006105          
PROCEDURE USAGE;                                                        00006110          
BEGIN                                                                   00006115          
    write(REM,<"A_REXEC usage :">);                                     00006120          
    write(REM,<"        A_REXEC ("""host user pass command""") ">);     00006125          
    write(REM,<"                host - destination host name">);        00006130          
    write(REM,<"                user - login id ">);                    00006135          
    write(REM,<"                pass - pasword  ">);                    00006140          
    write(REM,<"                command - command to execute">);        00006145          
    write(REM,<"        Note: many systems are case sensative">);       00006150          
    write(REM,<"  ">);                                                  00006155          
    write(REM,<"example: A_REXEC ("""UNIXBOX uuu ppp ls -l /etc""") ">);00006160          
    write(REM,<"  ">);                                                  00006162          
    write(REM,<"  ">);                                                  00006164          
    ABORT(" ");                                                         00006165          
END;                                                                    00006170          
                                                                        00006172          
PROCEDURE STOA;                                                         00006174          
begin                                                                   00006176          
% Conversion of streamfile to aligned180.                               00006178          
% If boolean(value.[0:1]) NO ascii to ebcdic conversion                 00006180          
% If boolean(value.[1:1]) DON'T write a record for every new-line.      00006182          
% If boolean(value.[2:1]) DON'T expand tab.                             00006184          
 file                                                                   00006186          
        alignedfile                                                     00006188          
            (kind=REMOTE, protection=save);                             00006190          
 integer                                                                00006192          
        i,                                                              00006194          
        splitcnt,       % # lines split                                 00006196          
        tab_sz,                                                         00006198          
        nl_cnt,                                                         00006200          
        alignedrecsz,                                                   00006202          
        alignedchars,                                                   00006204          
        inputchars;                                                     00006206          
 array                                                                  00006208          
        alignedrecord[0:0],                                             00006210          
        streamrecord[0:0];                                              00006212          
 pointer                                                                00006214          
        pa,                                                             00006216          
        ps;                                                             00006218          
 boolean                                                                00006220          
        nl_to_newrec,                                                   00006222          
        expanding_tab,                                                  00006224          
        translating;                                                    00006226          
                                                                        00006228          
 interrupt afp;                                                         00006230          
 begin                                                                  00006232          
 % Agence France Presse. Gives some infos.                              00006234          
  display(string(inputchars, *) !! " chars read from 'streamfile', "    00006236          
       !! string(alignedfile.nextrecord, *)                             00006238          
       !! " records written on 'alignedfile'");                         00006240          
  reset(myself.exceptionevent);                                         00006242          
 end;                                                                   00006244          
                                                                        00006246          
% Outer block                                                           00006248          
                                                                        00006250          
 OPEN(ALIGNEDFILE);                                                     00006252          
 IF (ALIGNEDFILE.KIND = VALUE(REMOTE)) THEN                             00006254          
   ALIGNEDRECSZ := ALIGNEDFILE(1).WIDTH                                 00006256          
 ELSE                                                                   00006258          
   alignedrecsz := alignedfile.maxrecsize;                              00006260          
 if alignedfile.framesize = 8 then                                      00006262          
     alignedchars := alignedrecsz                                       00006264          
 else                                                                   00006266          
     alignedchars := alignedrecsz * 6;                                  00006268          
 if (alignedchars = 0) then                                             00006270          
    begin                                                               00006272          
    alignedchars := 84;                                                 00006274          
    alignedfile.maxrecsize := 14;                                       00006276          
    alignedrecsz := 14;                                                 00006278          
    alignedfile.blocksize := 420;                                       00006280          
    SAY("Set 'alignedfile' to default alignement (84X30)");             00006282          
    end                                                                 00006284          
 else                                                                   00006286          
    SAY("Record size for 'alignedfile' set to " C                       00006288          
            alignedchars for * numeric C " chars");                     00006290          
                                                                        00006292          
 if translating := not boolean(myself.taskvalue.[0:1]) then             00006294          
    SAY("File 'streamfile' is ASCII, 'alignedfile' is EBCDIC")          00006296          
 else                                                                   00006298          
    SAY("File 'streamfile' and 'alignedfile' are EBCDIC");              00006300          
 if nl_to_newrec:= not boolean(myself.taskvalue.[1:1]) then             00006302          
    SAY("Will write a record on New-line");                             00006304          
 if expanding_tab:= not boolean(myself.taskvalue.[2:1]) then            00006306          
    SAY("Will expand Tab");                                             00006308          
 tab_sz := 8;                                                           00006310          
                                                                        00006312          
 % Resize w. room for NL & TAB                                          00006314          
 resize(alignedrecord, ((alignedchars+5+1+tab_sz) div 6), discard);     00006316          
 rabp(pa, alignedrecord);                                               00006318          
 rabp(ps, streamrecord);                                                00006320          
                                                                        00006322          
 attach afp to myself.exceptionevent;                                   00006324          
 enable afp;                                                            00006326          
                                                                        00006328          
 while not read(streamfile, 1, streamrecord) do                         00006330          
       begin                                                            00006332          
       inputchars := *+1;                                               00006334          
       if translating then                                              00006336          
          replace pa:pa by ps for 1 with asciitoebcdic                  00006338          
       else                                                             00006340          
          replace pa:pa by ps for 1;                                    00006342          
       if (expanding_tab and real(pa-1,1) = 5) then  % Got a tab        00006344          
          begin                                                         00006346          
          nl_cnt := *+1;                                                00006348          
          pa := *-1;                                                    00006350          
          replace pa:pa by " " for (tab_sz - (offset(pa) mod tab_sz));  00006352          
          end;                                                          00006354          
       if (nl_to_newrec and real(pa-1,1) = 37) then  % Got a NL         00006356          
          begin                                                         00006358          
          nl_cnt := *+1;                                                00006360          
          pa := *-1;                                                    00006362          
          replace pa by " ";                                            00006364          
          end                                                           00006366          
       else                                                             00006368          
          nl_cnt := 0;                                                  00006370          
       if (nl_cnt > 0)                                                  00006372          
       or (offset(pa) geq alignedchars) then                            00006374          
          begin                                                         00006376          
          if (nl_cnt = 1) and (offset(pa) = 0) then                     00006378          
          else                                                          00006380          
             write(alignedfile, alignedrecsz, alignedrecord);           00006382          
         if (offset(pa) geq alignedchars) then                          00006384          
            splitcnt := *+1;                                            00006386          
          rabp(pa, alignedrecord);                                      00006388          
          end;                                                          00006390          
       end;                                                             00006392          
 if offset(pa) > 0 then                                                 00006394          
    begin                                                               00006396          
    write(alignedfile, alignedrecsz, alignedrecord);                    00006398          
    SAY("WARNING: Number of chars read from 'streamfile' is not " C     00006400          
        "modulo 'alignedfile' record size!..");                         00006402          
    end;                                                                00006404          
 if splitcnt > 0 then                                                   00006406          
    SAY("WARNING: " C splitcnt for * numeric C " lines split");         00006408          
    SAY(inputchars for * numeric C " chars read from 'streamfile', "    00006410          
        C alignedfile.nextrecord for * numeric                          00006412          
        C " records written on 'alignedfile'");                         00006414          
 close(alignedfile, crunch);                                            00006416          
end;                                                                    00006418          
                                                                        00006420          
                                                                        00006422          
%------------ OUTER-BLOCK ----------------                              00006424          
                                                                        00006426          
%... string sent to the unix box must be null terminated, so            00006440          
%... initialize the arrays first                                        00006460          
                                                                        00006500          
 REPLACE USER BY 48"00" FOR 17;                                         00006520          
 REPLACE PASS BY 48"00" FOR 17;                                         00006540          
 REPLACE MYZERO BY 48"00" FOR 2;                                        00006560          
                                                                        00006580          
 if tracing := myself.taskvalue = 1 then                                00006600          
    begin                                                               00006700          
    say("Trace mode SET.");                                             00006800          
    display("Trace mode SET");                                          00006900          
    end;                                                                00007000          
                                                                        00007100          
%... Parameter checking                                                 00007150          
 PCMD := pointer(CMD);                                                  00007200          
 puser := pointer(user);                                                00007220          
 ppass := pointer(pass);                                                00007240          
 pmyzero := pointer(myzero);                                            00007260          
                                                                        00007280          
 cmd_sz := size(cmd)*6;                                                 00007300          
 XLATE(PCMD, cmd_sz, NULLTOBLANK);                                      00007400          
 cnt := SCANP(PCMD);                                                    00007500          
 if cnt = 0 then USAGE();                                               00007600          
                                                                        00007640          
 if tracing then                                                        00007700          
    say("Parameter: " C pcmd for min(100, remainingchars(pcmd)));       00007800          
%... Remote host is at PCMD for CNT                                     00007850          
 if tracing then                                                        00007900          
    begin                                                               00007920          
    write(REM,<"Remote host: ", A20>,pcmd for cnt);                     00007940          
    say("Remote host: " c pcmd for cnt);                                00008000          
    end;                                                                00008020          
                                                                        00008040          
%... put the remote host name into .YOURHOST                            00008060          
 replace pointer(A_IN) BY pcmd for cnt with lowertoupper, ".";          00008100          
 replace UCLIENTPORT.YOURHOST BY pointer(A_IN);                         00008200          
 pcmd := *+(cnt+1);     % Skip hostname                                 00008400          
                                                                        00008402          
%... get the USER name                                                  00008404          
 USER_SZ := SCANP(PCMD);    % scan in the USER                          00008406          
 if USER_SZ = 0 then USAGE();                                           00008408          
 REPLACE POINTER(USER) BY PCMD FOR USER_SZ ;                            00008410          
 if tracing then                                                        00008412          
    WRITE(REM,<"USER: ", A17>,PUSER for USER_SZ);                       00008414          
 XLATE(PUSER, USER_SZ, EBCDICTOASCII);                                  00008416          
 USER_SZ := USER_SZ + 1;    % add the null to the end of the string     00008418          
 pcmd := *+USER_SZ;     % Skip USER                                     00008420          
                                                                        00008422          
%... get the PASS                                                       00008424          
 PASS_SZ := SCANP(PCMD);    % scan in the PASS                          00008426          
 if PASS_SZ = 0 then USAGE();                                           00008428          
 REPLACE POINTER(PASS) BY PCMD FOR PASS_SZ ;                            00008430          
 if tracing then                                                        00008432          
    WRITE(REM,<"PASS: ", A17>,PPASS for PASS_SZ);                       00008434          
 XLATE(PPASS, PASS_SZ, EBCDICTOASCII);                                  00008436          
 PASS_SZ:= PASS_SZ + 1;     % add the null to the end of the string     00008438          
 pcmd := *+PASS_SZ;     % Skip PASS                                     00008440          
                                                                        00008442          
%... get the Command                                                    00008444          
 cnt := SCANP(PCMD);    % scan in the COMMAND                           00008446          
 if cnt = 0 then USAGE();                                               00008448          
 cmd_sz := * - offset(pcmd);                                            00008450          
                                                                        00008452          
%... Establish communication with the server                            00008454          
 replace pointer(A_IN) BY "512.";                                       00008456          
 replace UCLIENTPORT.YOURNAME BY pointer(A_IN);                         00008458          
 OPEN (UCLIENTPORT);                                                    00008460          
 if tracing then                                                        00009500          
    begin                                                               00009520          
    WRITE(REM,<"Port file open.">);                                     00009540          
    say("Port file open.");                                             00009600          
    end;                                                                00009650          
 WRITE(UCLIENTPORT, 1, MYZERO);      % Send a NULL                      00009700          
                                                                        00009750          
 WRITE(UCLIENTPORT, USER_SZ, PUSER);      % Send the USER CODE          00009800          
                                                                        00009850          
 WRITE(UCLIENTPORT, PASS_SZ, PPASS);      % Send the PASS CODE          00009900          
                                                                        00009950          
 if tracing then                                                        00010000          
    WRITE(REM,<"Remote command: ",A40>,pcmd for min(40, cmd_sz));       00010050          
 XLATE(PCMD, CMD_SZ, EBCDICTOASCII);                                    00010100          
 replace pointer(command) by PCMD for CMD_SZ, 48"00";                   00010150          
 WRITE(UCLIENTPORT, CMD_SZ+1, command[0]);      % Send the CMD          00010200          
                                                                        00010250          
 READ(UCLIENTPORT,1024,A_IN);        % Receive ACK from server          00010300          
 IO_SIZE := UCLIENTPORT.CURRENTRECORD;                                  00010350          
 if tracing then                                                        00010400          
    begin                                                               00010450          
    WRITE(REM,<"ACK received, ",I8," chars: ",A40>,                     00010500          
              io_size ,                                                 00010550          
              pointer(A_IN) FOR min(40, io_size));                      00010600          
    say("ACK received, " C io_size for * numeric c " chars: "           00010650          
          C pointer(A_IN) FOR min(80, io_size) with asciitoebcdic);     00010700          
    end;                                                                00010750          
                                                                        00010800          
%... Receive data                                                       00010850          
 WHILE NOT READ(UCLIENTPORT,1500, A_IN) DO                              00010900          
       BEGIN                                                            00010950          
       if IO_SIZE := UCLIENTPORT.CURRENTRECORD > 0 then                 00011000          
          BEGIN                                                         00011050          
          for cnt:= 0 step 1 while cnt < io_size do                     00011100          
              write(streamfile, 1, pointer(a_in)+cnt);                  00011150          
          if tracing then                                               00011200          
             begin                                                      00011250          
             xlate(pointer(a_in),io_size,ASCIITOEBCDIC);                00011300          
             WRITE(REM,<"Received, ",I8, " chars: ",A40>,               00011350          
                       io_size ,                                        00011400          
                       pointer(A_IN) FOR min(40, io_size));             00011450          
             say("Received, " C io_size for * numeric c " chars: "      00011500          
                     C pointer(A_IN) FOR min(80, io_size)               00011550          
                                                   with asciitoebcdic); 00011600          
             END;                                                       00011650          
          TOTAL_CHARS_IN := * + IO_SIZE;                                00011700          
          END;                                                          00011750          
       END;                                                             00011800          
 CLOSE(UCLIENTPORT);                                                    00011850          
 if tracing then                                                        00011950          
    begin                                                               00012000          
    WRITE(REM,<"Bytes received: ",I8>, total_chars_in );                00012050          
    say("Bytes received: " C total_chars_in for * numeric);             00012100          
    end;                                                                00012150          
                                                                        00012160          
 REWIND(STREAMFILE);                                                    00012170          
 STOA();                                                                00012180          
                                                                        00012200          
END OF WORK.                                                            00012400          
