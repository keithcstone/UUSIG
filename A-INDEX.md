# Program Index By Letter: A

[B](B-INDEX.md) [C](C-INDEX.md)
[D](D-INDEX.md) [E](E-INDEX.md) [F](F-INDEX.md)
[G](G-INDEX.md) [H](H-INDEX.md) [I](I-INDEX.md)
[J](J-INDEX.md) [K](K-INDEX.md) [L](L-INDEX.md)
[M](M-INDEX.md) [N](N-INDEX.md) [O](O-INDEX.md)
[P](P-INDEX.md) [Q](Q-INDEX.md) [R](R-INDEX.md)
[S](S-INDEX.md) [T](T-INDEX.md) [U](U-INDEX.md)
[V](V-INDEX.md) [W](W-INDEX.md) [X](X-INDEX.md)
[Y](Y-INDEX.md) [Z](Z-INDEX.md)

- - -

**ABF** ([1084](1084/1084.md), June 1990 ![](IMAGES/OS2200.JPG))

- Program to assign a file and BRKPT PRINT$ to it. The file will be
called 'runid*PRINT', except under certain circumstances.(MSM,
ABS)

**ABORT** ([1084](1084/1084.md), October 1987
![](IMAGES/OS2200.JPG))

- Program description not available.(ELT, ABS)

**ABSDOWN** ([1084](1084/1084.md), May 1990
![](IMAGES/OS2200.JPG))

- Compares two absolute elements and prints the differences. @ABSDOWN
program-1,program-2. (MSM, ABS)

**ACEY** ([1051](1051/1051.md), October 1978
![](IMAGES/OS2200.JPG))

- The game of Acey-Ducey.(BAS)

**ACCT** ([1084](1084/1084.md), August 1989
![](IMAGES/OS2200.JPG))

- Program to display fixed disk limit/usage for the user's account.
(ABS)

**ACOB$CKPT** ([1065](1065/1065.md), June 1983
![](IMAGES/OS2200.JPG))

- MASM subroutine written to be called from ACOB program. It uses ER
CSF$ to do an @CKPT into a disk file which is created by the
subroutine. (MSM)

**ACOB-SUBS** ([1065](1065/1065.md), April 1989
![](IMAGES/OS2200.JPG))

- A set of MASM subroutines written to be called from an ACOB
program. They do ER IOW$, ER FITEM$, ER TWAIT$, ER DM$IOW and ER
INFO$ (user-ID function) from user-supplied packets.Documentation
included. (ASM)

**ADATE** ([1065](1065/1065.md), March 1989
![](IMAGES/OS2200.JPG))

- Given a Julian date and a displacement in days (into the past or
future), this routine calculates a new Julian date.Documentation
included. (ELT, COB, REL)

**ADD** ([1084](1084/1084.md), December 1988
![](IMAGES/OS2200.JPG))

- ECL command to dynamically add other ECL images to a runstream.
(ELT, ABS)

**ADDS** ([1084](1084/1084.md), December 1988
![](IMAGES/OS2200.JPG))

- Automated Documentation Distribution System. The document to be
distributed must exist in the file ADDS*DOCUMENT and must be a print
file. Verify that the required distribution list(s) existing the file
ADDS*ADDS and have an element name of LIST-zzzzzzz where 'zzzzzzz' is
a unique character string. Each list must contain data images in the
form USER xxxy where xxx is a mail station or office number and y is
a character or characters used to achieve uniqueness when there are
more than one occurrence of xxx where xxx is the same. A list name of
USERS is a special case and will cause the document to be sent to all
users defined in DATASEC*DATA.AUSER. Type@ADDS and then enter each
desired distribution list name. (ABS)

**ADVENTURE** ([1051](1051/1051.md), April 1981
![](IMAGES/OS2200.JPG))

- This file contains an FTN version of the ADVENTURE program.
ADVENTURE is an addictive game...be careful, it may take over your
computer center for a month or two! Documentation included.(ABS)

**AFOR** ([1064](1064/1064.md), May 1976 ) - The
ATHENA Compiler is a tremendously enhanced version of FORTRAN V. It
permits unlimited use of expressions and has a very powerful MACRO
capability. Debug and trace features are also provided.(ABS)

