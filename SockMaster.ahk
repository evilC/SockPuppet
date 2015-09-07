#SingleInstance force
#include SockPuppet.ahk

sm := new SockMaster()

class SockMaster extends SockBase {
	__New(){
		this.CreateGui("x0 y0", "Command|Response")
		; Bind Test Hotkey
		fn := this.Test.Bind(this)
		hotkey, F12, % fn

		; Initialize connection settings etc
		this.talker := new SockTalker("localhost", 12345)
		this.listener := new SockListener(this.MessageReceived.Bind(this), "addr_any", 12346)
	}
		
	; Test code to fire a message off
	Test(){
		msg := new this.Message()
		msg.command := "Slave, Do something for me"
		replytext := this.talker.Send(JSON.Dump(msg))
		reply := JSON.Load(replytext)
		LV_Add(,msg.command, reply.command)
	}
	
	; An Incoming message happened - eg a delayed "I have completed all tasks, here are the results" message
	MessageReceived(socket){
		newTcp := socket.accept()
		text := newTcp.recvText()
		msg := JSON.Load(text)
		LV_Add(,msg.command, reply.command)
	}
}
