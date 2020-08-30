CREATE OR REPLACE PACKAGE "PG_GERA_ARQUIVO" IS

PROCEDURE CNP_IDENTIFICADOR_TURMA ;

PROCEDURE CNP_CARGA_HORARIA ;

PROCEDURE CNP_RESPONSAVEL ;

PROCEDURE CNP_PARTICIPANTE ;

PROCEDURE CNP_DOCENTE;

PROCEDURE CNP_CARREGA_TABELA;

PROCEDURE CNP_INICIA_GERACAO (xfilepath    IN VARCHAR);


END PG_GERA_ARQUIVO;
/