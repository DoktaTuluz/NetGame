#include "Server.h"

/* ----- CONST & DEST ----- */
Server::Server() : dataBuffer{ new char[BUFFER_SIZE] }, sockAddressStructure{ sockaddr_in() }, udpSocket{ NULL } {
	run = init();
}


Server::~Server() {
	delete[] dataBuffer;

	closesocket(udpSocket);
	WSACleanup();
}


/* ----- PUBLIC METHODS ----- */
bool Server::loop() {
	while (true) {
		memset(&client.address, 0, client.size);
		memset(dataBuffer, 0, BUFFER_SIZE);

		if (recvfrom(udpSocket, dataBuffer, BUFFER_SIZE, 0, (sockaddr*)& client.address, &client.size) == SOCKET_ERROR) {
			std::cerr << "Error while reading in coming data. ERROR: " << WSAGetLastError() << "\n";
			continue;
		}

		client.setIP();
		
		time_t timer;
		time(&timer);
		char BufferTime[20];
		tm timeinfo;
		localtime_s(&timeinfo, &timer);
		strftime(BufferTime, sizeof(BufferTime), "%H:%M:%S", &timeinfo);

		Message msg = interpretMessage(dataBuffer);

		std::cout << "+--------------------------------------------------+\n";
		std::cout << "From " << client.IP << " on " << client.address.sin_port << "\n";
		std::cout << "At " << BufferTime << "\n";
		std::cout << "ID: " << msg.UUID << "\n";
		std::cout << "\t>> " << msg.cmd << "\n\t(" << msg.msg << ")\n";
		act(msg);
		std::cout << "+--------------------------------------------------+\n";
	}
}


/* ----- PRIVATE METHODS ----- */
bool Server::init() {
	WSAData data;
	WORD version = MAKEWORD(WSA_MAJOR_VERSION, WSA_MINOR_VERSION);

	int wsInit = WSAStartup(version, &data);
	if (wsInit != 0) {	// Init WSA
		std::cerr << "Failed to initialize Winsock. ERROR: " << wsInit << "\n";
		return false;
	}

	udpSocket = socket(AF_INET, SOCK_DGRAM, 0);	// Set up the socket

		// Initialize socket address
	sockAddressStructure.sin_addr.S_un.S_addr = ADDR_ANY;
	sockAddressStructure.sin_family = AF_INET;
	sockAddressStructure.sin_port = htons(50714);

		// Bind
	if (bind(udpSocket, (sockaddr*)& sockAddressStructure, sizeof(sockAddressStructure)) == SOCKET_ERROR) {
		std::cerr << "Failed to bind the socket. ERROR: " << WSAGetLastError() << "\n";
		return false;
	}

	std::cout << "[\t\tNetGame - Niedermorschwihr Server (c) Noé Toulouze 2019\t\t]\n\n";
	return true;
}


void Server::act(const Message& msg) {
	std::string cmd = msg.cmd;
	std::string buffer;

	if (cmd == "CONNECTION") {
		if (clientManager.addClient(Client{ msg.UUID, client.IP, client.address })) {	// If we can add a client
			buffer = "Connection accepted";
			sendto(udpSocket, buffer.c_str(), buffer.size(), 0, (sockaddr*)& client.address, sizeof(client.address));
			std::cout << "Accept the connection of " << client.IP << "\n";
		}
	} else if (cmd == "DISCONNECTION") {
		if (!clientManager.removeClient(msg.UUID))
			clientManager.removeWaiter(msg.UUID);
	}
}
