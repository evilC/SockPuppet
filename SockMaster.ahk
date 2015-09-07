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
	}
		
	; Test code to fire a message off
	Test(){
		msg := new this.Message()
		msg.command := "Slave, Do something for me"
		replytext := this.talker.Send(JSON.Dump(msg))
		reply := JSON.Load(replytext)
		LV_Add(,msg.command, reply.command)
	}
}
