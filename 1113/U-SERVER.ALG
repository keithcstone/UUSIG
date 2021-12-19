 $ INSTALLATION 1                                                       00001000          
begin                                                                   00001100          
 $SET OMIT                                                              00001200          
  u_server: A Series server for Unix                                    00001300          
  The server, which may be launched by a supervisor at system init,     00001400          
  waits for queries on port 4097.                                       00001500          
                                                                        00001600          
  Queries are sent by a unix client, a_cli. a_cli needs two arguments,  00001700          
  the first one is the Hostname of the A-series running u_server, the   00001800          
  second argument is one query of the form:                             00001900          
        "DIR <A-series Directory Name>"                                 00002000          
        "SPO <Any spo command, except primitives>                       00002100          
                                                                        00002200          
  The server reads the query on a port subfile, sends an "ACK" and      00002300          
  process the query.                                                    00002400          
  Commands of type "DIR" are processed using GETSTATUS calls.           00002500          
  "SPO" commands are processed using DCKEYIN calls.                     00002600          
  The output of these calls are "beautified" and sent to the port       00002700          
  subfile that the command originated.                                  00002800          
                                                                        00002820          
  To stop the server: HI 99.                                            00002840          
 $RESET OMIT                                                            00002900          
%$SET ATTRIBS TIMESDESC PARSEINPUT                                      00003000          
 $INCLUDE "S/EXP/UTILS"                                                 00003100          
 define                                                                 00003200          
        temporisateur           = 60#,                                  00003300          
        max_sub_files           = 9#,                                   00003400          
        max_rec_size            = 1920#,                                00003500          
        my_port_num             = "4097."#,                             00003600          
        nn(x)                   = (x) for * numeric#,                   00003700          
        %-- Subfiles status                                             00003800          
        availv                  = 0#,                                   00003900          
        doingspov               = 11#,                                  00004000          
        doingdirv               = 12#,                                  00004100          
        needclosev              = 253#,                                 00004200          
        timewaitv               = 254#,                                 00004300          
        %--                                                             00004400          
        COR(A,B)        = (IF (A) THEN TRUE ELSE (B)) #,                00004500          
        CAND(A,B)       = (IF (A) THEN (B)  ELSE FALSE)#,               00004600          
        %-- T = TIME(7)                                                 00004700          
   AAAAF           = [47:12] #  ,AAAA(T)       = T.AAAAF #              00004800          
  ,MMF             = [35:06] #  ,MM(T)         = T.MMF #                00004900          
  ,JJF             = [29:06] #  ,JJ(T)         = T.JJF #                00005000          
  ,HHF             = [23:06] #  ,HH(T)         = T.HHF #                00005100          
  ,MNF             = [17:06] #  ,MN(T)         = T.MNF #                00005200          
  ,SSF             = [11:06] #  ,SS(T)         = T.SSF #                00005300          
  ,JSF             = [05:06] #  ,JS(T)         = T.JSF #                00005400          
                                ,AA(T)         = (AAAA(T) MOD 100) #    00005500          
  ,T7DATE7(T)      = JJ(T) FOR 2 DIGITS C CASE         %  14JUL89 (7 @) 00005600          
                     MM(T) OF (80"ERR",80"Jan",80"Feb",80"Mar",80"Apr", 00005700          
                               80"May",80"Jun",80"Jul",80"Aug",         00005800          
                               80"Sep",80"Oct",80"Nov",80"Dec") FOR 3 C 00005900          
                     AA(T) FOR 2 DIGITS #                               00006000          
  ,T7HMS(T)        =                    % HH:MN:SS      (8 @)           00006100          
                     HH(T) FOR 2 DIGITS C ":" C                         00006200          
                     MN(T) FOR 2 DIGITS C ":" C                         00006300          
                     SS(T) FOR 2 DIGITS #,                              00006400          
        %                                                               00006500          
        tsay(txt)       = say(t7date7(time(7)) % 14Jul89 12:34:56 %17@  00006600          
                              c " " c t7hms(time(7)) c " " c txt)#,     00006700          
        xsay(txt)       = begin                                         00006800          
                          if tracing then                               00006900          
                             tsay(txt);                                 00007000          
                          end#,                                         00007100          
 dummy_last_test_port_defines=#;                                        00007200          
                                                                        00007300          
 label                                                                  00007400          
        cont;                                                           00007500          
 event                                                                  00007600          
        localevent,                                                     00007700          
        trace_protect;                                                  00007800          
 array                                                                  00007900          
        in_buf[0:max_sub_files, 0:((max_rec_size+5)div 6)],             00008000          
        out_buf[0:max_sub_files, 0:((max_rec_size+5)div 6)],            00008100          
        work_buf[0:max_sub_files, 0:0],                                 00008200          
        cmd_buf[0:max_sub_files, 0:14],                                 00008300          
        si[0:max_sub_files],                                            00008400          
        ts[0:max_sub_files];                                            00008500          
 boolean                                                                00008700          
        tracing,                                                        00008800          
        done;                                                           00008900          
 integer                                                                00009000          
        io_size,                                                        00009100          
        subf;                                                           00009200          
 TRANSLATETABLE LOWERTOUPPER (EBCDIC TO EBCDIC,                         00009300          
  "abcdefghijklmnopqrstuvwxyz" TO "ABCDEFGHIJKLMNOPQRSTUVWXYZ");        00009400          
                                                                        00009500          
  FILE  USERVER                                                         00009600          
        ( KIND                  = PORT                                  00009700          
         ,FILENAME              = "USERVERPORT."                        00009800          
         ,MYNAME                = my_port_num                           00009900          
         ,PASSIVEOPEN           = TRUE                                  00010000          
         ,SERVICE               = TCPIPNATIVESERVICE                    00010100          
         ,MAXRECSIZE            = max_rec_size                          00010200          
         ,FRAMESIZE             = 8                                     00010300          
         ,SECURITYTYPE          = PUBLIC                                00010400          
         ,BLOCKSTRUCTURE        = EXTERNAL                              00010500          
         ,maxsubfiles           = max_sub_files                         00010600          
        );                                                              00010700          
