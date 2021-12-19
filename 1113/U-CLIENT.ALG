% u_client : A Series Unix Client                                       00001000          
% Syntax:                                                               00001100          
%    RUN u_client("<Remote host> <Remote command>")                     00001200          
%    e.g. RUN u_client("UNIXBOX /bin/ls -l /etc/passwd")                00001300          
%                                                                       00001400          
% U_client opens a port file with MYNAME = "4096." and YOURHOST eql to  00001500          
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
$INCLUDE "S/EXP/UTILS"                                                  00002600          
 file                                                                   00002700          
        uclientport                                                     00002800          
                (KIND                  = PORT                           00002900          
                ,FILENAME              = "UCLIENTPORT."                 00003000          
                ,MYNAME                = "4096."                        00003100          
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
                  newfile=true,                                         00004300          
                  protection=save);                                     00004400          
 integer                                                                00004500          
        cnt,                                                            00004600          
        cmd_sz,                                                         00004700          
        io_size,                                                        00004800          
        TOTAL_CHARS_IN;                                                 00004900          
 array                                                                  00005000          
        a_in[0:4097];                                                   00005100          
 pointer                                                                00005200          
        pcmd;                                                           00005300          
 boolean                                                                00005400          
        tracing;                                                        00005500          
                                                                        00005600          
 TRANSLATETABLE                                                         00005700          
        LOWERTOUPPER (EBCDIC TO EBCDIC,                                 00005800          
                      "abcdefghijklmnopqrstuvwxyz" TO                   00005900          
                      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"),                    00006000          
        NULLTOBLANK  (EBCDIC TO EBCDIC, 48"00" TO 48"40");              00006100          
                                                                        00006200          
                                                                        00006300          
%------------ OUTER-BLOCK ----------------                              00006400          
                                                                        00006500          
 if tracing := myself.taskvalue = 1 then                                00006600          
    begin                                                               00006700          
    say("Trace mode SET.");                                             00006800          
    display("Trace mode SET");                                          00006900          
    end;                                                                00007000          
                                                                        00007100          
%... Parameter checking                                                 00007150          
 PCMD := pointer(CMD);                                                  00007200          
 cmd_sz := size(cmd)*6;                                                 00007300          
 XLATE(PCMD, cmd_sz, NULLTOBLANK);                                      00007400          
 cnt := SCANP(PCMD);                                                    00007500          
 if cnt = 0 then abort("Empty parameter");                              00007600          
 if tracing then                                                        00007700          
    say("Parameter: " C pcmd for min(100, remainingchars(pcmd)));       00007800          
%... Remote host is at PCMD for CNT                                     00007850          
 if tracing then                                                        00007900          
    say("Remote host: " c pcmd for cnt);                                00008000          
 replace pointer(A_IN) BY pcmd for cnt with lowertoupper, ".";          00008100          
 replace UCLIENTPORT.YOURHOST BY pointer(A_IN);                         00008200          
                                                                        00008300          
 pcmd := *+(cnt+1);     % Skip hostname                                 00008400          
 cnt := SCANP(PCMD);    % Jump to beginning of cmd                      00008500          
 if cnt = 0 then abort("Empty cmd");                                    00008600          
 cmd_sz := * - offset(pcmd);                                            00008700          
 if tracing then                                                        00008800          
    say("Remote command: " C pcmd for min(100, cmd_sz));                00008900          
 XLATE(PCMD, CMD_SZ, EBCDICTOASCII);                                    00009000          
                                                                        00009100          
%... Establish communication with the server                            00009150          
 replace pointer(A_IN) BY "4096.";                                      00009200          
 replace UCLIENTPORT.YOURNAME BY pointer(A_IN);                         00009300          
 OPEN (UCLIENTPORT);                                                    00009400          
 if tracing then                                                        00009500          
    say("Port file open.");                                             00009600          
 WRITE(UCLIENTPORT, cmd_sz, PCMD);      % Send the cmd                  00009700          
 if tracing then                                                        00009800          
    say("Command sent.");                                               00009900          
 READ(UCLIENTPORT,1024,A_IN);        % Receive ACK from server          00010000          
 IO_SIZE := UCLIENTPORT.CURRENTRECORD;                                  00010100          
 if tracing then                                                        00010200          
    say("ACK received, " C io_size for * numeric c " chars: "           00010300          
          C pointer(A_IN) FOR min(80, io_size) with asciitoebcdic);     00010400          
                                                                        00010500          
%... Receive data                                                       00010600          
 WHILE NOT READ(UCLIENTPORT,1500, A_IN) DO                              00010700          
       BEGIN                                                            00010800          
       if IO_SIZE := UCLIENTPORT.CURRENTRECORD > 0 then                 00010900          
          BEGIN                                                         00011000          
          for cnt:= 0 step 1 while cnt < io_size do                     00011100          
              write(streamfile, 1, pointer(a_in)+cnt);                  00011200          
          if tracing then                                               00011300          
             say("Received, " C io_size for * numeric c " chars: "      00011400          
                     C pointer(A_IN) FOR min(80, io_size)               00011500          
                                                   with asciitoebcdic); 00011600          
          TOTAL_CHARS_IN := * + IO_SIZE;                                00011700          
          END;                                                          00011800          
       END;                                                             00011900          
 CLOSE(UCLIENTPORT);                                                    00012000          
 CLOSE(streamfile, crunch);                                             00012100          
 if tracing then                                                        00012200          
    say("Bytes received: " C total_chars_in for * numeric);             00012300          
END OF WORK.                                                            00012400          
