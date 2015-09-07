#SingleInstance force
#include SockPuppet.ahk

ss := new SockSlave()

class SockSlave {
	__New(){
		this.listener := new SockListener(this.MessageReceived.Bind(this))
	}
	
	MessageReceived(socket){
		newTcp := socket.accept()
		MsgBox, % "SLAVE: " newTcp.recvText()
		newTcp.sendText("As you wish, master")
	}
}
