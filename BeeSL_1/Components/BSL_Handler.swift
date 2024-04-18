//
//  BSL_Handler.swift
//  BeeSL_1
//
//  Created by Browning, on 12/04/2024.
//

import Foundation
import Socket

class BSL_Handler {
    let IP = "127.0.0.1"
    let port: Int32 = 9999
    
    var socket: Socket?
    
    var session_Type: String
    var working: Bool
    init(session_Type_param: String){
        do{
            session_Type = session_Type_param
            socket = try Socket.create()
            print("testing")
            print(IP)
            print(port)
            if let working_Socket = socket{
                try working_Socket.connect(to: "127.0.0.1", port: 9999, timeout: 10)
            }
            else {
                working = false
            }
           
            print("WOrkig SocketNull")
            if(session_Type == "Action")
            {
                working = true
                Setup_Action()
            }
            else if(session_Type == "Static")
            {
                working = true
                Setup_Static()
            }
            else {
                working = false
                print("error occured when setting up socket1?")
            }
            
        } catch let error {
            working = false
            print(error)
            print("error occured when setting up socket2?")
                socket = nil
            
        }
        
    }
    
    func Setup_Static(){
        
        do{
            if let working_Socket = socket{
                var first_message_data = "Static".data(using: .utf8)!
                try working_Socket.write(from:first_message_data)
                try working_Socket.read(into:&first_message_data)
            }
            else {
                print("SocketNull")
            }
            
        }catch{}
    }
    func Setup_Action(){
        do{
            if let working_Socket = socket{
                var first_message_data = "Action".data(using: .utf8)!
                try working_Socket.write(from:first_message_data)
                var setup_response = try working_Socket.readString()
                print(setup_response)
            }
            else {
                print("SocketNull")
            }
            
        }catch{}
    }
    
    func end(){
        do{
            if let working_Socket = socket{
                var gesture = "end"
                var message_data = gesture.data(using: .utf8)!
                try working_Socket.write(from:message_data)
                print("end")
            }
            else {
                print("SocketNull")
            }
            
        }catch{}
    }
    
    func check_Gesture(gesture: String) -> String{
        do{
            if let working_Socket = socket{
                var message_data = gesture.data(using: .utf8)!
                try working_Socket.write(from:message_data)
                print("gesture " + gesture)
                var Recmessage_data = gesture.data(using: .utf8)!
                var recieved_string: String?
                recieved_string =  try working_Socket.readString()
                if(recieved_string == nil)
                {
                    return "Error"
                    //NOT WORKING ERROR THROW
                }
                else if(recieved_string == "C")
                {
                    //Correct sign
                    return "Correct"
                }
                else if(recieved_string == "F")
                {
                    return "False"
                    //False sign
                }
                
            }
            else {
                return "Error"
                
            }
            
        } catch {
            return "Error"
            
        }
        return "Error"
    }
}


