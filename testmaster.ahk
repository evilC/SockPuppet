#SingleInstance force
#MaxThreadsPerHotkey 1000
#include <Socket>

OutputDebug DBGVIEWCLEAR

;Client
m := new Master()

class Master {
	__New(){
		fn := this.Test.Bind(this)
		hotkey, F12, % fn
		
		myTcp := new SocketTCP()
		myTcp.bind("addr_any", 12346)
		myTcp.listen()
		myTcp.onAccept := this.OnTCPAccept.Bind(this, myTcp)
	}
	
	Test(){
		msg := "DoSomething"
		OutputDebug % "MASTER SENDING MESSAGE: " msg
		myTcp := new SocketTCP()
		myTcp.connect("localhost", 12345)
		myTcp.sendText(msg)
		OutputDebug, % "MASTER GOT REPLY: " myTcp.recvText()
	}
	
	OnTCPAccept(myTcp){
		newTcp := myTcp.accept()
		OutputDebug, % "MASTER GOT MESSAGE: " newTcp.recvText()
		OutputDebug, % "MASTER SENDING ACK"
		newTcp.sendText("Ack")
	}
}