%--                                                                     00010800          
 STRING PROCEDURE ATTRIBVALUE(ATYPE,AVALUE,ANUM);                       00010900          
  VALUE ATYPE, AVALUE, ANUM; INTEGER ATYPE, AVALUE, ANUM;               00011000          
 BEGIN                                                                  00011100          
  REAL R; ARRAY A[0:11]; POINTER PA;                                    00011200          
  PA := POINTER(A);                                                     00011300          
  IF BOOLEAN(R:= ATTRIBSEARCHER(PA, AVALUE,                             00011400          
             0 & ANUM [19:8] & ATYPE [27:3], 7, PA)) THEN               00011500          
     ATTRIBVALUE := STRING(AVALUE,*)                                    00011600          
  ELSE                                                                  00011700          
     ATTRIBVALUE := STRING(POINTER(A),R.[47:47]);                       00011800          
 END ATTRIBVALUE;                                                       00011900          
 DEFINE                                                                 00012000          
  FILEATTRIB(AVALUE,ANUM) = ATTRIBVALUE(1,AVALUE,ANUM)#,                00012100          
  TASKATTRIB(AVALUE,ANUM) = ATTRIBVALUE(2,AVALUE,ANUM)#;                00012200          
%---                                                                    00012300          
 real procedure givedir_init(subf, p, io_size);                         00012400          
        value subf, p, io_size;                                         00012500          
        integer subf, io_size;                                          00012600          
        pointer p;                                                      00012700          
 begin                                                                  00012800          
  label                                                                 00012900          
        xit;                                                            00013000          
  define                                                                00013100          
        return(x)       = begin givedir_init := (x); go xit; end#;      00013200          
  real                                                                  00013300          
        type,                                                           00013400          
        subclass,                                                       00013500          
        mask;                                                           00013600          
  pointer                                                               00013700          
        pdisp,                                                          00013800          
        pstd;                                                           00013900          
  array reference                                                       00014000          
        ar[0];                                                          00014100          
                                                                        00014200          
  type := 0 & 3 [07:08]  & 1 [15:08] & 1 [40:01];                       00014300          
  mask := 0 & 1 [00:01]; subclass := 0;                                 00014400          
  ar := work_buf[subf,*];                                               00014500          
  resize(ar, 320, discard);                                             00014600          
  ar[0] := 20; ar[1] := 20;                                             00014700          
  pstd := pointer(ar[20]);                                              00014800          
  replace p+io_size by ".";                                             00014900          
  if displaytostandard(p, pstd) then                                    00015000          
     return(needclosev);       % Err                                    00015100          
  si[subf] := type;                                                     00015200          
  return(doingdirv);                                                    00015300          