**ALFP** ([1099](1099/1099.md), September 1993
![](IMAGES/OS2200.JPG))

- This COBOL processor is used to report on BATCH or DEMAND runs
activities. Selection can be on RUNID or FILENAME.The ASCII LOG entry
types that are reported on are: 101, 106, 107, 109, 403,404, and 405.
When a time frame to report on is specified the ALFP processor makes
no attempt to restrict the report to only that time frame. It uses
the SLRR selection routines to select the cycles of the ASCII LOG
which contain the time frame requested and reports on the complete
cycle(s) of the ASCII LOG.(COB, ABS)

**ALFQP 1R7** ([1082](1082/1082.md), July 1991
![](IMAGES/OS2200.JPG))

- ASCII Log File Query Processor allows the user to select and print
log entries based on criteria such as RUNID,ACCOUNT, TIME period or
FILENAME, generate the CONSOLE listing, select on CONSOLE KEYINS as
well as other items. ALFQP will also allow for the saving and
reloading of log file cycles, and optionally purge them on a
save.Documentation included. (ABS)

**ALIAS** ([1067](1067/1067.md), November 1984
![](IMAGES/OS2200.JPG))

- @ALIAS allows the user to specify one or more alternate element
names to be equated to an existing element.Documentation included.
(MSM 1983, REL 1984, ABS 1981)

**ASCII LOG ACCOUNTING PROGRAMS** ([1073](1073/1073.md),
December 1990 ![](IMAGES/OS2200.JPG))

- This is a set of programs to read the ASCII System Log and prepare
a billing tape. Program LOG40-COPY uses SLRR to read log records and
write selected record types to an output SDF file. Program
LOG40-MERGE merges SDF log data to create consolidated log files
(e.g. weekly or monthly). Program L40BIL-SF reads a log file in SDF
format and creates an IBM format billing tape. Program BILREP reads
the billing tape and produces a summary report. Program LOGMFDX
accumulates cataloged tape and disk existence units. Documentation
included.(ELT's, COB's, ASM's, MSM's, ABS)

**ASGCNT** ([1099](1099/1099.md), September 1993
![](IMAGES/OS2200.JPG))

- This MASM processor tells you how many runs have a particular
cataloged file assigned. It optionally pipes this information. The FF
keyin is preferable for console and @@CONS users, but this processor
allows you to write smart batch jobs that vary their action depending
on how many runs are using a file. (MSM, ELT)

**ASGSORT** ([1084](1084/1084.md), April 1990
![](IMAGES/OS2200.JPG))

- This is a program that is used to assign sort work files XA, XB and
R$CORE on removable packs in the CFSUTL pool.(ABS)

**ASGTEMP** ([1084](1084/1084.md), April 1990
![](IMAGES/OS2200.JPG))

- This is a program that is used to assign temporary files on
removable packs in the CFSUTL pool.(ABS)

**ASSIGN** ([1084](1084/1084.md), November
1990![](IMAGES/OS2200.JPG))

- Processor to assign files on removable disk packs by specifying a
pool name rather than specific hard-coded pack IDs. (MSM 1990, ABS

1989)

**AT-SWITCH **([1081](1081/1081.md), February 1993
![](IMAGES/OS2200.JPG))

- Executed the first thing every morning to insure that a new cycle
of the audit trail is created. (ELT)

**ATAT** ([1097](1097/1097.md), May 1986
![](IMAGES/OS2200.JPG))

- The program ATAT will read images, put"D,@@" in front of the image,
and perform an ER APRTCN$. This program provides a means to perform
@@-Commands from @ADD stream. (ABS)

**ATP** ([1060](1060/1060.md), June 1990
![](IMAGES/OS2200.JPG))

- Audit Trail Processor selects and prints any information from AUDIT
TRAILs. It is compatible with UDS. Documentation included. (COB,
ABS)

**AUTO** ([1107](1107/1107.md), April 1998
![](IMAGES/OS2200.JPG))

- AUTO is an automated run scheduling utility for Unisys 1100/2200
computers. Documentation included. (ASM, SSG)

**AVAIL** ([1051](1051/1051.md), October
1982![](IMAGES/OS2200.JPG))

- The @AVAIL processor displays mass storage availability by
equipment type or by unit. Documentation included.(MSM 1982, ABS  1978)
