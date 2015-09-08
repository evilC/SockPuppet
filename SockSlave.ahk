; Example code
#SingleInstance force
#include SockPuppet.ahk

ms := new MySlave()
return

GuiClose:
	ExitApp

class MySlave extends SockSlave {
	__New(){
		base.__New()
		
		port := 12345

		; Initialize listener and set callback
		this.listener := new SockListener(this.MessageReceived.Bind(this), "addr_any", port)
	}
	
	; Callback was fired - message came in.
	MessageReceived(socket){
		newTcp := socket.accept()
		text := newTcp.recvText()
		msg := JSON.Load(text)
		Gui, ListView, % this.hLVIncoming
		LV_Add(, msg.ComputerName, msg.type, msg.command)
		response := new this.Ack()
		response.command := "As you wish, master"
		Gui, ListView, % this.hLVOutgoing
		LV_Add(, msg.ComputerName, response.type, response.command)
		newTcp.sendText(JSON.Dump(response))
		
	}
}

; Library code ================================
class SockSlave extends SockBase {
	__New(){
		this.CreateGui("x330 y0", "s")
	}
	
}
