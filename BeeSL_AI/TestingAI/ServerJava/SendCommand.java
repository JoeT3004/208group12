package ServerJava;

import java.io.*;
import java.net.*;

public class SendCommand extends Thread {
    private static int commandNumber = 0;
    private int port = 0;
    public SendCommand(int cPort, String cIp)
    {       
        this.port = cPort;
        
    }
    @Override
    public void run()
    {
        try {
            System.out.println(UDPSend("command"));
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

        notifyAll();

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in) );
        while(true)
        {           
            String command;

            try {
                command = br.readLine();                
                System.out.println(UDPSend(command));
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    public String UDPSend(String command) throws IOException
    {
        System.out.println(command + "   Num: " + commandNumber);

        // create client socket
		DatagramSocket clientSocket = new DatagramSocket(port, ip);
		
		byte[] sendData = new byte[1024]; // message limited to 1024 characters
		byte[] receiveData = new byte[1024];
		
		// convert string to byte array
		sendData = command.getBytes();
		
		// create data-gram with data to send, length, IP address and port
		DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length);
		
		// send data-gram to server
		clientSocket.send(sendPacket);
		
		DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
		
		// read data-gram from server
		clientSocket.receive(receivePacket);
		
		// extract data from packet
		String responseCode  = new String(receivePacket.getData());
		
		System.out.println("FROM SERVER:" + responseCode);
		clientSocket.close();

        return responseCode;
    }
}
