/*                                                                      00001000          
    A_REXEC will create a remote execution capability for the A-Series  00002000          
                                                                        00003000          
    It is slightly different from the normal 'rexec' (at least that I   00004000          
    have seen in the PC and UNIX world). I have set it up so the command00005000          
    line requires the host, user login, password and the command.  The  00006000          
    'rexec' I have seen, prompt for the password (ie. it's not in the   00007000          
    command directly).  I wrote it this way to allow including the      00008000          
    A_REXEC command in an A-Series script or 'do deck'.                 00009000          
                                                                        00010000          
    What I know about 'rexecd' which is the remote execution server that00011000          
    runs on the UNIX platform. At least this is how it appears to work  00012000          
    on the unix boxes I am familiar with.                               00012500          
                                                                        00013000          
    rexecd is started by inetd (the internet daemon). To run rexecd     00014000          
    you need to have a line similar to the following in the             00015000          
    /etc/inetd.conf file:                                               00016000          
      exec  stream  tcp  nowait  root  /etc/rexecd rexecd               00017000          
                                                                        00018000          
    The reason I use YOURNAME=512, is to match the 'exec' line          00019000          
    in the /etc/services file:                                          00020000          
        exec  512/tcp   # remote execution, passwd required             00021000          
                                                                        00022000          
                                                                        00022100          
    Note: I have not actually tried running a_rexec with no password    00022200          
          because all of my unix accounts have a password.              00022300          
          So I am guessing that a NULL would be sent.                   00022400          
                                                                        00022500          
*/                                                                      00023000          
$MEMORY_MODEL tiny                                                      00024000          
#include <stdio.h>                                                      00025000          
#include <stdlib.h>                                                     00026000          
#include <string.h>                                                     00027000          
#include <errno.h>                                                      00028000          
                                                                        00029000          
void quit( int error );                                                 00030000          
char * xlate_to_ascii (char * str);                                     00031000          
char * xlate_to_ebcdic (char * str);                                    00032000          
                                                                        00033000          
FILE *rexec_port;                                                       00034000          
                                                                        00035000          
