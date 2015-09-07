#SingleInstance force
#include SockPuppet.ahk

ss := new SockSlave()

class SockSlave extends SockBase {
	__New(){
		this.CreateGui("x330 y0", "Command|Response")

		; Initialize listener and set callback
		this.listener := new SockListener(this.MessageReceived.Bind(this))
	}
	
	; Callback was fired - message came in.
	MessageReceived(socket){
		newTcp := socket.accept()
		text := newTcp.recvText()
		msg := JSON.Load(text)
		
		response := new this.Message()
		response.command := "As you wish, master"
		LV_Add(,msg.command, response.command)
		newTcp.sendText(JSON.Dump(response))
		Sleep 1000
		newTcp.sendText(JSON.Dump(response))
	}
}
