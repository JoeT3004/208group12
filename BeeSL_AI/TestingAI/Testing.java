import java.io.*;
import java.net.*;

class UDPServer {
	public static void main(String args[]) throws Exception {
		
		// create data-gram socket at port 9876
		DatagramSocket serverSocket = new DatagramSocket(9876);
		
		byte[] receiveData = new byte[1024];
		byte[] sendData = new byte[1024];
		
		while(true) {
			
			// create space for received data-gram
			DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
			// receive data-gram
			serverSocket.receive(receivePacket);
			
			String sentence = new String(receivePacket.getData());
			
			// get IP address and port of sender
			InetAddress IPAddress = receivePacket.getAddress();
			int port = receivePacket.getPort();
			
			String capitalisedSentence = sentence.toUpperCase();
			
			sendData = capitalisedSentence.getBytes();
			
			// create data-gram to send to client
			DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);
			
			// write out data-gram to socket
			serverSocket.send(sendPacket);
		}
	}
}