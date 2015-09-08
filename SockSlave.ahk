; Example code
#SingleInstance force
#include SockPuppet.ahk

ms := new MySlave()
return

GuiClose:
	ExitApp

class MySlave extends SockSlave {
	__New(){
		base.__New()
		
		port := 12345

		; Initialize listener and set callback
		this.listener := new SockListener(this.MessageReceived.Bind(this), "addr_any", port)
	}
	
	; Callback was fired - message came in.
	MessageReceived(socket){
		newTcp := socket.accept()
		text := newTcp.recvText()
		msg := JSON.Load(text)
		Gui, ListView, % this.hLVIncoming
		LV_Add(, msg.ComputerName, msg.type, msg.message, JSON.Dump(msg.params))
		
		
		;fn := this.ProcessMessage.Bind(this, msg)
		fn := this.ProcessMessage.Bind(this, newTcp, msg)
		SetTimer, % fn, -0
		
	}
	
	ProcessMessage(newTcp, msg){
		reload := 0
		if (!ObjHasKey(msg, "message")){
			response := new this.FailMessage()
			response.message := "No message Specified"
		}
		
		if (msg.message = "Reload"){
			; Restart the script
			response := new this.AckMessage()
			response.message := "OK"
			reload := 1
		} else if (msg.message = "Update"){
			; Pull new files from share, reload
			filesexist := 0
			;IfExist, % msg.path
			IfExist, % msg.params[1]
			{
				;FileCopy, % msg.path, ., 1
				FileCopy, % msg.params[1], ., 1
				filesexist := 1
			}
			if (!filesexist){
				response := new this.FailMessage()
				;response.message := "Could not find " msg.path
				response.message := "Could not find " msg.params[1]
			} else if (ErrorLevel){
				response := new this.FailMessage()
				response.message := ErrorLevel " files failed to copy"
			} else {
				response := new this.AckMessage()
				response.message := msg.message " OK"
				reload := 1
			}
		} else if (msg.message = "Copy"){
			filesexist := 0
			;IfExist, % msg.path
			IfExist, % msg.params[1]
			{
				;FileCopy, % msg.path, % msg.destination, 1
				FileCopy, % msg.params[1], % msg.params[2], 1
				filesexist := 1
			}
			if (!filesexist){
				response := new this.FailMessage()
				;response.message := "Could not find " msg.path
				response.message := "Could not find " msg.params[1]
			} else if (ErrorLevel){
				response := new this.FailMessage()
				response.message := ErrorLevel " files failed to copy"
			} else {
				response := new this.AckMessage()
				response.message := msg.message " OK"
			}
			
		} else if (msg.message = "Run"){
			;Run, % msg.path
			Run, % msg.params[1]
			if (ErrorLevel){
				response := new this.FailMessage()
				;response.message := "File " msg.path " failed to run"
				response.message := "File " msg.params[1] " failed to run"
			} else {
				response := new this.AckMessage()
				response.message := msg.message " OK"
			}
		} else {
			response := new this.FailMessage()
			response.message := "Unknown Command: " msg.message
		}
		Gui, ListView, % this.hLVOutgoing
		response.params := msg.params
		LV_Add(, msg.ComputerName, response.type, response.message, JSON.Dump(response.params))
		newTcp.sendText(JSON.Dump(response))
		if (reload){
			newTcp.__Delete()
			Reload
		}

		/*
		;this.Jobs.push(new this.Job(msg))
		talker := new SockTalker(msg.ComputerName, 12346)
		msg := new this.message()
		msg.message := "TEST"
		replytext := talker.Send(JSON.Dump(msg))
		talker.disconnect()
		*/
	}
}

; Library code ================================
class SockSlave extends SockBase {
	Jobs := []
	__New(){
		this.CreateGui("x0 y0", "s")
	}
	
}
