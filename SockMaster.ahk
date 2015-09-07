#SingleInstance force
#include SockPuppet.ahk

sm := new SockMaster()

class SockMaster extends SockBase {
	__New(){
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
		reply := this.talker.Send(JSON.Dump(msg))
		MsgBox, % "MASTER received message:`n" reply
	}
}
