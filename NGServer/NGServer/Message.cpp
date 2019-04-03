#include "Message.h"

Message interpretMessage(const std::string& messg) {
	return Message {
		messg.substr(messg.find_first_of('|', 0) + 1, messg.find_first_of(';', 0) - 1 - messg.find_first_of('|', 0)),	// UUID
		messg.substr(messg.find_first_of('[', 0) + 1, messg.find_first_of(']', 0) - 1 - messg.find_first_of('[', 0)),		// CMD
		messg.substr(messg.find_first_of(':', 0) + 1, messg.find_first_of('|', 0) - 1 - messg.find_first_of(':', 0))	// MSG
	};
}
