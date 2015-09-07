#SingleInstance force
#include SockPuppet.ahk

ss := new SockSlave()

class SockSlave extends SockBase {
	__New(){
		this.CreateGui("x330 y0", "Command|Response")
		this.port := 12345

		; Initialize listener and set callback
		this.listener := new SockListener(this.MessageReceived.Bind(this), "addr_any", this.port)
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
		
		fn := this.ProcessJob.Bind(this, msg)
		SetTimer, % fn, -0	; fire off "thead"
	}
	
	ProcessJob(original_msg){
		Sleep 1000 ; simulate processing of job
		talker := new SockTalker(original_msg.IPAddress, this.port+1)
		delayed := new this.Message()
		delayed.command := "DELAYED"
		replytext := talker.Send(JSON.Dump(delayed))
	}
}
