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
		this.Socket := new SocketTCP()
		this.Socket.bind(address, port)
		this.Socket.listen()
		this.Socket.onAccept := this.OnTCPAccept.Bind(this)
	}
	
	; Connection came in, fire callback
	OnTCPAccept(){
	  this.callback.(this.Socket)
	}
}

; Base class to inherit useful stuff from
class SockBase {
	; Send a Message, return the response
	Send(message){
		this.Socket := new SocketTCP()
		this.Socket.connect(this.address, this.port)
		this.Socket.sendText(message)
		return this.Socket.recvText()
	}
	
	; Message classes. Designed to be serialized to JSON
	Class Message {
		ComputerName := A_ComputerName
		IPAddress := A_IPAddress1
		__New(){
			this.TimeStamp := A_TickCount
		}
	}
	
	CreateGui(options, type){
		static seq := {m: ["o", "i"], s: ["i", "o"]}
		Loop 2 {
			if(seq[type,A_Index] = "i"){
				Gui, Add, Text, w300 Center, Incoming Messages
				Gui, Add, ListView, w300 h200 xm hwndhLVIncoming, A|B
				this.hLVIncoming := hLVIncoming
			} else if(seq[type,A_Index] = "o"){
				Gui, Add, Text, w300 Center, Outgoing Messages
				Gui, Add, ListView, w300 h200 xm hwndhLVOutgoing, C|D
				this.hLVOutgoing := hLVOutgoing
			}
			added++
			LV_ModifyCol(1,140)
			LV_ModifyCol(2,140)
		}
		Gui, Add, Button, w300 hwndhwnd, Clear
		fn := this.Clear.Bind(this)
		GuiControl +g, % hwnd, % fn
		Gui, Show, % options
	}
	
	Clear(){
		LV_Delete()
	}

}
