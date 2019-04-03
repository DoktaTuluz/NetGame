#include "Server.h"

int main() {
	std::ios::sync_with_stdio(false);
	SetConsoleOutputCP(1252);

	Server server = Server();

	server.loop();
}