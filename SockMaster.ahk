#SingleInstance force
#include SockPuppet.ahk

sm := new SockMaster()

class SockMaster {
	__New(){
		; Bind Test Hotkey
		fn := this.Test.Bind(this)
		hotkey, F12, % fn

		this.talker := new SockTalker()
	}
	
	Test(){
		reply := this.talker.Send("Slave, do something for me")
		MsgBox, % "MASTER: " reply
	}
}
