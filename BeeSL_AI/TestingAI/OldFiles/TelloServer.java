import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Scanner;
import java.net.*;
import java.io.*;

import javax.print.DocFlavor.SERVICE_FORMATTED;
import javax.sound.sampled.Port;


public class TelloServer extends Thread {

    private DatagramSocket socket;
    private boolean running;
    private byte[] buf = new byte[256];
    private int port;

    public TelloServer(int cport) throws SocketException {
        socket = new DatagramSocket(cport);
        port = cport;
    }

    public void run(){
        running = true;
        int counter = 1;

        while (running) {
            buf = new byte[256];
            DatagramPacket packet 
              = new DatagramPacket(buf, buf.length);
            try {
                socket.receive(packet);
            } catch (IOException e) {
                // TODO Auto-generated catch block
                System.out.println("Server connection not worked on rec port " + port);
            }
            
            InetAddress address = packet.getAddress();
            int port = packet.getPort();
            String received 
            = new String(packet.getData(), 0, packet.getLength());
            packet = new DatagramPacket(buf, buf.length, address, port);
        
            if (received.equals("end")) {
                running = false;
                continue;
            }
            System.out.println(received);
          
            String messageback = "message back " + counter;
            counter++;
            buf = messageback.getBytes();
            packet = new DatagramPacket(buf, buf.length, address, port);
            try {
                socket.send(packet);
            } catch (IOException e) {
                // TODO Auto-generated catch block
                System.out.println("Server connection not worked on send port " + port);
            }
        }
        socket.close();
    }
}