int main( int argc, char *argv[] )                                      00036000          
{                                                                       00037000          
const char filestuff [] =                                               00038000          
       "wb+,KIND=PORT,SERVICE=TCPNATIVESERVICE,MYNAME=512,"             00039000          
       "YOURNAME=512,EXTMODE=ASCII,"                                    00040000          
       "FRAMESIZE=8,NEWFILE=FALSE,BLOCKSTRUCTURE=EXTERNAL,"             00041000          
       "SECURITYTYPE=PUBLIC,MAXRECSIZE=1,YOURHOST=";                    00042000          
                                                                        00043000          
char filedef[260],                                                      00044000          
     host[60],                                                          00045000          
     user[17],                                                          00046000          
     pass[17],                                                          00047000          
     command[200];                                                      00048000          
                                                                        00049000          
char in;                                                                00050000          
                                                                        00051000          
int  i;                                                                 00052000          
                                                                        00053000          
                                                                        00054000          
  if (argc < 5)                                                         00055000          
    {                                                                   00056000          
    printf("A_REXEC usage :\n");                                        00057000          
    printf("    RUN A_REXEC (\"host user pass command\") \n");          00058000          
    printf("                host - destination host name\n");           00059000          
    printf("                user - login id \n");                       00060000          
    printf("                pass - password  \n");                      00061000          
    printf("                       for no password enter ! and a NULL");00062000          
    printf(" string will be sent\n");                                   00063000          
    printf("                command - command to execute\n");           00064000          
    printf("        Note: most unix systems are case sensitive\n");     00065000          
    printf("  \n");                                                     00066000          
    printf("example: run a_rexec (\"unixbox uuu ppp ls -l /etc\") \n"); 00067000          
    printf("\n\n");                                                     00068000          
    printf("To redirect the STDOUT file to a disk file: \n");           00069000          
    printf("example: run a_rexec (\"unixbox uuu ppp ls -l /etc\")");    00070000          
    printf(";file stdout(kind=disk,title=myout)\n\n");                  00071000          
    exit(0);                                                            00072000          
    }                                                                   00073000          
  strcpy (host, argv[1]);                                               00074000          
  strcpy (user, argv[2]);                                               00075000          
  strcpy (pass, argv[3]);                                               00076000          
  if ( strcmp(pass,"!") == 0 )                                          00077000          
    pass[0] = '/0';                                                     00078000          
  strcpy (command, argv[4]);                                            00079000          
  for (i=5;i<argc;i++)                                                  00080000          
    {                                                                   00081000          
    strcat (command, " ");                                              00082000          
    strcat (command, argv[i]);                                          00083000          
    }                                                                   00084000          
  strcpy (filedef,filestuff);                                           00085000          
  strcat (filedef,host);                                                00086000          
                                                                        00087000          
  if (!(rexec_port = fopen("rexecport",filedef)))                       00088000          
    {                                                                   00089000          
    printf("rexec: Could not open the rexec_port: %d : %s\n",           00090000          
        errno, strerror (errno));                                       00091000          
    printf("rexec: Possibly an unknown hostname\n");                    00092000          
    quit(1);                                                            00093000          
    }                                                                   00094000          
                                                                        00095000          
  fwrite("",1,1,rexec_port);                                            00096000          
  fwrite(xlate_to_ascii(user),                                          00097000          
         strlen(user)+1,    1, rexec_port);                             00098000          
  fwrite(xlate_to_ascii(pass),                                          00099000          
         strlen(pass)+1,    1, rexec_port);                             00100000          
  fwrite(xlate_to_ascii(command),                                       00101000          
         strlen(command)+1, 1, rexec_port);                             00102000          
                                                                        00103000          
  fflush(rexec_port);                                                   00104000          
                                                                        00105000          
  if (fread( &in, 1, 1, rexec_port) != 1)                               00106000          
    {                                                                   00107000          
    printf("rexec: bad response - %d %s\n",                             00108000          
        errno, strerror (errno));                                       00109000          
    quit(1);                                                            00110000          
    }                                                                   00111000          
  if (in != 0)                                                          00112000          
    {                                                                   00113000          
    printf("%s: ",host);                                                00114000          
    while (fread ( &in, 1, 1, rexec_port) == 1)                         00115000          
      printf("%s",xlate_to_ebcdic(&in));                                00116000          
    quit(1);                                                            00117000          
                                                                        00118000          
    }                                                                   00119000          
  else                                                                  00120000          
    {                                                                   00121000          
    while (fread ( &in, 1, 1, rexec_port) == 1)                         00122000          
      printf("%s",xlate_to_ebcdic(&in));                                00123000          
    }                                                                   00124000          
                                                                        00125000          
/* Close files  */                                                      00126000          
  fclose (rexec_port);                                                  00127000          
  exit( 0 );                                                            00128000          
}                                                                       00129000          
                                                                        00130000          
/* Handles errors */                                                    00131000          
void quit( int error )                                                  00132000          
  {                                                                     00133000          
  switch( error )                                                       00134000          
    {                                                                   00135000          
    case 1:                                                             00136000          
           printf("rexec: Error, command was not successful\n");        00137000          
           fclose (rexec_port);                                         00138000          
           break;                                                       00139000          
    }                                                                   00140000          
  exit( error );                                                        00141000          
  }                                                                     00142000          
/**********************************************************************/00143000000000006 
/* Translations between EBCDIC and ASCII characters. ******************/00144000000000006 
/**********************************************************************/00145000000000006 
                                                                        00146000000000006 
