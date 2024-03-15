import java.io.*;
import java.net.*;
import java.util.Scanner;
import java.util.concurrent.RunnableScheduledFuture;
public class TelloClient {
    private DatagramSocket socket;
    private InetAddress address;
    private int port;

    private byte[] buf;

    public TelloClient(int cport) throws SocketException, UnknownHostException {
      port = cport;
        socket = new DatagramSocket();
        address = InetAddress.getByName("localhost");
    }

    public String sendEcho(String msg) throws IOException {
        buf = msg.getBytes();

        DatagramPacket packet 
          = new DatagramPacket(buf, buf.length, address, port);
        socket.send(packet);
        packet = new DatagramPacket(buf, buf.length);
        socket.receive(packet);
        String received = new String(
          packet.getData(), 0, packet.getLength());
        return received;
    }

    public void close() {
        socket.close();
    }
}