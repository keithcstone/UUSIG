# Program Index By Letter: P

[A](A-INDEX.md) [B](B-INDEX.md)
[C](C-INDEX.md) [D](D-INDEX.md)
[E](E-INDEX.md) [F](F-INDEX.md)
[G](G-INDEX.md) [H](H-INDEX.md)
[I](I-INDEX.md) [J](J-INDEX.md)
[K](K-INDEX.md) [L](L-INDEX.md)
[M](M-INDEX.md) [N](N-INDEX.md)
[O](O-INDEX.md) [Q](Q-INDEX.md)
[R](R-INDEX.md) [S](S-INDEX.md)
[T](T-INDEX.md) [U](U-INDEX.md)
[V](V-INDEX.md) [W](W-INDEX.md)
[X](X-INDEX.md) [Y](Y-INDEX.md)
[Z](Z-INDEX.md)

- - -
**PACKCHECK 1R1** ([1037](1037/1037.md), March
1978![[OS 2200]](IMAGES/OS2200.JPG)) - Program will check a
program file and print information about deleted elements to aid user
in determining whether a file should be packed. Documentation
included. (ASM, ABS)

**PACK-MOVE** ([1065](1065/1065.md), July
1985![[OS 2200]](IMAGES/OS2200.JPG)) - Two MASM programs to
simplify the moving of files from a source disk pack to one or more
destination disk packs. The first program, PACK-COPY, copies the
files to a COPY,G format tape (and a duplex tape copy) and saves the
information needed to recatalog the files. PACK-RESTORE can be used
to recatalog the files and copy them in from the COPY,G tape.
Documentation included. (MSM 1985/1983)

**PAKCHK** ([1072](1072/1072.md), June
1989![[OS 2200]](IMAGES/OS2200.JPG)) - This processor will
list tracks available on FIXED and REMOVABLE disks. Originally
written in MASM, it was rewritten in PLUS. Documentation included.
(ELT, ABS)

**PAS** ([1036](1036/1036.md), November
1978![[OS 2200]](IMAGES/OS2200.JPG)) - USEPASCAL compiler
accepts the full PASCAL language and generates relocatable code
compatible with other Univac processors. The compiler allows
externally compiled procedures, as well as ASCII FORTRAN subroutines.
The compiler uses ASCII RLIB routines for run-time support. It
requires about 64K to compile itself. USEPASCAL has been used to
program a communications handler between the Univac 1110 and an
ARPANET ELF(PDP 11/40). Documentation included. (SYM, REL, ABS)

**PASOFF** ([1099](1099/1099.md), September
1993![[OS 2200]](IMAGES/OS2200.JPG)) - This MASM processor
reads a TIP transaction from a card and passes off to a given PID via a given MCB. No default absolute is included for this processor
because you must configure subroutine GETMCBBDI and then reassemble
the subroutine and then this processor. (MSM, ABS)

**PASSWD** ([1056](1056/1056.md), May
1985![[OS 2200]](IMAGES/OS2200.JPG)) - TIP/DPS Program which
allows the changing of a TIP/DPS password, while leaving the userid
and security profile intact.(SYM)

**PATH** ([1077](1077/1077.md), May 1990![[OS 2200]](IMAGES/OS2200.JPG)) - Works kind of like the DOS PATH
command.(IPF)

**PB** ([1081](1081/1081.md), January
1992![[OS 2200]](IMAGES/OS2200.JPG)) - Editor macro used to
PRINT (or with the LN-prefix, LNPRINT) the 22 lines up to the line
specified on the command or the current line if none is specified.
(ELT)

**PCT** ([1099](1099/1099.md), September
1993![[OS 2200]](IMAGES/OS2200.JPG)) - This MASM processor
displays various information about your run from the Program Control
Table. Optionally, it will show your security profile (only for sites
with Security Option 1 or above). If your Exec level is below 43R4,
you must set the PCTLEVEL tag in PCTDEF to the appropriate value and
recompile PCTDEF and PCT. (MSM, ABS)

PDP ([1067](1067/1067.md), December 1975![[OS 2200]](IMAGES/OS2200.JPG)) - Program description not
available.(ABS)

**PEEK** ([1063](1063/1063.md), October
1988![[OS 2200]](IMAGES/OS2200.JPG)) - PEEK is a software
package that allows you to monitor any program that is running in the
system. It shows where the program is spending its time, what ERs are
called and where they are called from, and what banks and segments
are being used. No changes to the program being monitored are
required and it suffers no significant performance degradation while
being monitored. The @PEEK package consists of local-code operating
system changes, a program to gather statistics, and a program to
process and display the statistics interactively on a UTS-20 or
similar terminal. Documentation included. (PLS)

**PF** ([1081](1081/1081.md), January
1992![[OS 2200]](IMAGES/OS2200.JPG)) - Editor macro used to
PRINT the 22 lines following the line specified on the command or the
current line if none is specified. (ELT)