const char ebcdic_to_ascii[256] =                                       00147000000000006 
{                                                                       00148000000000006 
  0x00, 0x01, 0x02, 0x03, 0x9C, 0x09, 0x86, 0x7F,                       00149000000000006 
  0x97, 0x8D, 0x8E, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,                       00150000000000006 
  0x10, 0x11, 0x12, 0x13, 0x9D, 0x85, 0x08, 0x87,                       00151000000000006 
  0x18, 0x19, 0x92, 0x8F, 0x1C, 0x1D, 0x1E, 0x1F,                       00152000000000006 
  0x80, 0x81, 0x82, 0x83, 0x84, 0x0A, 0x17, 0x1B,                       00153000000000006 
  0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x05, 0x06, 0x07,                       00154000000000006 
  0x90, 0x91, 0x16, 0x93, 0x94, 0x95, 0x96, 0x04,                       00155000000000006 
  0x98, 0x99, 0x9A, 0x9B, 0x14, 0x15, 0x9E, 0x1A,                       00156000000000006 
  0x20, 0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6,                       00157000000000006 
  0xA7, 0xA8, 0x5B, 0x2E, 0x3C, 0x28, 0x2B, 0x21,                       00158000000000006 
  0x26, 0xA9, 0xAA, 0xAB, 0xAC, 0xAD, 0xAE, 0xAF,                       00159000000000006 
  0xB0, 0xB1, 0x5D, 0x24, 0x2A, 0x29, 0x3B, 0x5E,                       00160000000000006 
  0x2D, 0x2F, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7,                       00161000000000006 
  0xB8, 0xB9, 0x7C, 0x2C, 0x25, 0x5F, 0x3E, 0x3F,                       00162000000000006 
  0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF, 0xC0, 0xC1,                       00163000000000006 
  0xC2, 0x60, 0x3A, 0x23, 0x40, 0x27, 0x3D, 0x22,                       00164000000000006 
  0xC3, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,                       00165000000000006 
  0x68, 0x69, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9,                       00166000000000006 
  0xCA, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70,                       00167000000000006 
  0x71, 0x72, 0xCB, 0xCC, 0xCD, 0xCE, 0xCF, 0xD0,                       00168000000000006 
  0xD1, 0x7E, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,                       00169000000000006 
  0x79, 0x7A, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7,                       00170000000000006 
  0xD8, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD, 0xDE, 0xDF,                       00171000000000006 
  0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7,                       00172000000000006 
  0x7B, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,                       00173000000000006 
  0x48, 0x49, 0xE8, 0xE9, 0xEA, 0xEB, 0xEC, 0xED,                       00174000000000006 
  0x7D, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50,                       00175000000000006 
  0x51, 0x52, 0xEE, 0xEF, 0xF0, 0xF1, 0xF2, 0xF3,                       00176000000000006 
  0x5C, 0x9F, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,                       00177000000000006 
  0x59, 0x5A, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9,                       00178000000000006 
  0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,                       00179000000000006 
  0x38, 0x39, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF                        00180000000000006 
};                                                                      00181000000000006 
                                                                        00182000000000006 
