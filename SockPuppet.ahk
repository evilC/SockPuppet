#include <Socket>		; http://www.autohotkey.com/board/topic/94376-socket-class-%C3%BCberarbeitet/
#include <JSON>			; http://ahkscript.org/boards/viewtopic.php?t=627

class SockTalker extends SockBase {
	Send(message){
		myTcp := new SocketTCP()
		myTcp.connect("localhost", 12345)
		myTcp.sendText(message)
		return myTcp.recvText()
	}
}

class SockListener extends SockBase {
	__New(callback, address := "addr_any", port := 12345){
		this.callback := callback
		this.myTcp := new SocketTCP()
		this.myTcp.bind(address, port)
		this.myTcp.listen()
		this.myTcp.onAccept := this.OnTCPAccept.Bind(this)
	}
	
	OnTCPAccept(){
	  this.callback.(this.myTcp)
	}
}

class SockBase {
	Class Message {
		ComputerName := A_ComputerName
		__New(){
			this.TimeStamp := A_TickCount
		}
	}
}
