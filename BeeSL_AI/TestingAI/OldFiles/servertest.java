import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.Scanner;
import java.util.concurrent.RunnableScheduledFuture;
  
public class servertest
{
    //final static int port = 9809;
    //final static String IP = "10.24.91.133";
    private int port;
    private String IP; 
    
    public servertest(int cport, String cIP)
    {
        port = cport;
        IP = cIP;
    }

    public String Sendmessage(String message) throws IOException
    {
        DatagramSocket ds = new DatagramSocket();  
        InetAddress ip = InetAddress.getLocalHost();
        
            byte buf[] = null;
            buf = message.getBytes();
            DatagramPacket DpSend = new DatagramPacket(buf, buf.length, ip , port);
            ds.send(DpSend); 
            ds.close();
            
            DatagramSocket dr = new DatagramSocket(port);  
            InetAddress ipr = InetAddress.getLocalHost();
            
                byte buf2[] = "                           ".getBytes();
                buf2 = message.getBytes();
                DatagramPacket DpReciev = new DatagramPacket(buf2, buf2.length);
                dr.receive(DpReciev); 
            
            String recieved = new String(DpReciev.getData(), 0 , DpReciev.getLength());
            System.out.println(recieved);
            
            return recieved;
    }

    public void Startup() throws IOException
    {        
        DatagramSocket ds = new DatagramSocket();  
        InetAddress ip = InetAddress.getLocalHost();
        byte buf[] = null;
            String inp = "command";
            buf = inp.getBytes();
            DatagramPacket DpSend = new DatagramPacket(buf, buf.length, ip, port);
            ds.send(DpSend); 
        ds.close();
        
    }
}