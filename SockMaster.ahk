#SingleInstance force
#include SockPuppet.ahk

talker := new SockTalker()
return

F12::
	talker.Send()