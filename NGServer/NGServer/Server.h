#pragma once

#if !defined __SERVER__H__
#define __SERVER__H__

#include <iostream>
#include <string>
#include <ctime>
#include <WS2tcpip.h>
#include "Client.h"
#include "Message.h"

#pragma comment(lib, "ws2_32.lib")

#define WSA_MAJOR_VERSION	2
#define WSA_MINOR_VERSION	2

constexpr int BUFFER_SIZE = 1024;

	// A structure regrouping the client infos
typedef struct ClientNameStruct {
	sockaddr_in address;
	char IP[256] = "";

	int size = sizeof(address);

	void setIP() {
		memset(IP, 0, sizeof(IP));
		inet_ntop(AF_INET, &address.sin_addr, IP, sizeof(IP));
	}
} ClientName;


class Server {
public:
	Server();
	~Server();

	bool loop();

private:
	bool init();

	void act(const Message& msg);

private:
	bool run;

		// The current client infos
	SOCKET udpSocket;
	sockaddr_in sockAddressStructure;
	ClientName client;

		// The set of clients
	ClientManager clientManager;

	char* dataBuffer;
};

#endif // __SERVER__H__
