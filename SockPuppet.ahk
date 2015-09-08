#include <Socket>		; http://www.autohotkey.com/board/topic/94376-socket-class-%C3%BCberarbeitet/
#include <JSON>			; http://ahkscript.org/boards/viewtopic.php?t=627
#include <Attach>		; https://code.google.com/p/mm-autohotkey/source/browse/trunk/Form/inc/Attach.ahk

SockVersion := "1.0"

; A Talker sends out a message, and waits for a response
class SockTalker extends SockBase {
	__New(address := "localhost", port := 12345){
		this.address := address
		this.port := port
	}
	
}

; A Listener listens for messages and sends a response
class SockListener extends SockBase {
	__New(callback, address := "addr_any", port := 12345){
		this.callback := callback
		Socket := new SocketTCP()
		Socket.bind(address, port)
		Socket.listen()
		Socket.onAccept := this.OnTCPAccept.Bind(this, socket)
	}
	
	; Connection came in, fire callback
	OnTCPAccept(socket){
	  this.callback.(Socket)
	}
	
}

; Base class to inherit useful stuff from
class SockBase {
	Class Job extends SockBase {
		__New(original_message){
			;return
			; Perform task and report back
			;Sleep 1000
			fn := this.DoJob.Bind(this, original_message)
			SetTimer, % fn, -0
		}
		
		DoJob(original_message){
			talker := new SockTalker(original_message.ComputerName, 12346)
			msg := new this.message()
			msg.message := "TEST"
			replytext := talker.Send(JSON.Dump(msg))
		}
	}
	
	; Send a Message, return the response
	Send(message){
		Socket := new SocketTCP()
		Socket.connect(this.address, this.port)
		Socket.sendText(message)
		return Socket.recvText()
	}
	
	; Message classes. Designed to be serialized to JSON
	Class Message {
		type := "None"
		ComputerName := A_ComputerName
		IPAddress := A_IPAddress1
		__New(){
			this.TimeStamp := A_TickCount
		}
	}

	Class AckMessage extends SockBase.Message {
		type := "Ack"
	}
	
	Class FailMessage extends SockBase.Message {
		type := "Fail"
	}
	
	Class JobMessage extends SockBase.Message {
		type := "Job"
	}

	CreateGui(options, type){
		global SockVersion
		static seq := {m: ["o", "i"], s: ["i", "o"]}
		static names := {m: "Sock Master", s: "Sock Slave"}
		Gui +Resize
		Loop 2 {
			if(seq[type,A_Index] = "i"){
				Gui, Add, Text, w400 Center hwndhLabIncoming, Incoming Messages
				this.hLabIncoming := hLabIncoming
				Gui, Add, ListView, w400 h200 xm hwndhLVIncoming, From|Type|Message|Params
				this.hLVIncoming := hLVIncoming
			} else if(seq[type,A_Index] = "o"){
				Gui, Add, Text, w400 Center hwndhLabOutgoing, Outgoing Messages
				this.hLabOutgoing := hLabOutgoing
				Gui, Add, ListView, w400 h200 xm hwndhLVOutgoing, To|Type|Message|Params
				this.hLVOutgoing := hLVOutgoing
			}
			added++
			LV_ModifyCol(1,80)
			LV_ModifyCol(2,50)
			LV_ModifyCol(3,75)
			LV_ModifyCol(4,175)
		}
		Gui, Add, Button, w400 hwndhwnd, Clear
		this.hBtnClear := hwnd
		fn := this.Clear.Bind(this)
		GuiControl +g, % hwnd, % fn
		Gui, Show, % options, % names[type] "  ( SockPuppet v" SockVersion " )"
		if (type = "m"){
			Attach(this.hLabIncoming, "w y.5")
			Attach(this.hLVOutgoing, "w h.5")
			Attach(this.hLVIncoming, "w h.5 y.5")
		} else {
			Attach(this.hLabOutgoing, "w y.5")
			Attach(this.hLVIncoming, "w h.5")
			Attach(this.hLVOutgoing, "w y.5 h.5")
		}
		Attach(this.hBtnClear, "y w")

	}
	
	Clear(){
		Gui, ListView, % this.hLVOutgoing
		LV_Delete()
		Gui, ListView, % this.hLVIncoming
		LV_Delete()
	}

}
