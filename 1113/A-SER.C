/*
*	a_ser.c : un serveur pour la Serie A.
HISTORIQUE DES MAINTENANCES
---------------------------
GM 27May93: implementation initiale.
GM 13Jun94: popen() au lieu de fic temporaire.
GM 08Jul94: set minimum environment.
GM 03Jul95: ISC->SCO. ascftime()->strftime().
GM 12Jun96: Message si null output.
*/

#include <fcntl.h>
#include <stdio.h>
#include <errno.h>
#include <time.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

/* Definitions used throughout the program */
#define XFERPORT 4096
#define BUFSZ 512

extern int errno;

/*** debug & trace ***/
#include <time.h>
#include <fcntl.h>

int dbg_fd;
int dbg_lvl=0;
int dbg_errno;
long dbg_offset;
time_t dbg_time;
int dbg_txt_sz;
char dbg_array[512];
#define MAXSZ 20000L
#define C ,
#define dbg_hdr "%d%b%y %H:%M:%S "
#define dbg_hdr_sz 17
#define dbg_send(fd, format_and_vars) \
	{\
	dbg_errno = errno; \
	dbg_time = time(0); \
	dbg_txt_sz = dbg_hdr_sz; \
	strftime(dbg_array, 1024, dbg_hdr, gmtime(&dbg_time)); \
	dbg_txt_sz += sprintf(&dbg_array[dbg_txt_sz], "[%d %d] ", \
						getpid(), __LINE__); \
	dbg_txt_sz += sprintf(&dbg_array[dbg_txt_sz], format_and_vars); \
	if ((dbg_offset = lseek(fd, 0L, 1)) > MAXSZ) dbg_offset = lseek(fd, 0L, 0); \
	if (dbg_offset > 1L) dbg_offset = lseek(fd, -1L, 1); \
	write(fd, dbg_array, dbg_txt_sz); \
	write(fd, "\004", 1); \
	}
#define DBG(format_and_vars) dbg_send(dbg_fd, format_and_vars)
int dbg_open(dbg_name, alt_fd)
	char * dbg_name;
	int alt_fd;
{
	int fd;

	if ((fd = open(dbg_name, O_RDWR|O_CREAT, 0666)) < 0) {
		if (alt_fd < 0) {
			sprintf(dbg_array, "dbg_open %s", dbg_name);
			perror(dbg_array);
			return(alt_fd);
		}
		fd = alt_fd;
		dbg_send(fd, "Ne peut ouvrir %s (E=%d)\n" C dbg_name C errno);
		return(fd);
	}
	else {
		int sz = 1;
		while ((dbg_array[0] != 4) && ( sz > 0)) {
			sz = read(fd, dbg_array, 1);
		}
		return(fd);
	}
}
/*** Fin debug & trace ***/

/* Global Variables */

int s;	/* File Descriptor used for Socket */
int n;	/* Value returned from function calls */
struct sockaddr_in server,client;	/* Client and server socket addresses */
char buf[BUFSZ];	/* send/recv buffer */
char cmd[BUFSZ];	/* Command buffer */



main(argc,argv)
	int argc;         /* Count of vectors on command line */
	char **argv;     /* Vector containing parameters from command line */  

