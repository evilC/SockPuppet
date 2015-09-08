#include <Socket>		; http://www.autohotkey.com/board/topic/94376-socket-class-%C3%BCberarbeitet/
#include <JSON>			; http://ahkscript.org/boards/viewtopic.php?t=627

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
		static seq := {m: ["o", "i"], s: ["i", "o"]}
		Loop 2 {
			if(seq[type,A_Index] = "i"){
				Gui, Add, Text, w300 Center, Incoming Messages
				Gui, Add, ListView, w300 h200 xm hwndhLVIncoming, From|Type|Message
				this.hLVIncoming := hLVIncoming
			} else if(seq[type,A_Index] = "o"){
				Gui, Add, Text, w300 Center, Outgoing Messages
				Gui, Add, ListView, w300 h200 xm hwndhLVOutgoing, To|Type|Message
				this.hLVOutgoing := hLVOutgoing
			}
			added++
			LV_ModifyCol(1,80)
			LV_ModifyCol(2,50)
			LV_ModifyCol(3,150)
		}
		Gui, Add, Button, w300 hwndhwnd, Clear
		fn := this.Clear.Bind(this)
		GuiControl +g, % hwnd, % fn
		Gui, Show, % options
	}
	
	Clear(){
		Gui, ListView, % this.hLVOutgoing
		LV_Delete()
		Gui, ListView, % this.hLVIncoming
		LV_Delete()
	}

}