xit:                                                                    00015400          
end givedir_init;                                                       00015500          
%---                                                                    00015600          
 real procedure givedir_cont(subf);                                     00015700          
        value subf;                                                     00015800          
        integer subf;                                                   00015900          
 begin                                                                  00016000          
  label                                                                 00016100          
        xit;                                                            00016200          
  define                                                                00016300          
        return(x)       = begin givedir_cont := (x); go xit; end#;      00016400          
  real                                                                  00016500          
        type,                                                           00016600          
        subclass,                                                       00016700          
        mask;                                                           00016800          
  integer                                                               00016900          
        i;                                                              00017000          
  pointer                                                               00017100          
        pp,                                                             00017200          
        pdisp,                                                          00017300          
        pstd;                                                           00017400          
  array reference                                                       00017500          
        ar[0];                                                          00017600          
                                                                        00017700          
  type := si[subf];                                                     00017800          
  mask := 0 & 1 [00:01]; subclass := 0;                                 00017900          
  ar := work_buf[subf,*];                                               00018000          
  ar[0] := 20;                                                          00018100          
  if getstatus(type, subclass, mask, ar) then                           00018200          
     return(needclosev);                                                00018300          
  for i := 2 step 1 until (ar[0].[19:20] - 1) do                        00018400          
      begin                                                             00018500          
      pstd := pointer(ar)+ar[i].[32:17];                                00018600          
      pp := pdisp := pointer(out_buf[subf,*]);                          00018700          
      standardtodisplay(pstd, pdisp);                                   00018800          
      xsay(nn(subf) c "- Sending >" c                                   00018900          
           pp for min(40, (offset(pdisp)-1)) c "<");                    00019000          
      xlate(pp, (offset(pdisp)-1), ebcdictoascii);                      00019100          
      if write(userver[subfile subf], <a*, 4"0A">, (offset(pdisp)-1),   00019200          
                pointer(out_buf[subf,*]) ) then                         00019300          
         begin                                                          00019400          
         xsay(nn(subf) c "- Write error @ " c nn(linenumber));          00019500          
         return(needclosev);       % Err                                00019600          
         end;                                                           00019700          
     end;                                                               00019800          
  if ar[0].[47:01] = 0 then                                             00019900          
     return(needclosev);                                                00020000          
  type := type & 4 [15:08]; ar[0] := 20;                                00020100          
  si[subf] := type;                                                     00020200          
  return(doingdirv);                                                    00020300          
xit:                                                                    00020400          
end givedir_cont;                                                       00020500          
%---                                                                    00020600          
 procedure dckey_init(subf, p, io_size);                                00020700          
        value subf, p, io_size;                                         00020800          
        integer subf, io_size;                                          00020900          
        pointer p;                                                      00021000          
 begin                                                                  00021100          
   array reference                                                      00021200          
        ar[0];                                                          00021300          
                                                                        00021400          
   si[subf] := 0;                                                       00021500          
   ar := work_buf[subf,*];                                              00021600          
   resize(ar, 10000, discard);                                          00021700          
   replace p+io_size by 48"00";                                         00021800          
   dckeyin(p, ar);                                                      00021900          
 end dckey_init;                                                        00022000          