{
	dbg_fd = dbg_open("/usr/sacem/log.d/a_ser.log", 2);
	dbg_lvl = argc - 1; 

	/*
	 * Set up minimum environment...
	 */
	n= putenv("PATH=.:/bin:/usr/bin:/usr/lbin:/etc:/usr/ucb");
	if ((n < 0) || (dbg_lvl)) {
		DBG("Putenv returned %d, ERR %d\n" C n C dbg_errno);
	}

	
	/*
	 * Set up socket connections... 
	 * AF_INET is the communications domain, internet,
	 * SOCK_STREAM is the type of connection requested, a bytestream
	 * socket connection, and IPPROTO_TCP specifies the protocol to be
	 * used, in this case TCP.
	 */
	s = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
	if ((s < 0) || (dbg_lvl)) {
		DBG("Socket returned %d, ERR %d\n" C s C dbg_errno);
	}

  
	server.sin_family = AF_INET;      /* Set domain */
	server.sin_port = htons(XFERPORT); /* Set transfer port */
	server.sin_addr.s_addr = htonl (INADDR_ANY);    

	n = bind(s,&server, sizeof(server));/* Bind server's addr to sock*/
	if ((n < 0) || (dbg_lvl)) {
		DBG("Bind returned %d, ERR %d\n" C n C dbg_errno);
	}

	n = listen(s,1);        /* Listen for a connection on the socket */
	if ((n < 0) || (dbg_lvl)) {
		DBG("Listen returned %d, ERR %d\n" C n C dbg_errno);
	}

	client.sin_family = AF_INET;       /* Set the client's comm domain */
	client.sin_addr.s_addr = htonl(INADDR_ANY); /* Accept any Internet address */
	client.sin_port = htons(0); 

	/* Begin loop-forever */
	DBG("*** Ready ***\n");
	for (;;)
		receive();        /* Be a server process */
}


int receive()    /* Be a server */
{
	int ns;               /* New socket from 'accept' */
	int client_len = sizeof(client);
	int bytes_rcvd,bytes_sent,bytes_read,total=0; 
	static char hostname[24] = "Unknown_host";	/* Name of remote machine */
	struct hostent *hp;	/* Pointer to struct w/ host address */
	FILE * pfd;

	if (dbg_lvl) {
		DBG("Entering receive()\n");
	}
	total=0;
	ns = accept(s,&client,&client_len);     
	if ((ns < 0) || (dbg_lvl)) {
		DBG("Accept returned %d, ERR %d\n" C ns C dbg_errno);
	}

	hp = gethostbyaddr((char *)&client.sin_addr, sizeof(client.sin_addr), AF_INET);
	if (hp)
		strcpy(hostname, hp->h_name);

	bytes_rcvd = recv(ns,buf,BUFSZ,0);
	if ((bytes_rcvd < 0) || (dbg_lvl)) {
		DBG("Recv returned %d, ERR %d\n" C bytes_rcvd C dbg_errno);
	}

	buf[bytes_rcvd] = '\0';
	strcpy(cmd, buf);	/* Copy command */

	DBG("From %s: %s\n" C hostname C cmd);

	/* Redirection sortie erreur */
	strcat(cmd, " 2>&1");

	/* Envoi ACK au client */
	n = send(ns,"ACK",3,0);
	if ((n < 0) || (dbg_lvl)) {
		DBG("Send returned %d, ERR %d\n" C n C dbg_errno);
	}

	pfd = popen(cmd, "r");
	if ((pfd == (FILE *)0) || (dbg_lvl)) {
		DBG("Popen returned %x, ERR %d\n" C pfd C dbg_errno);
	}
	if (pfd < 0)  
		perror("a_ser");
	else {
		while (fgets(buf, 512, pfd) != NULL) {
			bytes_sent = send(ns,buf,strlen(buf),0);
			if ((bytes_sent < 0) || (dbg_lvl)) {
				DBG("Send returned %d, ERR %d\n" C bytes_sent C dbg_errno);
			}
			total += bytes_sent;
		}
		DBG("Sent %d bytes\n" C total);
		if (total == 0) {
			char msg[BUFSIZ];
			sprintf(msg, "a_ser: Command '%s' NULL output\n", cmd);
			send(ns,msg,strlen(msg),0);
		}
	}

	n = pclose(pfd);
	if ((n != 0) || (dbg_lvl)) {
		char msg[BUFSIZ];
		sprintf(msg, "a_ser: Command '%s' returned %d\n", cmd, n);
		send(ns,msg,strlen(msg),0);
		DBG("Pclose returned %d, ERR %d\n" C n C dbg_errno);
	}
	n = close(ns);
	if ((n < 0) || (dbg_lvl)) {
		DBG("Close returned %d, ERR %d\n" C n C dbg_errno);
	}
}
