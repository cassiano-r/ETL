package pipeop;

import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.HBaseAdmin;

public class Hbase_disable{

   public static void main(String args[]) throws  IOException{

      Configuration conf = HBaseConfiguration.create();
 
      HBaseAdmin admin = new HBaseAdmin(conf);

      Boolean bool = admin.isTableDisabled("RH");
      System.out.println(bool);
      
      if(!bool){
         admin.disableTable("RH");
         System.out.println("\nTabela desativada");
      }
      else
      {
    	  System.out.println("\nTabela desativada");
      }
   }
}