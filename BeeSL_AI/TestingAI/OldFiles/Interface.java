import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;


class TelloInterface
{
    private DatagramSocket socket;
    private InetAddress address;
    private int port;
   // private byte[] buf;

    

    public TelloInterface(int Port, String inetaddress ) throws UnknownHostException, SocketException {             
        //address = InetAddress.getByName(inetaddress);        
        socket = new  DatagramSocket();  
           
        InetAddress address = InetAddress.getByName(inetaddress);
        port = Port;    
        
        String msg = "command";
        byte[] buf = msg.getBytes();
        DatagramPacket packet = new DatagramPacket(buf, buf.length, address, port);
        try {
            socket.send(packet);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            System.out.println("problem with Sending");
            e.printStackTrace();
        }
    }

    public String NsendMessage(String msg)
    {    
    byte[] buffer = msg.getBytes();
 
    DatagramPacket request = new DatagramPacket(buffer, buffer.length, address, port);

    try {
        socket.send(request);
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
        return msg;     

    }
    
    public String sendMessage(String msg) {        
        byte[] buf = msg.getBytes();
        DatagramPacket packet = new DatagramPacket(buf, buf.length, address, port);
        try {
            socket.send(packet);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            System.out.println("problem with Sending");
            e.printStackTrace();
        }
        byte[] rbuf = new byte[1024];
        DatagramPacket rpacket = new DatagramPacket(rbuf, rbuf.length,address,port);
        
        
        try {
            socket.receive(rpacket);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            System.out.println("problem with recieving ");
            e.printStackTrace();
        }
        String received = new String(rpacket.getData(), 0, rpacket.getLength());
        return received;
    }

    public void close() {
        socket.close();
    }
 
}
