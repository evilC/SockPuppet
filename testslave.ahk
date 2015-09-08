#SingleInstance force
#MaxThreadsPerHotkey 1000
#include <Socket>

s := new Slave()

class Slave {
	__New(){
		this.mode := 0	; I want to be able to set this.mode := 1. Why does it not work in this mode?
		fn := this.Test.Bind(this)
		hotkey, F11, % fn
		
		myTcp := new SocketTCP()
		myTcp.bind("addr_any", 12345)
		myTcp.listen()
		myTcp.onAccept := this.OnTCPAccept.Bind(this, myTcp)
	}

	Test(){
		if (this.mode){
			OutputDebug % "SLAVE SIMULATING PROCESSING"
			Sleep 2000		; Doesn't work. Why is this different to the SetTimer being on 2 sec?
		}
		; Fire back "Job Complete" message
		myTcp := new SocketTCP()
		myTcp.connect("localhost", 12346)	; different port for reply
		myTcp.sendText("DidSomething")
		OutputDebug, % "SLAVE GOT REPLY: " myTcp.recvText()
	}
	
	OnTCPAccept(myTcp){
		newTcp := myTcp.accept()
		OutputDebug, % "SLAVE GOT MESSAGE: " newTcp.recvText()
		OutputDebug, % "SLAVE SENDING ACK"
		newTcp.sendText("Ack")
		
		if (this.mode){
			t := "-0"
		} else {
			t := "-2000"
		}
		fn := this.Test.Bind(this)
		SetTimer, % fn, % t	; Works. Why can this not be fired immediately, and a Sleep in Test() create the delay?
		;SetTimer, % fn, -0
	}
}