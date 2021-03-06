# Program Index By Letter: F

[A](A-INDEX.md) [B](B-INDEX.md)
[C](C-INDEX.md) [D](D-INDEX.md)
[E](E-INDEX.md) [G](G-INDEX.md)
[H](H-INDEX.md) [I](I-INDEX.md)
[J](J-INDEX.md) [K](K-INDEX.md)
[L](L-INDEX.md) [M](M-INDEX.md)
[N](N-INDEX.md) [O](O-INDEX.md)
[P](P-INDEX.md) [Q](Q-INDEX.md)
[R](R-INDEX.md) [S](S-INDEX.md)
[T](T-INDEX.md) [U](U-INDEX.md)
[V](V-INDEX.md) [W](W-INDEX.md)
[X](X-INDEX.md) [Y](Y-INDEX.md)
[Z](Z-INDEX.md)

- - -
**FAC** ([1051](1051/1051.md), November 1976![](IMAGES/OS2200.JPG)) - See ERROR above. (ASM,ABS)


**FAC** ([1051](1065/1065.md), June 1988![](IMAGES/OS2200.JPG)) - This program decodes facility status bits
into an English message. It is similar to the UOM FAC processor, but
is intended to have more readable output. Documentation included.
(ELT, REL, ABS)


**FAC** ([1051](1081/1081.md), December 1991![](IMAGES/OS2200.JPG)) - Utility to interpret a facility octal status
code. Documentation included. (MSM, ABS)


**FAKE-BACKUP** ([1051](1081/1081.md), July
1992![](IMAGES/OS2200.JPG)) - Used to modify the backup date, time and reel
of a file. This can be useful in diagnosing/correcting system
programming problems. (ELT)


**FANG** ([1085](1085/1085.md), January 1982![](IMAGES/OS2200.JPG)) - FANG is a general purpose file utility
program. FANG functions as an interpreter of commands which specify
operations to be performed upon files named in the source language.
Various commands allow files to be dumped, positioned, written,
compared and edited. Other commands permit manipulation of classes of
elements in program files and data files in SDF format. FANG operates
upon all types of files provided by the EXEC-8 system. Tapes are
handled at the block level, while Fastrand and word addressable files
may be accessed in terms of simulated tape blocks or random-accessed
by specifying a sector or word address. Fang utilizes overlapped
input/output operations and concurrency of command execution to
efficiently use the facilities of the system. This mode of operation
is transparent to the user, to whom it appears that commands are
executed sequentially as entered. Documentation included. (REL, ABS)


**FCSSINIT** ([1051](1065/1065.md), April 1986![](IMAGES/OS2200.JPG)) - FTN batch connect program to fill any TIP
file with zeros. (FTN)


**FCYCLE** ([1051](1067/1067.md), December
1981![](IMAGES/OS2200.JPG)) - @FCYCLE is a program that reorders reel
numbers in a multi-reel tape file. Documentation included. (MSM,
REL,ABS)


**FE** ([1084](1084/1084.md), August 1990![](IMAGES/OS2200.JPG)) - Colin Marshall's full-screen file editor.Use
the HELP command. Processor call is:
@FE[,options]file-name.[,initial-sector], where the options can be R
for read-only or X to indicate the exclusive use is NOT desired.
(MSM, ABS)


**FED** ([1051](1081/1081.md), October 1990![](IMAGES/OS2200.JPG)) - IPF Preprocessor. (MSM)


**FILE MANAGER** ([1074](1074/1074.md), January
1990![](IMAGES/OS2200.JPG)) - MAPPER based EXEC file management system
which consolidates all EXEC files, based upon qualifiers,that users
are responsible for into two rids: one for cataloged files, one for
archived files. User can monitor existence of files, delete, sym,
restore,or archive files with system. Uses MFD for identifying files
and FAS for file archival. (RIDs)


**FILECHG 1R8** ([1037](1037/1037.md), April
1980![](IMAGES/OS2200.JPG)) - Program to change project, account number,
and certain bits for a given file. Documentation included. (ASM
1979,1980; ABS 1979)


**FILEDIT** ([1051](1067/1067.md), February
1989![](IMAGES/OS2200.JPG)) - Program description not available.(ABS)


