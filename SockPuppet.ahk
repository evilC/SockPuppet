#include <Socket>		; http://www.autohotkey.com/board/topic/94376-socket-class-%C3%BCberarbeitet/
;#include <JSON>			; http://ahkscript.org/boards/viewtopic.php?t=627

class SockTalker {
	Send(){
		myTcp := new SocketTCP()
		myTcp.connect("localhost", 12345)
		myTcp.sendText("Slave, do something for me")
		MsgBox, % "MASTER: " myTcp.recvText()
		return
	}
}

class SockListener {
	__New(){
		this.myTcp := new SocketTCP()
		this.myTcp.bind("addr_any", 12345)
		this.myTcp.listen()
		;this.myTcp.onAccept := Func("OnTCPAccept")
		this.myTcp.onAccept := this.OnTCPAccept.Bind(this)
	}
	
	OnTCPAccept(){
	  newTcp := this.myTcp.accept()
	  MsgBox, % "SLAVE: " newTcp.recvText()
	  newTcp.sendText("As you wish, master")
	  return
	}
}