**PFCHECK 1R3** ([1037](1037/1037.md),
January 1980![[OS 2200]](IMAGES/OS2200.JPG)) - This program will
check a program file for certain conditions and set T3 (third 1/3
word) of the condition word accordingly. Documentation included.
(ASM, ABS)

**PFLIST** ([1097](1097/1097.md), April
1992![[OS 2200]](IMAGES/OS2200.JPG)) - Prints the contents of
an entire program file, element by element. Call it from batch or
breakpointed demand. Documentation included. (ABS)

**PFREPORT** ([1084](1084/1084.md), January
1990![[OS 2200]](IMAGES/OS2200.JPG)) - Program that produces
a list of all of the permanent files assigned. If 'runid' is
specified, the list is for that run only. To list files for the EXEC
('EXEC 8'), specify a runid of 'EXEC-8'.(MSM, ABS)

**PFSHOW** ([1077](1077/1077.md), May
1990![[OS 2200]](IMAGES/OS2200.JPG)) - Displays the settings
on your function keys. (IPF)

**PIDSTA** ([1099](1099/1099.md), September
1993![[OS 2200]](IMAGES/OS2200.JPG)) - This MASM processor
reads a PID's current status for a given MCB and pipes this data. No
default absolute is included for this processor because you must
configure subroutine GETMCBBDI and then reassemble the subroutine and
then this processor. We leave it to you to develop downstream uses
for this pipeline, based on what your site needs. (MSM, ABS)

**PINLINE** ([1077](1077/1077.md), May
1990![[OS 2200]](IMAGES/OS2200.JPG)) - A PLUS Inline
processor-caller.(IPF)

**PIP** ([1067](1067/1067.md), May 1987![[OS 2200]](IMAGES/OS2200.JPG)) - Program Instrumentation Package
takes a random sampling by an external observer (PIP itself) while
the program is left free to execute normally. In this manner the user
can determine which portions of his program receive the heaviest use
in order to facilitate program optimization. For example, use of this
package pointed out a bottleneck in the assembler which was
reprogrammed to produce a 10% saving in running time. Documentation
included. (ABS)

**PKTGEN$** ([1081](1081/1081.md), November
1991![[OS 2200]](IMAGES/OS2200.JPG)) - MASM PROC for defining
and drawing packets. Documentation included. (MSM)

**PKUTIL** ([1084](1084/1084.md), December
1988![[OS 2200]](IMAGES/OS2200.JPG)) - Removable pack backup
and restore utility. (ABS)

**PLOT-GRAPH-DRAW** ([1056](1056/1056.md),
July 1985![[OS 2200]](IMAGES/OS2200.JPG)![[MAPPER]](IMAGES/MAPPER.JPG)) - These MAPPER runs provide
enhanced and streamlined MAPPER graphics. These routines will be
faster than regular MAPPER graphics, provide more options, and allow
up to four graphs per page. (SYM)

**PLUS** ([1077](1077/1077.md), May 1990![[OS 2200]](IMAGES/OS2200.JPG)) - A PLUS compiler-caller. (IPF)

**POOL-TAPES** ([1084](1084/1084.md), April
1988![[OS 2200]](IMAGES/OS2200.JPG)) - Processor to obtain a
list of all tapes in the specified FAS tape pool whose user status is
spaces. @POOL-TAPES pool-file-name. Tape numbers are placed in a data
file called POOL-TAPES.(MSM, ABS)

**PP** ([1081](1081/1081.md), January
1992![[OS 2200]](IMAGES/OS2200.JPG)) - Editor macro is used
to print 79 columns as specified on the command. PP alone will print
that many lines from the current one, and with two arguments it will
print from the first to the second.(ELT)

**PQCUP** ([1108](1108/1108.md), February
1996![[OS 2200]](IMAGES/OS2200.JPG)) - The PQCUP processor is
used to maintain the symbiont queues on your system. The main reason
PQCUP has been written is to selectively get rid of print files which
have been queued for printing but are no longer required.(MSM)

**PREMAP** ([1084](1084/1084.md), May
1989![[OS 2200]](IMAGES/OS2200.JPG)![[MAPPER]](IMAGES/MAPPER.JPG)) - A program that reads the MAPPER
purge tapes and generates the appropriate ECL need to load the
contents of those tapes to disk. Call is simple @PREMAP (it is
assumed that the purge tape is assigned and has a use name of
MAPDAT). (MSM, ABS)

**PRINTERS** ([1084](1084/1084.md), November
1990![[OS 2200]](IMAGES/OS2200.JPG)) - A program which will
create a temporary file (called PRINTERS) which contains a list of
printers (devices)and queues (stations) on the system in an SGS
format. The 'L' option will display the printers and queues. (MSM,
ABS)

**PRINTLIST** ([1065](1065/1065.md), April
1987![[OS 2200]](IMAGES/OS2200.JPG)) - This program reads the
Pre-ASCII system log file to find all the type 14 and 15 log entries
and prints a report listing all files which were printed, along with
their termination status.(MSM, REL, ABS)

