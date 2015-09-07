; Example code
#SingleInstance force
#include SockPuppet.ahk

ms := new MySlave()
return

GuiClose:
	ExitApp

class MySlave extends SockSlave {
	ProcessJob(original_msg){
		Sleep 1000 ; simulate processing of job
		talker := new SockTalker(original_msg.IPAddress, this.port+1)
		delayed := new this.Message()
		delayed.command := "DELAYED"
		replytext := talker.Send(JSON.Dump(delayed))
	}
}

; Library code ================================
class SockSlave extends SockBase {
	__New(){
		this.CreateGui("x330 y0", "s")
		this.port := 12345

		; Initialize listener and set callback
		this.listener := new SockListener(this.MessageReceived.Bind(this), "addr_any", this.port)
	}
	
	; Callback was fired - message came in.
	MessageReceived(socket){
		newTcp := socket.accept()
		text := newTcp.recvText()
		msg := JSON.Load(text)
		Gui, ListView, % this.hLVIncoming
		LV_Add(, msg.command)
		response := new this.Message()
		response.command := "As you wish, master"
		Gui, ListView, % this.hLVOutgoing
		LV_Add(, response.command)
		newTcp.sendText(JSON.Dump(response))
		
		fn := this.ProcessJob.Bind(this, msg)
		SetTimer, % fn, -0	; fire off asynch thread
	}
}
