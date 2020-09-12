package pipeop;

import java.io.IOException;

import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.client.HBaseAdmin;

public class Hbase_drop {

   public static void main(String[] args) throws IOException {

      Configuration conf = HBaseConfiguration.create();

      HBaseAdmin admin = new HBaseAdmin(conf);

      admin.disableTable("RH");

      admin.deleteTable("RH");
      System.out.println("Tabela deletada");
   }
}