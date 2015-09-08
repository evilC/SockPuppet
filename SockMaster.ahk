; Example code
#SingleInstance force
#include SockPuppet.ahk

mm := new MyMaster()
return

GuiClose:
	ExitApp
	
class MyMaster extends SockMaster {
	__New(){
		base.__New(aPrams*)
		; Bind Test Hotkey
		fn := this.Test.Bind(this)
		hotkey, F12, % fn
		this.address := "VSLM-8147-46ef4c57-3eb4-4e96-8f1a-25476653e416.dcsl.local"
		this.talker := new SockTalker(this.address, 12345)
		this.listener := new SockListener(this.MessageReceived.Bind(this), "addr_any", 12346)
	}
	
	; Test code to fire a message off
	Test(){
		msg := new this.Message()
		msg.command := "Slave, Do something for me"
		Gui, ListView, % this.hLVOutgoing
		LV_Add(, this.address,msg.command)
		replytext := this.talker.Send(JSON.Dump(msg))
		reply := JSON.Load(replytext)
		Gui, ListView, % this.hLVIncoming
		LV_Add(,reply.ComputerName,reply.command)
	}
}

; Library code ===========================================================
class SockMaster extends SockBase {
	__New(){
		this.CreateGui("x0 y0", "m")

		; Initialize connection settings etc
	}
		
	; An Incoming message happened - eg a delayed "I have completed all tasks, here are the results" message
	MessageReceived(socket){
		newTcp := socket.accept()
		text := newTcp.recvText()
		msg := JSON.Load(text)
		LV_Add(,msg.ComputerName, msg.command)
		newTcp.sendText(msg)
	}
}
