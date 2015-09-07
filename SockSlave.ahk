#SingleInstance force
#include SockPuppet.ahk

ss := new SockSlave()

class SockSlave {
	__New(){
		this.listener := new SockListener()
	}
}
