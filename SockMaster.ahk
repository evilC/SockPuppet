#SingleInstance force
#include SockPuppet.ahk

sm := new SockMaster()

class SockMaster {
	__New(){
		this.talker := new SockTalker()
		fn := this.Test.Bind(this)
		hotkey, F12, % fn
	}
	
	Test(){
		this.talker.Send()
	}
}