const char ascii_to_ebcdic[256] =                                       00183000000000006 
{                                                                       00184000000000006 
  0x00, 0x01, 0x02, 0x03, 0x37, 0x2D, 0x2E, 0x2F,                       00185000000000006 
  0x16, 0x05, 0x25, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,                       00186000000000006 
  0x10, 0x11, 0x12, 0x13, 0x3C, 0x3D, 0x32, 0x26,                       00187000000000006 
  0x18, 0x19, 0x3F, 0x27, 0x1C, 0x1D, 0x1E, 0x1F,                       00188000000000006 
  0x40, 0x4F, 0x7F, 0x7B, 0x5B, 0x6C, 0x50, 0x7D,                       00189000000000006 
  0x4D, 0x5D, 0x5C, 0x4E, 0x6B, 0x60, 0x4B, 0x61,                       00190000000000006 
  0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7,                       00191000000000006 
  0xF8, 0xF9, 0x7A, 0x5E, 0x4C, 0x7E, 0x6E, 0x6F,                       00192000000000006 
  0x7C, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7,                       00193000000000006 
  0xC8, 0xC9, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6,                       00194000000000006 
  0xD7, 0xD8, 0xD9, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6,                       00195000000000006 
  0xE7, 0xE8, 0xE9, 0x4A, 0xE0, 0x5A, 0x5F, 0x6D,                       00196000000000006 
  0x79, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,                       00197000000000006 
  0x88, 0x89, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96,                       00198000000000006 
  0x97, 0x98, 0x99, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6,                       00199000000000006 
  0xA7, 0xA8, 0xA9, 0xC0, 0x6A, 0xD0, 0xA1, 0x07,                       00200000000000006 
  0x20, 0x21, 0x22, 0x23, 0x24, 0x15, 0x06, 0x17,                       00201000000000006 
  0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x09, 0x0A, 0x1B,                       00202000000000006 
  0x30, 0x31, 0x1A, 0x33, 0x34, 0x35, 0x36, 0x08,                       00203000000000006 
  0x38, 0x39, 0x3A, 0x3B, 0x04, 0x14, 0x3E, 0xE1,                       00204000000000006 
  0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,                       00205000000000006 
  0x49, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57,                       00206000000000006 
  0x58, 0x59, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,                       00207000000000006 
  0x68, 0x69, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75,                       00208000000000006 
  0x76, 0x77, 0x78, 0x80, 0x8A, 0x8B, 0x8C, 0x8D,                       00209000000000006 
  0x8E, 0x8F, 0x90, 0x9A, 0x9B, 0x9C, 0x9D, 0x9E,                       00210000000000006 
  0x9F, 0xA0, 0xAA, 0xAB, 0xAC, 0xAD, 0xAE, 0xAF,                       00211000000000006 
  0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7,                       00212000000000006 
  0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF,                       00213000000000006 
  0xCA, 0xCB, 0xCC, 0xCD, 0xCE, 0xCF, 0xDA, 0xDB,                       00214000000000006 
  0xDC, 0xDD, 0xDE, 0xDF, 0xEA, 0xEB, 0xEC, 0xED,                       00215000000000006 
  0xEE, 0xEF, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF                        00216000000000006 
};                                                                      00217000000000006 
                                                                        00218000000000006 
/********************************/                                      00219000000000006 
                                                                        00220000000000006 
char * xlate_to_ascii (char * str)                                      00221000000000006 
{                                                                       00222000000000006 
  char * s = str;                                                       00223000000000006 
                                                                        00224000000000006 
  while (*str)                                                          00225000000000006 
  {                                                                     00226000000000006 
    /* do increment separately to guarantee that it happens last */     00227000000000006 
    *str = ebcdic_to_ascii[*str];                                       00228000000000006 
    *str++;                                                             00229000000000006 
  }                                                                     00230000000000006 
                                                                        00231000000000006 
  return s;                                                             00232000000000006 
                                                                        00233000000000006 
}    /* xlate_to_ascii() */                                             00234000000000006 
                                                                        00235000000000006 
/*********************************/                                     00236000000000006 
                                                                        00237000000000006 
char * xlate_to_ebcdic (char * str)                                     00238000000000006 
{                                                                       00239000000000006 
  char * s = str;                                                       00240000000000006 
                                                                        00241000000000006 
  while (*str)                                                          00242000000000006 
  {                                                                     00243000000000006 
    /* do increment separately to guarantee that it happens last */     00244000000000006 
    *str = ascii_to_ebcdic[*str];                                       00245000000000006 
    *str++;                                                             00246000000000006 
  }                                                                     00247000000000006 
                                                                        00248000000000006 
  return s;                                                             00249000000000006 
                                                                        00250000000000006 
}    /* xlate_to_ebcdic() */                                            00251000000000006 