**FILEDUMP** ([1097](1097/1097.md), November
1984![](IMAGES/OS2200.JPG)) - Dumps a word addressable or
sector-addressable file in octal. Documentation included. (ABS)


**FILENAME** ([1077](1077/1077.md), May 1990![](IMAGES/OS2200.JPG)) - Displays the name of your
WORKSPACE/LOOKSPACE. (IPF)


**FILENO** ([1056](1056/1056.md), April 1985![](IMAGES/OS2200.JPG)) - TIP/DPS Program which displays the pertinent
information about a given TIP or TIP/DMS file. (SYM)


**FILES** ([1067](1067/1067.md), January 1986![](IMAGES/OS2200.JPG)) - The @FILES processor displays the files
attached to a user's run. Documentation included. (FTN, MSM, REL,ABS)


**FILESCAN** ([1067](1067/1067.md), April 1977![](IMAGES/OS2200.JPG)) - @FILESCAN is a processor that generates
cross-reference tables from the relocatable elements in a program
file. Documentation included. (ABS)


**FILETYP** ([1072](1072/1072.md), October
1989![](IMAGES/OS2200.JPG)) - This processor gives file and data type of a
specified file. it will go into a mass-storage hold when referencing
an assigned file. Therefore this processor cannot be used against
DMS/TIP files. Documentation included. (SYM 1989, ABS 1988)


**FILEUSE 1R2** ([1037](1037/1037.md), June
1977![](IMAGES/OS2200.JPG)) - This program will display a history of file
usage for a given file based on the daily data log. Pre-ASCII Log
File. Documentation included. (ASM, ABS)


**FINDREF** ([1097](1097/1097.md), April 1993![](IMAGES/OS2200.JPG)) - FINDREF is a front-end tool to the Unisys
product, IACULL (which is an interactive cross reference utility). In
IACULL, looking at a large number of data references can be
cumbersome, because when viewing, you must step through each data
reference. Using FINDREF, the data references are summarized and you
can selectively choose which references to look at in more detail in
IACULL. FINDREF has a vast array of commands,many of which are the
same as IACULL so FINDREF is easy to learn. Some of the basic
capabilities of FINDREF include: 
- Offers a full screen menu of
IACULL files available. 
- Locates one or more tags at once. 
- Appends references to the current list of references. 
- Sorts the list of references. 
- Saves and restores current references. Saves can also
be retained across sessions by cataloging a save file. 
- Accepts IACULL commands. 
- Automatically senses screen size. 
- Trims current references by including or excluding specific strings. 
-  Creates a
printed listing of the references. 
- Creates a TCF based on the
current references. 
- Has on-line help. 
  
Documentation included.(ABS)


**FINN** ([1051](1072/1072.md), November 1989![](IMAGES/OS2200.JPG)) - This processor is a pseudo @FIN and@@TERM; it
uses data file STS$*BYE. Upon execution, this processor will return a
new "SIGNON" screen (TELCON - $$OPEN) for the various hosts and
sessions that a site may have. The SYS$*BYE file will need to be
modified for each site's use. Documentation included. (SYM, ABS)


**FITEM** ([1051](1051/1051.md), September
1983![](IMAGES/OS2200.JPG)) - This processor edits the information returned
by ER FITEM$ for a specified assigned file. (ASM 1983, ABS 1982)


FITEM ([1084](1084/1084.md), October 1989![](IMAGES/OS2200.JPG)) - This processor edits the information returned
by ER FITEM$ for a specified assigned file. (MSM)


**FITEMP** ([1084](1084/1084.md), April 1986![](IMAGES/OS2200.JPG)) - COBOL procedure defining all fields in FITEM
packet. (COB)


**FLAG** ([1051](1051/1051.md), March 1977![](IMAGES/OS2200.JPG)) - Program description not available. (ASM,ABS)


**FLGBOX** ([1056](1056/1056.md), April 1985![](IMAGES/OS2200.JPG)) - TIP/DPS Program which displays the current
settings of the flagbox bits. (ELT)


**FLIP** ([1077](1077/1077.md), May 1990![](IMAGES/OS2200.JPG)) - Flips your screen from column 1 to 70 or vice
versa. (IPF)