%---                                                                    00022100          
 real procedure dckey_cont(subf);                                       00022200          
        value subf;                                                     00022300          
        integer subf;                                                   00022400          
 begin                                                                  00022500          
  truthset                                                              00022600          
        stoppers(48"00030D");                                           00022700          
  label                                                                 00022800          
        xit;                                                            00022900          
  define                                                                00023000          
        return(x)       = begin dckey_cont := (x); go xit; end#;        00023100          
  pointer                                                               00023200          
        po,                                                             00023300          
        pp,                                                             00023400          
        pw;                                                             00023500          
                                                                        00023600          
  pw := pointer(work_buf[subf,*])+si[subf];                             00023700          
  po := pp := pointer(out_buf[subf,*]);                                 00023800          
  replace po:po by pw:pw until in stoppers;                             00023900          
  xsay(nn(subf) c "- Sending >" c                                       00024000          
        pp for min(40, offset(po)) c "<");                              00024100          
  xlate(pp, offset(po), ebcdictoascii);                                 00024200          
  if write(userver[subfile subf],<a*,4"0A">, offset(po), pp) then       00024300          
     begin                                                              00024400          
     xsay(nn(subf) c "Write error @" c nn(linenumber));                 00024500          
     return(needclosev);                                                00024600          
     end;                                                               00024700          
  while pw in stoppers do                                               00024800          
     if pw = 48"03" then                                                00024900          
        return(needclosev)                                              00025000          
     else                                                               00025100          
        pw := *+1;                                                      00025200          
  si[subf] := offset(pw);                                               00025300          
  return(doingspov);                                                    00025400          
xit:                                                                    00025500          
 end dckey_cont;                                                        00025600          
%---                                                                    00025700          
 real procedure dialoginit(subf, io_size);                              00025800          
        value subf, io_size;                                            00025900          
        integer subf, io_size;                                          00026000          
 begin                                                                  00026100          
  define                                                                00026200          
        return(r)       = begin dialoginit := (r); go xit; end#;        00026300          
  label                                                                 00026400          
        xit;                                                            00026500          
  array reference                                                       00026600          
        port_input[0];                                                  00026700          
  pointer                                                               00026800          
        po,                                                             00026900          
        pp,                                                             00027000          
        pc,                                                             00027100          
        p;                                                              00027200          
  real                                                                  00027300          
        r;                                                              00027400          
  port_input := in_buf[subf,*];                                         00027500          
  if read(userver[SUBFILE SUBF],io_size,port_input) then                00027600          
     begin                                                              00027700          
     xsay(nn(subf) c "- Read error on subfile");                        00027800          
     return(needclosev);                                                00027900          
     end;                                                               00028000          
  p := pointer(port_input); r := 0;                                     00028100          
  xlate(p, io_size, asciitoebcdic);                                     00028200          
  xlate(p, io_size, lowertoupper);                                      00028300          
  replace p+io_size by " ";                                             00028350          
  xsay(nn(subf) c "- " C nn(io_size) C " chars from " c                 00028400          
           userver(subf).yourhost c                                     00028500          
            ": >" c p for min(50,io_size) c "<");                       00028600          
  % Send ACK                                                            00028700          
  if write(userver[SUBFILE SUBF],<4"41434B">) then                      00028800          
     begin                                                              00028900          
     xsay(nn(subf) c "- Write error sending ACK");                      00029000          
     return(needclosev);                                                00029100          
     end;                                                               00029200          
  % Record Cmd                                                          00029300          
  replace pc:pointer(cmd_buf[subf,3]) by " ", nn(subf), "- ",           00029400          
        t7date7(time(7)), " ", t7hms(time(7)), " ",                     00029500          
        userver(subf).yourhost, " ";                                    00029600          
  replace pc:pc by p for min((remainingchars(pc)-1), io_size), 48"00";  00029700          
  % Parse command                                                       00029800          
  r := scanp(p);                                                        00029900          
  if cand(r = 3, p = "SPO" for 3) then                                  00030000          
     begin                                                              00030100          
     p := p+4;                                                          00030200          
     r := scanp(p);     % Jump to ODT command                           00030300          
     dckey_init(subf, p, (io_size - offset(p)));                        00030400          
     return(doingspov);                                                 00030500          
     end;                                                               00030600          
  if cand(r = 3, p = "DIR" for 3) then                                  00030700          
     begin                                                              00030800          
     p := p+4;                                                          00030900          
     r := scanp(p);     % Jump to directory name                        00031000          
     return(givedir_init(subf, p, (io_size - offset(p))));              00031100          
     end;                                                               00031200          
