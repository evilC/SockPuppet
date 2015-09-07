#SingleInstance force
#include SockPuppet.ahk

ss := new SockSlave()

class SockSlave extends SockBase {
	__New(){
		; Initialize listener and set callback
		this.listener := new SockListener(this.MessageReceived.Bind(this))
	}
	
	; Callback was fired - message came in.
	MessageReceived(socket){
		newTcp := socket.accept()
		text := newTcp.recvText()
		msg := JSON.Load(text)
		MsgBox, % "SLAVE Received command: " msg.command "`n`nJSON:`n " text
		
		response := new this.Message()
		response.command := "As you wish, master"
		newTcp.sendText(JSON.Dump(response))
	}
}
