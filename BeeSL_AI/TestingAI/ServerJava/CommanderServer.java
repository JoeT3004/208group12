package ServerJava;

import java.io.*;
import java.net.*;
//Password TELLO-F1D894
class CommanderServer {
	public static void main(String args[]) throws Exception {
        String ip =  "192.168.10.1";
        String ipServere =  "0.0.0.0";

        int senderPort = 8889;
        int serverPort = 8890;
        int streamport = 11111;
		
        SendCommand sender = new SendCommand(senderPort, ip);
        //UDP_Server server = new UDP_Server(serverPort, ipServere);
        //VideoStream stream = new VideoStream(streamport, ipServere);

        sender.start();
        //server.start(); 
        //stream.start();

	}
}