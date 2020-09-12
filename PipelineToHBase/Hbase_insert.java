package pipeop;

import java.io.IOException;

import org.apache.hadoop.conf.Configuration;

import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.util.Bytes;

public class Hbase_insert{

   public static void main(String[] args) throws IOException {

      
      Configuration config = HBaseConfiguration.create();

      HTable hTable = new HTable(config, "RH");

      // Instanciando a classe put
      Put p = new Put(Bytes.toBytes("linha1")); 

      // Adicionando valores
      p.add(Bytes.toBytes("pessoal"), Bytes.toBytes("nome"),Bytes.toBytes("Bob"));

      p.add(Bytes.toBytes("pessoal"), Bytes.toBytes("cidade"),Bytes.toBytes("Fortaleza"));

      p.add(Bytes.toBytes("profissional"),Bytes.toBytes("cargo"),Bytes.toBytes("Analista"));

      p.add(Bytes.toBytes("profissional"),Bytes.toBytes("salario"),Bytes.toBytes("25000"));
      
      // Salvando os dados na tabela
      hTable.put(p);
      System.out.println("Dados inseridos");
      
      // Encerrando a conexão
      hTable.close();
   }
}