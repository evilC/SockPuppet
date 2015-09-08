; Example code
#SingleInstance force
#include SockPuppet.ahk
#MaxThreadsPerHotkey 1000

mm := new MyMaster()
return

GuiClose:
	ExitApp
	
class MyMaster extends SockMaster {
	__New(){
		IniRead, updatepath, sockmaster.ini, Settings, updatepath
		this.UpdatePath := updatepath
		IniRead, slaveaddress, sockmaster.ini, Settings, slaveaddress
		this.SlaveAddress := slaveaddress
		
		base.__New(aParams*)
		; Bind Test Hotkey
		fn := this.Test.Bind(this)
		hotkey, F12, % fn
		
		fn := this.RemoteUpdate.Bind(this)
		hotkey, F11, % fn
				
		this.talker := new SockTalker(this.SlaveAddress, 12345)
		;this.listener := new SockListener(this.MessageReceived.Bind(this), "addr_any", 12346)
	}
	
	; Test code to fire a message off
	Test(){
		msg := new this.JobMessage()
		msg.message := "Run"
		msg.path := "IExplore.exe"
		this.UpdateListViews(msg)
	}
	
	; Tell the Slave to grab new copy of script and restart
	RemoteUpdate(){
		msg := new this.JobMessage()
		msg.message := "Update"
		msg.path := this.UpdatePath
		this.UpdateListViews(msg)
	}
	
	UpdateListViews(msg){
		Gui, ListView, % this.hLVOutgoing
		LV_Add(, this.talker.address, msg.type, msg.message)
		replytext := this.talker.Send(JSON.Dump(msg))
		reply := JSON.Load(replytext)
		Gui, ListView, % this.hLVIncoming
		LV_Add(,reply.ComputerName, reply.type, reply.message)
	}
	
	/*
	MessageReceived(socket){
		newTcp := socket.accept()
		text := newTcp.recvText()
		message := JSON.Load(text)
		
		response := new this.AckMessage()
		response.message := "Thankyou"
		Gui, ListView, % this.hLVOutgoing
		LV_Add(, message.ComputerName, response.type, response.message)
		newTcp.sendText(JSON.Dump(response))
		
		Gui, ListView, % this.hLVIncoming
		LV_Add(,message.ComputerName, reply.type, message.message)
	}
	*/
}

; Library code ===========================================================
class SockMaster extends SockBase {
	__New(){
		this.CreateGui("x0 y0", "m")
	}
}
