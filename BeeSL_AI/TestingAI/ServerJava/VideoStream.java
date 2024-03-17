package ServerJava;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

public class VideoStream extends Thread{

   DatagramSocket serverSocket  = null;
    private int port = 0;

	public VideoStream(int cPort, String cIP)
    {
		this.port = cPort;
        try {
			this.serverSocket = new DatagramSocket(port);
            System.out.println(("VideoSteam working "));
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
        
        while(true) {
            
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
            
        }
    }

}
