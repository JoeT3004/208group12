import java.io.IOException;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Scanner;

import javax.print.DocFlavor.SERVICE_FORMATTED;
import javax.sound.sampled.Port;



public class MainProgram {
    final static int port = 9809;
    final static String IP = "10.24.80.227";
    private static TelloClient client;

    public static void main(String args[]) throws UnknownHostException, SocketException, IOException
    {
      try{
        new TelloServer(port).start();

      }
      catch (Exception e)
      {
        System.out.println("server is weird ");
      }

      try{
        client = new TelloClient(port);

      }
      catch (Exception e)
      {
        System.out.println("client is weird ");
      }

      System.out.println("all went well");

      while(true)
      {
        String text = "";
        try{
           text = client.sendEcho("yeetyeet yeeteeeee");

  
        }
        catch (Exception e)
        {
          System.out.println("client is weird ");
        }
        System.out.println(text);

        System.in.read();
      }


    }

}
