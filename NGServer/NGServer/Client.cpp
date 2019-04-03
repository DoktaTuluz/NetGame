#include "Client.h"

// STATIC MEMBER
bool ClientManager::initialized = false;

/* ----- CONST & DEST ----- */
ClientManager::ClientManager() : maxClients{ DEFAULT_MAX_CLIENTS } {
	if (initialized) throw std::exception{ "Can't create multiple client's managers!" };

	initialized = true;
}


ClientManager::ClientManager(unsigned int mxClients) : maxClients{ mxClients } {
	if (initialized) throw std::exception{ "Can't create multiple client's managers!" };

	initialized = true;
}


ClientManager::~ClientManager() {
	clients.clear();
	waiters.clear();
}


/* ----- PUBLIC METHODS ----- */
bool ClientManager::addClient(const Client& client) {
	std::cout << client.UUID << " is trying to connect...\n";

	if (clients.size() == maxClients) {
		std::cerr << "Can't add any client anymore.\n";
		addWaiter(client);
		return false;
	}

	for (auto c : clients) {
		if (c.UUID == client.UUID) {
			std::cerr << "Can't add twice the same client (" << c.UUID << ")\n";
			return false;
		}
	}

	clients.push_back(client);
	std::cout << "Connect > " << client.UUID << "\n";
	return true;
}


bool ClientManager::removeClient(const std::string& uuid) {
	std::cout << uuid << " is trying to disconnect itself...\n";

	for (int i = 0; i != clients.size(); ++i) {
		if (clients[i].UUID == uuid) {
			std::cout << "Disconnect > " << clients[i].UUID << "\n";
			clients.erase(TO_IT(clients, i));

			if (clients.size() > 0)
				moveWaiterToActive();
			return true;
		}
	}

	std::cerr << uuid << " wasn't connected.\n";
	return false;
}


void ClientManager::addWaiter(const Client& client) {
	waiters.push_back(client);
	std::cout << client.UUID << " put in the waiting list.\n";
}


void ClientManager::removeWaiter(const std::string& uuid) {
	for (int i = 0; i != waiters.size(); ++i) {
		if (waiters[i].UUID == uuid) {			
			std::cout << "Remove waiter " << uuid << " (" << waiters[i].IP << " on " << waiters[i].name.sin_port << ")\n";
			waiters.erase(TO_IT(waiters, i));
			return;
		}
	}
}

void ClientManager::moveWaiterToActive() {
	if (clients.size() == maxClients) throw std::exception{ "Can't move the waiter to the main client's list." };
	if (!(waiters.size() > 0)) {
		std::cerr << "No waiter to move.\n";
		return;
	}

	addClient(waiters[0]);
	std::cout << waiters[0].UUID << " now on the main client list\n";
	removeWaiter(waiters[0].UUID);
}