**PRINTQ** ([1065](1065/1065.md), December
1989![[OS 2200]](IMAGES/OS2200.JPG)) - This program uses ER
SMOQUE$ to list all files queued to a user-ID. (MSM 1989, ABS 1986)

**PRIV** ([1065](1065/1065.md), April
1989![[OS 2200]](IMAGES/OS2200.JPG)) - This processor does an
ER MODPS$ to make a run privileged. Documentation included. (MSM
1989, ABS 1986)

**PROFILE** ([1077](1077/1077.md), May
1990![[OS 2200]](IMAGES/OS2200.JPG)) - Allows you to easily
change your IPF system variables. (IPF)

**PRTCN** ([1099](1099/1099.md), September
1993![[OS 2200]](IMAGES/OS2200.JPG)) - This MASM program
takes input data cards and submits them via ER PRTCN$, thus allowing
you to @ADD transparent (@@) control statements in demand. It is the
only program (as opposed to processor) in this file--you must @XQT
it. It does not support the 'H' (help) option. (MSM, ABS)

**PRTCON** ([1084](1084/1084.md), December
1990![[OS 2200]](IMAGES/OS2200.JPG)) - This is the driver for
all of the remote printers. It can be started via S PRTCON. (MSM,
ABS)

**PRTF** ([1084](1084/1084.md), August
1990![[OS 2200]](IMAGES/OS2200.JPG)) - Processor that places
filename, F-cycle, and reel numbers of a tape file in a temporary
data file (PRTF). Number of granules assigned is substituted for disk
files, along with the word 'DISK'.(MSM, ABS)

**PRTF** ([1097](1097/1097.md), September
1989![[OS 2200]](IMAGES/OS2200.JPG)) - PRTF is like FURPUR
PRT,F but prints much more information about the file than FURPUR
does, such as print queue, DAD table, and QUOTA information.
Documentation included. (MSM, ABS)

**PRTF** ([1097](1097/1097.md), September
1991![[OS 2200]](IMAGES/OS2200.JPG)) - Replacement for the
FURPUR @PRT,F. PRTF reads the directory information for the specified
file, using ER INFO$ and the DREAD$ function of the ER MSCON$, then
summarizes the information. Documentation included. (ABS)

**PRTF** ([1099](1099/1099.md), September
1993![[OS 2200]](IMAGES/OS2200.JPG)) - This MASM processor
provides a more detailed display than does the FURPUR @PRT,F command.
This may not work perfectly for some environments (e.g., Multi-Host
File Sharing). (MSM, ABS)

**PRTI** ([1097](1097/1097.md), March
1993![[OS 2200]](IMAGES/OS2200.JPG)) - An alternative to
FURPUR's @PRT,I. It lists all the files assigned to the run in
alphabetical order in an easy-to-read format. In addition,
information concerning certain file attributes is printed.
Documentation included. (ABS)

**PRTL** ([1065](1065/1065.md), February
1987![[OS 2200]](IMAGES/OS2200.JPG)) - MASM processor to read
the table of contents of a program file named in SPEC-1 and search it
for a character string that matches the one specified in SPEC-2. For
example: @PRTL file.,ILL would find elements WILLIAM, WILLY, BILLY,
etc. (COB)

**PRTT** ([1096](1096/1096.md), March
1993![[OS 2200]](IMAGES/OS2200.JPG)) - Processor used to list
information about elements in a program file. Similar to UNISYS
(@PRT,T) but it's more flexible and produces a more compact listing.
Can be used from batch if desired. Documentation included. (MSM,ABS)

**PSAVEWS/PREPLACEWS**
([1071](1072/1072.md), December 1989![[OS 2200]](IMAGES/OS2200.JPG)) - Modified versions of UNISYS
procedures to save and restore current workspace. Called by many of
the other IPF procs on [1072](1072/1072.md). (IPF)

**PT** ([1081](1081/1081.md), January
1992![[OS 2200]](IMAGES/OS2200.JPG)) - Editor macro used to
print the top 22 lines. (ELT)

**PV** ([1081](1081/1081.md), January
1992![[OS 2200]](IMAGES/OS2200.JPG)) - Editor macro used to
print the 22 lines around (n-10,n+11) the operand, or the current
line if none.(ELT)

**PWD** ([1077](1077/1077.md), May 1990![[OS 2200]](IMAGES/OS2200.JPG)) - Works like the UNIX pwd (print
work directory) command. (IPF)

**PX** ([1081](1081/1081.md), April 1992![[OS 2200]](IMAGES/OS2200.JPG)) - Editor macro used to print the
last 22 lines. (ELT)

**PXQT** ([1077](1077/1077.md), May 1990![[OS 2200]](IMAGES/OS2200.JPG)) - Works like the CTS PXQT
command.(IPF)
