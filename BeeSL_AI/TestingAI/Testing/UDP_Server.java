package Testing;

import java.io.*;
import java.net.*;

class UDP_Server extends Thread{
    DatagramSocket serverSocket  = null;
	private InetAddress ip = null;
    private int port = 0;
	public UDP_Server(int cPort, String cIP)
    {
		this.port = cPort;

		


        try {
            this.ip = InetAddress.getByName(cIP);
			this.serverSocket = new DatagramSocket(port,ip);
			System.out.println("Server Working");
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    @Override
    public void run()
    {
        
		byte[] receiveData = new byte[1024];
		byte[] sendData = new byte[1024];
		boolean yeet = true;
		while(yeet) {
			
			// create space for received data-gram
			DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
			// receive data-gram
			try {
				serverSocket.receive(receivePacket);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			String sentence = new String(receivePacket.getData());
            System.out.println(sentence);
			yeet = false;	
		}
    }
}