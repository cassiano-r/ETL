package pipeop;

import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.client.HBaseAdmin;

public class ListTables {

   public static void main(String args[])throws  IOException{

      // Instanciando a classe
      Configuration conf = HBaseConfiguration.create();

      // Instanciando a classe HBaseAdmin 
    
      HBaseAdmin admin = new HBaseAdmin(conf);

      // Ontendo todas as tabelas
      HTableDescriptor[] tableDescriptor = admin.listTables();

      // Imprimindo o nome das tabelas
      for (int i=0; i<tableDescriptor.length;i++ ){
         System.out.println(tableDescriptor[i].getNameAsString());
      }
 
   }
}