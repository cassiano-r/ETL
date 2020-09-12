package pipeop;
import java.io.IOException;

import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.client.HBaseAdmin;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.conf.Configuration;

public class Hbase_create {
      
   public static void main(String[] args) throws IOException {

      // Instanciando a classe de configuracao
      Configuration con = HBaseConfiguration.create();

      // Instanciando a classe HbaseAdmin 
      HBaseAdmin admin = new HBaseAdmin(con);

      // Instanciando a table descriptor 
      HTableDescriptor tableDescriptor = new HTableDescriptor(TableName.valueOf("RH"));

      // Adicionando familias de colunas
      tableDescriptor.addFamily(new HColumnDescriptor("pessoal"));
      tableDescriptor.addFamily(new HColumnDescriptor("profissional"));

      // Criando a tabela
      admin.createTable(tableDescriptor);
      System.out.println(" Tabela criada ");
   }
}