package pipeop;

import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.KeyValue;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;


public class Hbase_read{

   @SuppressWarnings("deprecation")
public static void main(String args[]) throws IOException{

      // Instanciando a classe
      Configuration config = HBaseConfiguration.create();

      // Instanciando a tabela no Hbase
      HTable table = new HTable(config, "RH");

      // Instanciando uma classe scan
      Scan scan = new Scan();

      // Scan nas colunas
      scan.addColumn(Bytes.toBytes("pessoal"), Bytes.toBytes("nome"));
      scan.addColumn(Bytes.toBytes("profissional"), Bytes.toBytes("cidade"));

      // Obtendo o resultado
      ResultScanner scanner = table.getScanner(scan);
try {
  
    	  for (Result result = scanner.next(); (result != null); result = scanner.next()) {
    		    for(KeyValue keyValue : result.list()) {
    		        System.out.println("Chave : " + keyValue.getKeyString() + " : Valor : " + Bytes.toString(keyValue.getValue()));
    		    }
    		}
}
finally
{
      //Encerrando o scan
      scanner.close();
   }
   }
}







