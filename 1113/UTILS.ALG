% Various utilities, defines or procedures.                             00001000          
                                                                        00001100          
 Define                                                                 00001200          
  C             = ,#,                                                   00001300          
  RAB(A)        = replace pointer(a) by " " for size(a) words#,         00001320          
  RABP(P,A)     = replace p:=pointer(a) by " " for size(a) words#,      00001340          
  ABORT(S)      = begin display(s); myself.status := -1; end#,          00001390          
  XLATE(P,SZ,T) = replace p by p for (sz) with t#,                      00001395          
 Dummy_last_define = #;                                                 00001400          
                                                                        00001500          
% SCANP: Scans pointer P for a blank delimitted token.                  00001600          
%        Returns size of token or 0. P is updated.                      00001700          
 INTEGER PROCEDURE SCANP(P); POINTER P;                                 00001800          
 BEGIN                                                                  00001900          
  POINTER PP FOR P;                                                     00002000          
  INTEGER I1, I2;                                                       00002100          
  SCAN P:P FOR I2:I1:=REMAININGCHARS(P) WHILE EQL " ";                  00002200          
  IF I2 > 0 THEN                                                        00002300          
        BEGIN                                                           00002400          
        SCAN PP:P FOR I1:I2 WHILE NEQ " ";                              00002500          
        I2 := I2 - I1;                                                  00002600          
        END;                                                            00002700          
  SCANP := I2;                                                          00002800          
 END SCANP;                                                             00002900          
                                                                        00003000          
% Debug & trace                                                         00003100          
 file                                                                   00003200          
        reportfile(kind=printer);                                       00003300          
 array                                                                  00003400          
        reportarray[0:21];                                              00003500          
 pointer                                                                00003600          
        preportarray;                                                   00003700          
 define                                                                 00003800          
        say(t)  = begin                                                 00003900          
                  rabp(preportarray, reportarray);                      00004200          
                  replace preportarray:preportarray by t;               00004300          
                  write(reportfile,<a*>, offset(preportarray),          00004400          
                                         pointer(reportarray));         00004500          
                  end#;                                                 00004700          
                                                                        00004800          
