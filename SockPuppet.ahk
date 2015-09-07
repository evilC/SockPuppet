#include <Socket>		; http://www.autohotkey.com/board/topic/94376-socket-class-%C3%BCberarbeitet/
#include <JSON>			; http://ahkscript.org/boards/viewtopic.php?t=627

class SockTalker extends SockBase {
	__New(address := "localhost", port := 12345){
		this.address := address
		this.port := port
	}
	
	Send(message){
		this.myTcp := new SocketTCP()
		this.myTcp.connect(this.address, this.port)
		this.myTcp.sendText(message)
		return this.myTcp.recvText()
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
