package Testing;

import java.io.*;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.util.Arrays;

import java.awt.image.BufferedImage;

public class VideoStream extends Thread{

   DatagramSocket serverSocket  = null;
	private InetAddress ip = null;
    private int port = 0;

	public VideoStream(int cPort, String cIP)
    {
		this.port = cPort;
        try {
            this.ip = InetAddress.getByName(cIP);
			this.serverSocket = new DatagramSocket(port,ip);
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
            
            //String sentence = new String(receivePacket.getData());
            //System.out.println(sentence);
            yeet = false;
            
            
            byte[] imageBytes = Arrays.copyOf(receivePacket.getData(),receivePacket.getData().length);
           
            ServerSocket server = new ServerSocket(5000);
            
           
        }
    }

}