%... ERR                                                                00031300          
  if r = 0 then                                                         00031320          
     xsay(nn(subf) c "- CMD Expected")                                  00031340          
  else                                                                  00031360          
     xsay(nn(subf) c "- Bad CMD: " c p for min(24,r));                  00031400          
  % Send error message                                                  00031500          
  po := pp := pointer(out_buf[subf,*]);                                 00031600          
  replace po:po by "U_SERVER: SPO OR DIR EXPECTED";                     00031700          
  if r > 0 then                                                         00031800          
     replace po:po by " INSTEAD OF ", p for min(r,24);                  00031900          
  xlate(pp, offset(po), ebcdictoascii);                                 00032000          
  if write(userver[subfile subf],<a*,4"0A">, offset(po), pp) then       00032100          
     xsay(nn(subf) c "Write error @" c nn(linenumber));                 00032300          
  return(needclosev);                                                   00032400          
xit:                                                                    00032500          
 end dialoginit;                                                        00032600          
%---                                                                    00032700          
 boolean procedure dialogcont;                                          00032800          
 begin                                                                  00032900          
  boolean                                                               00033000          
        needcont;                                                       00033100          
  integer                                                               00033200          
        inx;                                                            00033300          
                                                                        00033400          
  for inx := 1 step 1 while inx leq max_sub_files do                    00033500          
        begin                                                           00033600          
        case ts[inx] of                                                 00033700          
                begin                                                   00033800          
        availv:                                                         00033900          
        timewaitv:                                                      00034000          
                ;       % Nothing                                       00034100          
        needclosev:                                                     00034200          
                xsay(nn(inx) c "- Closing subf");                       00034300          
                close(userver[subfile inx], dontwait,                   00034400          
                                closedisposition=orderly);              00034500          
                ts[inx] := timewaitv;                                   00034600          
        doingspov:                                                      00034700          
                ts[inx] := dckey_cont(inx);                             00034800          
                needcont := true;                                       00034900          
        doingdirv:                                                      00035000          
                ts[inx] := givedir_cont(inx);                           00035100          
                needcont := true;                                       00035200          
        else:                                                           00035300          
                xsay(nn(inx) c "- Status = " c nn(ts[inx]));            00035400          
                end;                                                    00035500          
        end;                                                            00035600          
  dialogcont := needcont;                                               00035700          
 end dialogcont;                                                        00035800          
                                                                        00035900          
%--- outer block                                                        00036000          
 tracing := myself.taskvalue=1;                                         00036100          
 xsay("Start");                                                         00036200          
 replace userver(0).yourname by ".";                                    00036300          
 replace userver(0).yourhost by ".";                                    00036400          
 replace userver(0).yourdomainname by ".";                              00036500          
 replace userver(0).youripaddress by ".";                               00036600          
 for subf := 1 step 1 while subf leq max_sub_files do                   00036700          
     replace pointer(cmd_buf[subf,0]) by " " for 18, 48"00";            00036800          
 awaitopen(userver[subfile 0], dontwait);                               00036900          
 DO BEGIN                                                               00037000          
