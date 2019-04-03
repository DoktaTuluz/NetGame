#pragma once

#if !defined __CLIENT__H__
#define __CLIENT__H__

#include <iostream>
#include <string>
#include <vector>
#include <WS2tcpip.h>

#pragma comment(lib, "ws2_32.lib")

#define DEFAULT_MAX_CLIENTS		4

#define TO_IT(list, i)		list.begin() + i

typedef struct Client {
	std::string UUID;
	std::string IP;
	sockaddr_in name;
};


class ClientManager {
public:
	ClientManager();
	ClientManager(unsigned int maxClients);
	~ClientManager();

	bool addClient(const Client& client);
	bool removeClient(const std::string& uuid);

	void addWaiter(const Client& client);
	void removeWaiter(const std::string& uuid);
	void moveWaiterToActive();

private:
	static bool initialized;

	std::vector<Client> clients;
	unsigned int maxClients;

	std::vector<Client> waiters;
};

#endif // __CLIENT__H__
