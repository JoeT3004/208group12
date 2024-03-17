package Testing;

import java.io.*;
import java.net.*;

public class SetUp extends Thread {
    private static int commandNumber = 0;
    private InetAddress ip = null;
    private int port = 0;

    /*
    public static void main(String args[]) throws Exception {

         String ip =  "192.168.10.1";
                String ipServere =  "0.0.0.0";

                int senderPort = 8889;
                int serverPort = 8890;
                int streamport = 11111;
         
        String command = "command";
        System.out.println(command + "   Num: " + commandNumber);

        
        InetAddress ip =  InetAddress.getByName("192.168.10.1");
        InetAddress Hostip =  InetAddress.getLocalHost();


        
        int port = 8889;
        // create client socket


        DatagramSocket clientSocket = new DatagramSocket();


		
		byte[] sendData = new byte[1024]; // message limited to 1024 characters
		byte[] receiveData = new byte[1024];
		
		// convert string to byte array
		sendData = command.getBytes();
		
		// create data-gram with data to send, length, IP address and port
		DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, ip, port);
        
		
		// send data-gram to server
        System.out.println("yeet");
		clientSocket.send(sendPacket);

        DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
		
		// read data-gram from server
		clientSocket.receive(receivePacket);
        String responseCode  = new String(receivePacket.getData());
		System.out.println("FROM SERVER:" + responseCode);

		System.out.println("has Rec");

		System.out.println("has sent " + command);

        
        command = "speed?";
        sendData = command.getBytes();
		
		// create data-gram with data to send, length, IP address and port
		sendPacket = new DatagramPacket(sendData, sendData.length, ip, port);
        
		
		// send data-gram to server
        System.out.println("yeet");
		clientSocket.send(sendPacket);

        receivePacket = new DatagramPacket(receiveData, receiveData.length);
		
		// read data-gram from server
		clientSocket.receive(receivePacket);
        responseCode  = new String(receivePacket.getData());
		
		System.out.println("FROM SERVER:" + responseCode);
		System.out.println("has Rec");
        
    }
    */


    private DatagramSocket clientSocket;
    public SetUp(int cPort, String cIp) throws SocketException
    {       
        this.port = cPort;
        try {
         this.ip = InetAddress.getByName(cIp);

             //this.ip = InetAddress.getLocalHost();
             
             System.out.println(ip.getHostAddress());
              clientSocket = new DatagramSocket();
        } catch (UnknownHostException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    @Override
    public void run()
    {
        
        try {
            SendCommand();
            //System.out.println(UDPSend("Command"));
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        try {
            System.out.println(UDPSend("streamon"));
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void SendCommand() throws IOException
    {
        String command = "command";
        System.out.println(command + "   Num: " + commandNumber);

        // create client socket 
		
		byte[] sendData = new byte[1024]; // message limited to 1024 characters
		byte[] receiveData = new byte[1024];
		
		// convert string to byte array
		sendData = command.getBytes();
		
		// create data-gram with data to send, length, IP address and port
		DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, ip, port);
        
		
		// send data-gram to server
        System.out.println("yeet");
		clientSocket.send(sendPacket);

        DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
		
        clientSocket.setSoTimeout(1000);
        try {
            
		// read data-gram from server
		clientSocket.receive(receivePacket);
        String responseCode  = new String(receivePacket.getData());
		
		System.out.println("FROM SERVER:" + responseCode);
		System.out.println("has Rec");
        } catch (Exception e) {
            System.out.println("timeout Reached ");
            // TODO: handle exception
        }




        
    }

    public String UDPSend(String command) throws IOException
    {
        System.out.println(command + "   Num: " + commandNumber);

        // create client socket
		
		byte[] sendData = new byte[1024]; // message limited to 1024 characters
		byte[] receiveData = new byte[1024];
		
		// convert string to byte array
		sendData = command.getBytes();
		
		// create data-gram with data to send, length, IP address and port
		DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, ip, port);
		
		// send data-gram to server
		clientSocket.send(sendPacket);
		System.out.println("has sent");
        
        
        
		DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
		
        clientSocket.setSoTimeout(1000);
        String responseCode="";
        try {
            
		// read data-gram from server
		clientSocket.receive(receivePacket);
         responseCode  = new String(receivePacket.getData());
		
		System.out.println("FROM SERVER:" + responseCode);
		
        } catch (Exception e) {
            System.out.println("timeout Reached ");
            // TODO: handle exception
        }
        
       // String responseCode = "";
        return responseCode;
    }
}