**FLOC** ([1072](1072/1072.md), December 1989![](IMAGES/OS2200.JPG)) - Locates 1-5 values in each element of a
specified file. (IPF)


**FOO** ([1051](1051/1051.md), June 1979![](IMAGES/OS2200.JPG)) - Program description not available. (BAS 1978,
COB 1972, ABS 1979)


**FORFLO** ([1005](1005/1005.md), November
1970![](IMAGES/OS2200.JPG)) - FORFLO is an Automatic FORTRAN Flowchart
Generator which creates from any FORTRAN program a computer drawn
flowchart suitable for display on a high-speed printer. The flowchart
produced adheres as closely as possible to standard flowchart
symbols. The flowcharts produced by FORFLO can be very useful in
areas such as training, debugging and documentation. FORFLO is
dependent on the statement structure as defined by the FORTRAN
language. (ASM, REL, ABS)


**FORTRAN** ([1077](1077/1077.md), May 1990![](IMAGES/OS2200.JPG)) - An ASCII FORTRAN compiler-caller.(IPF)


**FORTUNE** ([1077](1077/1077.md), May 1990![](IMAGES/OS2200.JPG)) - Works like the UNIX /usr/games/fortune
program. (IPF)


**FORWARD** ([1077](1077/1077.md), May 1990![](IMAGES/OS2200.JPG)) - Works like the MVS/ISPF FORWARD command.(IPF)


**FOTO-XLATE** ([1067](1067/1067.md), September
1977![](IMAGES/OS2200.JPG)) - Program description not available. (ASM, REL)


**FRE** ([1072](1072/1072.md), April 1987![](IMAGES/OS2200.JPG)) - This processor frees all files assigned to a
runid, Batch or Demand. There are various options and specifications
to control what files to free. Documentation included. (ELT 1989, ABS
1987)


**FREEA** ([1099](1099/1099.md), September
1993![](IMAGES/OS2200.JPG)) - This MASM processor is used to free large
numbers of files from a demand run. It is a much modified (stripped
down)version of one of the many versions of FREEM that is used at
numerous sites.Its major modifications are that it has code to handle
the freeing of files assigned by the @Q processor and code to not
free a run's Working Set file(2200/900 specific). There is no 'H'
(help) option for this processor. The only option supported is the
'S' option, which will suppress the list of files freed.


**FREEIT** ([1084](1084/1084.md), December
1989![](IMAGES/OS2200.JPG)) - Frees all cycles of file on processor call.
(MSM, ABS)


**FREEM** ([1081](1081/1081.md), April 1992![](IMAGES/OS2200.JPG)) - The ancient utility upgraded for modern
times. Documentation Included. (MSM, ABS)


**FREESORT** ([1084](1084/1084.md), April 1990![](IMAGES/OS2200.JPG)) - Processor that frees sort work fields XA
through XZ and R$CORE. (ABS)


**FREER** ([1072](1072/1072.md), November 1989![](IMAGES/OS2200.JPG)) - Does @FREE,R (free from a file but retain use
name). (IPF)


**FREE-TAPES** ([1084](1084/1084.md), October
1987![](IMAGES/OS2200.JPG)) - Processor to obtain a list of all tapes in
the specified FAS tape pool whose system status is FREE and whose
user status is spaces. @FREE-TAPES pool-file-name. Tape numbers are
placed in a data file called FREE-TAPES. (MSM, ABS)


**FS** ([1072](1072/1072.md), May 1988![](IMAGES/OS2200.JPG)) - Change to full screen mode.(IPF)


**FSTATUS** ([1097](1097/1097.md), January
1985![](IMAGES/OS2200.JPG)) - Displays detailed PCIOS file information.
Documentation included. (COB, ABS)


**FTOCED** ([1110](1110/1110.md), March 1997![](IMAGES/OS2200.JPG)) - Full screen table of contents editor. (ABS)


**FULLSCREEN** ([1077](1077/1077.md), May 1990![](IMAGES/OS2200.JPG)) - Puts you in full-screen mode.(IPF)


**FUSION** ([1081](1081/1081.md), February
1993![](IMAGES/OS2200.JPG)) - Speeds up demand output in MASM programs;
intercepts consecutive PRINT$ ERs and accumulates them into a single
FR SYMB$ call. Documentation included. (MSM, ABS)
