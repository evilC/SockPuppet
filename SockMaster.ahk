; Example code
#SingleInstance force
#include SockPuppet.ahk

mm := new MyMaster()
return

GuiClose:
	ExitApp
	
class MyMaster extends SockMaster {
	__New(){
		base.__New(aParams*)
		; Bind Test Hotkey
		fn := this.Test.Bind(this)
		hotkey, F12, % fn
		address := "VSLM-8147-46ef4c57-3eb4-4e96-8f1a-25476653e416.dcsl.local"
		this.talker := new SockTalker(address, 12345)
	}
	
	; Test code to fire a message off
	Test(){
		msg := new this.Job()
		msg.command := "Slave, Do something for me"
		Gui, ListView, % this.hLVOutgoing
		LV_Add(, this.talker.address, msg.type, msg.command)
		replytext := this.talker.Send(JSON.Dump(msg))
		reply := JSON.Load(replytext)
		Gui, ListView, % this.hLVIncoming
		LV_Add(,reply.ComputerName, reply.type, reply.command)
	}
}

; Library code ===========================================================
class SockMaster extends SockBase {
	__New(){
		this.CreateGui("x0 y0", "m")
	}
}
