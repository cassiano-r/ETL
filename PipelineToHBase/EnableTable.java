package pipeop;

import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.HBaseAdmin;

public class EnableTable{

   public static void main(String args[]) throws IOException{

      Configuration conf = HBaseConfiguration.create();

      HBaseAdmin admin = new HBaseAdmin(conf);

      Boolean bool = admin.isTableEnabled("RH");
      System.out.println(bool);

      if(!bool){
         admin.enableTable("RH");
         System.out.println("A Tabela foi habilitada");
      }
      else
      {
    	  System.out.println("Tabela habilitada");
      }
   }
}