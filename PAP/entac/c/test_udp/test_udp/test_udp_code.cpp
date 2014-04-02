/* Sample UDP client */

#include <fstream>
#include <winsock2.h>
#include <process.h>
#include <stdio.h>
#include <ws2bth.h>
#include <iphlpapi.h>
#include <icmpapi.h>
#include <iostream> 

SOCKET udp_s, udp_r;

#define GLOVE_MAXNUM    5
DWORD timeSentPacket;
void udp_threadReceive(void *dummy)
{


	int ret;
	char buffer[256];
	int lBuffer = 0;
#define BUFFER_SIZE    7
	DWORD timeLastPacket;
	while (1)
	{
		Sleep(0);

		ret = recvfrom(udp_r, buffer + lBuffer, BUFFER_SIZE - lBuffer, 0, NULL, NULL);

		if (ret == SOCKET_ERROR)
		{
			printf("error");
		}
		else if (ret > 0)
		{
			lBuffer += ret;

			// Proceso el buffer recibido
			if (lBuffer >= BUFFER_SIZE)
			{
				timeLastPacket = GetTickCount();
				printf("Dif time: %d\n", timeLastPacket - timeSentPacket);
				printf("answered5\n");

				// Muestro el paquete
#ifdef _DEBUG_
				printf("Motor: Id: %d\n", motor->id);
				printf("      Tau: %d\n", motor->tau);
				for (unsigned int i = 0; i < GLOVE_MAXNUM; i++)
					printf("  State %d: %d\n", i, motor->status[i]);
#endif

				lBuffer = 0;
				timeLastPacket = GetTickCount();

			}
		}

		if (lBuffer >= GLOVE_MAXNUM)
		{
			printf("GLOVE ERROR OVERFLOW\n");
			lBuffer = 0;
		}
	}

	_endthread();
}

int main(int argc, char**argv)
{
	int sockfd, n;

	char sendline[1000];
	char recvline[1000];
	int port;

	//SOCKET udp_s, udp_r;    
	SOCKADDR_IN addrR, addrL;
	WSADATA w;
	/* Open windows connection */
	if (WSAStartup(0x0101, &w) != 0)
	{
		fprintf(stderr, "Could not open Windows connection.\n");
		exit(0);
	}

	// Create  the socket UDP for sending
	udp_s = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (udp_s == INVALID_SOCKET)
	{
		fprintf(stderr, "Could not create socket.\n");
		WSACleanup();
		exit(0);
	}

	if (udp_s == SOCKET_ERROR)
		return 0;


	addrR.sin_family = AF_INET;
	addrR.sin_port = htons(3000);
	addrR.sin_addr.s_addr = inet_addr("192.168.23.3");


	struct hostent *host;

	if (addrR.sin_addr.s_addr == INADDR_NONE)
	{
		host = NULL;
		host = gethostbyname(argv[1]);
		if (host == NULL)
			return 0;

		memcpy(&addrR.sin_addr, host->h_addr_list[0], host->h_length);
	}


	if (connect(udp_s, (struct sockaddr*)&addrR, sizeof(addrR)) == SOCKET_ERROR)

	{

		fprintf(stderr, "Client: connect() failed: %d\n", WSAGetLastError());

		WSACleanup();

		return -1;

	}

	else

		printf("Client: connect() is OK.\n");

	// Create  the socket UDP for sending
	udp_r = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (udp_r == INVALID_SOCKET)
	{
		fprintf(stderr, "Could not create socket.\n");
		WSACleanup();
		exit(0);
	}
	addrL.sin_family = AF_INET;
	addrL.sin_port = htons(3001);
	addrL.sin_addr.s_addr = htonl(INADDR_ANY);

	if (bind(udp_r, (struct sockaddr*)&addrL, sizeof(addrL)) == SOCKET_ERROR)
		return 0;
	//udp_threadReceive(udp_r);
	_beginthread(udp_threadReceive, sizeof(SOCKET), (void*)udp_r);



	char Chaine[7];

	while (1)
	{
		printf("enter the controls: AxxxxxB    \n");
		//scanf_s("%s",Chaine);
		//gets_s(Chaine);
		std::cin.getline(Chaine, 8);
		timeSentPacket = GetTickCount();
		sendto(udp_s, Chaine, 7, 0,
			(struct sockaddr *)&addrR, sizeof(addrR));
		Sleep(1000);
	}
}