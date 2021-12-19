/*
 * a_cli.c : Client Unix du serveur Serie A S/UTL/U_SERVER.
 * Usage: a_cli <Host_name> 'DIR <Directory_name>'
 *        a_cli <Host_name> 'SPO <DCKEYIN Command>'
 */

#include <fcntl.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>


/* Definitions used throughout the program */
#define XFERPORT 4097
#define BUFSZ 512

extern int errno;

/* Global Variables */

char *hostname;	/* Name of machine to transfer file to (argv[1]) */
char *command;	/* Name of file to be transfered, as taken from argv */
int s;	/* File Descriptor used for Socket */
int n;	/* Value returned from function calls */
struct sockaddr_in server,client;	/* Client and server socket addr */
struct hostent *hp;	/* Pointer to struct w/ host address */
char buf[BUFSZ];	/* send/recv buffer */
char clean_buf[BUFSZ];	/* send/recv buffer without 0x40*/
int	clean_chars;	/* size of clean buf */

/*
*	Mise en forme du buffer retourne par le Serie A
*/
int clean_it(buf_in, buf_out, chars_in)
	char * buf_in;
	char * buf_out;
	int chars_in; 
{
	int cnt = 0;
	int i = 0;

	while (i < chars_in) {
		switch ((unsigned char)*buf_in) {
case 64:	/* Arrobas, ignore */
			break; 

case 0:		/* Null, translate to CR */
			*buf_out = 10;
			buf_out++;
			cnt++;
			break;

default:
			*buf_out = *buf_in;
			buf_out++;
			cnt++;
		}
		buf_in++;
		i++;
	}
	return(cnt);
}

main(argc,argv)
	int argc;
	char *argv[];

{
	if (argc == 3) {
		hostname=argv[1];
		command=argv[2];
		transmit();       /* Be a client process */
		exit(0); 
	}
	else { 
		printf("Usage: a_cli hostname 'Commande'\n");
		exit(1);
	}
}




/*
* Be a client
*/
int transmit()
{
	int bytes_read, bytes_sent,total=0;
	
	/*
	 * Set up socket connections... 
	 * AF_INET is the communications domain, internet,
	 * SOCK_STREAM is the type of connection requested, a bytestream
	 * socket connection, and IPPROTO_TCP specifies the protocol to be
	 * used, in this case TCP.
	 */
	s = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
	checkp (s,"socket");
	server.sin_family = AF_INET;	/* Set domain */
	server.sin_port = htons(XFERPORT);	/* Set up transfer port */
	hp = gethostbyname(hostname);	/* Get network address for host */
	checkp( (hp==NULL ? -1 : 0),"gethostbyname");

	/*      
	 * Copy the h_addr field of the hostent struct returned by 
	 * gethostbyname to hp into the server address.
	 */
	memcpy( (char*)&server.sin_addr.s_addr, hp->h_addr, hp->h_length);
	
	n = connect(s,&server,sizeof(server));	/* Connect to remote host */
	checkp(n,"connect to host");    
	
	n = send(s,command,strlen(command),0);	/* Send command */
	checkp(n,"command send");

	n = recv(s,buf,BUFSZ,0);	/* Receive ACK from server */
	checkp(n,"server ack");
	if (!(n>2 && buf[0]=='A' && buf[1]=='C' && buf[2]=='K'))
	{
		printf("Remote failed to ack: %s\n",buf);
		exit(1);
	}


	/* Read from socket */
	while ( (bytes_read = recv(s,buf,BUFSZ)) > 0 )
	{
		checkp(bytes_read,"bytes read from socket");

		if ((clean_chars = clean_it(buf,clean_buf,bytes_read)) > 0) {
			write(1,clean_buf,clean_chars);
		}

	}

	/* End of session */
	n=close(s);
	checkp(n,"close socket");
	exit(0);
}


/* Check the value returned from a function call. If negative,
* display an appropriate error.
* Defining DEBUG at compile will cause a trace of all relevant
* function calls.
*/
int checkp (n,msg) 
int n;
char *msg;          
{
	if (n<0)
	{
		fprintf (stderr, "Program terminated: error %u in %s\n",errno,msg);
		exit(1);
	}       
#ifdef DEBUG
	else
		printf("%s succeded, n = %d\n",msg,n);
#endif
}