cont:                                                                   00037100          
    CASE WAIT ((TEMPORISATEUR)                                          00037200          
               ,USERVER.CHANGEEVENT                                     00037300          
               ,MYSELF.EXCEPTIONEVENT                                   00037400          
               ,USERVER.INPUTEVENT                                      00037500          
               ,localevent                                              00037600          
   ) of BEGIN                                                           00037700          
 1: xsay("Tempo");                                                      00037800          
   % for subf := 1 step 1 while subf leq max_sub_files do               00037900          
   %     tsay("ts[" c nn(subf) c "] =" c nn(ts[subf]));                 00038000          
 2:% xsay("Changeevent");                                               00038100          
    WHILE SUBF := userver.CHANGEDSUBFILE > 0 DO                         00038200          
          begin                                                         00038300          
          % Record subfile status                                       00038400          
          replace pointer(cmd_buf[subf,0]) by " " for 18;               00038500          
          replace pointer(cmd_buf[subf,0]) by                           00038600          
              fileattrib(userver(subf).filestate, value(filestate));    00038700          
          % Check state                                                 00038800          
          case userver(subf).filestate of                               00038900          
               begin                                                    00039000          
    value(closed):                                                      00039100          
        xsay("Changeevent # " c nn(subf) c " CLOSED -> awaitopen");     00039200          
        replace userver(subf).yourname by ".";                          00039300          
        replace userver(subf).yourhost by ".";                          00039400          
        replace userver(subf).yourdomainname by ".";                    00039500          
        replace userver(subf).youripaddress by ".";                     00039600          
        awaitopen(userver[subfile subf], dontwait);                     00039700          
    value(awaitingoffer):                                               00039800          
        xsay("Changeevent # " c nn(subf) c " AWAITINGOFFER -> avl");    00039900          
        resize(work_buf[subf,*], 0, discard);                           00040000          
        ts[subf] := availv;                                             00040100          
    value(deactivated):                                                 00040200          
        xsay("Changeevent # " c nn(subf) c " DEACTIVATED -> close");    00040300          
        close(userver[subfile subf]);                                   00040400          
    else:                                                               00040500          
        xsay("Changeevent # " c nn(subf) c " " c                        00040600          
              fileattrib(userver(subf).filestate, value(filestate)) c   00040700          
              " (" c nn(userver(subf).filestate) c ")");                00040800          
               end case;                                                00040900          
         end while;                                                     00041000          
 4: xsay("Inputevent");                                                 00041100          
    for subf := 1 step 1 while subf leq max_sub_files do                00041200          
        if io_size := userver(subf).framesizecensus > 0 then            00041300          
           if ts[subf] neq availv then                                  00041400          
              begin                                                     00041500          
              % Err: Subfile is not available                           00041600          
              xsay("Subfile # " c nn(subf) c " is NOT available");      00041700          
              end                                                       00041800          
           else                                                         00041900          
              begin                                                     00042000          
              ts[subf] := dialoginit(subf, io_size);                    00042100          
              xsay("Causing localevent for subf # " c nn(subf));        00042200          
              cause(localevent);                                        00042300          
              go cont;                                                  00042400          
              end;                                                      00042500          
 3:%xsay("Exceptionevent");                                             00042600          
    if myself.taskvalue = 99 then                                       00042700          
       done := true                                                     00042800          
    else                                                                00042900          
       begin                                                            00043000          
       reset(myself.exceptionevent);                                    00043100          
       for subf := 1 step 1 while subf leq max_sub_files do             00043200          
           display(pointer(cmd_buf[subf,*]));                           00043300          
       end;                                                             00043400          
 5:%xsay("Localevent");                                                 00043500          
    reset(localevent);                                                  00043600          
    if dialogcont then                                                  00043700          
        cause(localevent);                                              00043800          
        END case;                                                       00043900          
    END UNTIL DONE;                                                     00044000          
END.                                                                    00044100          
