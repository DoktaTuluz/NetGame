#pragma once

#if !defined __MESSAGE__H__
#define __MESSAGE__H__

#include <string>

typedef struct Message {
	std::string UUID;
	std::string cmd;
	std::string msg;
};

Message interpretMessage(const std::string& messg);

#endif // __MESSAGE__H__
