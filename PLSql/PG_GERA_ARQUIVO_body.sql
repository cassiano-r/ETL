CREATE OR REPLACE PACKAGE BODY PG_GERA_ARQUIVO IS

  PROCEDURE CNP_IDENTIFICADOR_TURMA AS
  
  BEGIN
    FOR reg in (SELECT lpad(to_char(rownum), 4, '0') contador,
                       dw.id_turma_r3 id_turma_r3,
                       dw.PRJDRH01 gera_identificador_turma,
                       t.custom9 tipo_evento,
                       nvl(substr(c.id, 1, 1), ' ') tipo_clientela,
                       substr(f.id, 14, 6) area_conhecimento,
                       nvl(s.custom2, ' ') tipo_entrega,
                       dw.status_envio_r3 status_envio_r3,
                       s.id id_session
                  FROM let_ext_offering_template  t,
                       let_ext_offering_session   s,
                       cnt_envio_dw              dw,
                       fgt_gen                    g,
                       tpt_ext_nlevel_folder      f,
                       let_ext_delivery           d,
                       cnt_cliente_offering_add tc,
                       cnt_cliente_clientela    c,
                       tpt_config_info            i
                 WHERE t.id = s.offering_temp_id
                   AND s.id = dw.id_session
                   AND g.id2 = t.id
                   AND g.id1 = f.id
                   AND d.id = s.delivery_id
                   AND s.id = tc.offering_id(+)
                   AND trim(tc.clientela_id) = trim(c.id(+))
                   AND (dw.PRJDRH01 is null OR dw.PRJDRH01 = 'REENVIAR')
                   AND s.custom7 = 'true'
                   AND s.status = '200'
                   AND s.locale_id = i.default_locale_id
                   AND t.locale_id = i.default_locale_id
                   AND f.locale_id = i.default_locale_id
                   AND d.locale_id = i.default_locale_id
                   AND NOT EXISTS
                 (select 1
                          from cnt_TB_class_composition cc1
                         where cc1.subclass_id = s.id)) LOOP
    
      Insert into CNT_TB_PRJDRH01
        (Id_campo1,         
         Id_mes,
         Id_campo2,
         Id_PJDRH,
         Id_num,
         Id_cod,
         id_turma_r3,
         tipo_clientela,
         area_conhecimento,
         tipo_entrega)
      values
        ('000',
         to_char(sysdate, 'MM'),
         substr(reg.id_turma_r3,1,14),
         'PJDRH',
         reg.contador,
         'I',
         substr(reg.id_turma_r3,15,3),
         reg.tipo_clientela,
         reg.area_conhecimento,
         rpad(reg.tipo_entrega, 3, ' '));
    
      commit;
    
      IF (reg.gera_identificador_turma is null) THEN
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'ENVIADO',
               data_ultimo_envio = sysdate,
               PRJDRH01          = 'ENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      ELSE
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'REENVIADO',
               data_ultimo_envio = sysdate,
               PRJDRH01          = 'REENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      END IF;
    
    END LOOP;
  
  END CNP_IDENTIFICADOR_TURMA;

  PROCEDURE CNP_CARGA_HORARIA AS
  
  BEGIN
    FOR reg in (SELECT (lpad(to_char(rownum), 4, '0')) contador,
                       dw.id_turma_r3 id_turma_r3,
                       dw.prjdrh02 gera_carga_horaria,
                       t.custom9 tipo_evento,
                       lpad(to_char(ROUND(s.duration / 60)), '4', '0') carga_horaria,
                       to_char(s.start_date, 'DDMMYYYY') data_inicio,
                       to_char(s.end_date, 'DDMMYYYY') data_termino,
                       status_envio_r3,
                       s.id id_session
                  FROM let_ext_offering_template t,
                       let_ext_offering_session  s,
                       cnt_envio_dw             dw,
                       tpt_config_info           i
                 WHERE t.id = s.offering_temp_id
                   AND s.id = dw.id_session
                   AND (dw.PRJDRH02 is null OR dw.PRJDRH02 = 'REENVIAR')
                   AND s.custom7 = 'true'
                   AND s.status = '200'
                   AND s.locale_id = i.default_locale_id
                   AND t.locale_id = i.default_locale_id
                   AND NOT EXISTS
                 (select 1
                          from cnt_TB_class_composition cc1
                         where cc1.subclass_id = s.id)
                 order by 1) LOOP
    
      Insert into CNT_TB_PRJDRH02
        (Id_campo1,
         Id_campo2,
         Id_mes,
         Id_PJDRH,
         Id_num,
         Id_cod,
         id_turma_r3,
         carga_horaria,
         data_inicio,
         data_termino)
      values
        (
         '000',         
         substr(reg.id_turma_r3,1,14),
         to_char(sysdate, 'MM'),
         'PJDRH',
         reg.contador,
         'I',
         substr(reg.id_turma_r3,15,3),
         reg.carga_horaria,
         reg.data_inicio,
         reg.data_termino);
    
      commit;
    
      IF (reg.gera_carga_horaria is null) THEN
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'ENVIADO',
               data_ultimo_envio = sysdate,
               PRJDRH02          = 'ENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      ELSE
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'REENVIADO',
               data_ultimo_envio = sysdate,
               PRJDRH02          = 'REENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      END IF;
    
    END LOOP;
  
  END CNP_CARGA_HORARIA;

  PROCEDURE CNP_RESPONSAVEL AS
  
  BEGIN
    FOR reg in (SELECT lpad(to_char(rownum), 4, '0') contador,
                       dw.id_turma_r3 id_turma_r3,
                       dw.PRJDRH05 gera_resp_turma,
                       dw.status_envio_r3,
                       t.custom9 tipo_evento,
                       s.id,
                       s.class_no,
                       (select l.custom4
                          from tpt_facility l
                         where l.id = s.facility_id) local,
                       per_res.username mat_resp,
                       tc.custom5 org_evento,
                       lpad(to_char(round(s.duration / 60)), 4, '0') carga_horaria,
                       lpad(s.max_ct, 4, '0') num_vagas,
                       s.id id_session,
                       s.custom8 centro_custo_resp,
                       s.custom9 centro_custo_soli,
                       (select custom5
                          from tpt_company
                         where id = ofad.business_unit_resp_id) uni_resp --wagner
                  FROM let_ext_offering_template  t,
                       let_ext_offering_session   s,
                       cnt_envio_dw              dw,
                       cmt_governance             gov,
                       cmt_person                 per_res,
                       cnt_cliente_offering_add ofad,
                       tpt_company                tc,
                       tpt_config_info            i
                 WHERE t.id = s.offering_temp_id
                   AND s.id = dw.id_session
                   AND gov.parent_id = s.id
                   AND gov.owner_id = per_res.id
                   AND ofad.OFFERING_ID = s.ID
                   AND (dw.PRJDRH05 is null OR dw.PRJDRH05 = 'REENVIAR')
                   AND s.custom7 = 'true'
                   AND s.status = '200'
                   AND tc.id = ofad.business_unit_id
                   AND s.locale_id = i.default_locale_id
                   AND t.locale_id = i.default_locale_id
                   AND NOT EXISTS
                 (select 1
                          from cnt_TB_class_composition cc1
                         where cc1.subclass_id = s.id)) LOOP
    
      Insert into CNT_TB_PRJDRH05
        (Id_campo1,
         Id_campo2,
         Id_mes,
         Id_PJDRH,
         Id_num,
         Id_cod,
         id_turma_r3,
         local,
         mat_resp,
         org_evento,
         num_vagas,
         centro_custo_resp,
         centro_custo_soli,
         unidade_resp)
      values
        (
         '000',
         substr(reg.id_turma_r3,1,14),
         to_char(sysdate, 'MM'),
         'PJDRH',
         reg.contador,
         'I',
         substr(reg.id_turma_r3,15,3),
         lpad(nvl(reg.local, ' '), 8, '0'),
         rpad(reg.mat_resp, 7, ' '),
         lpad(reg.org_evento, 8, '0'),
         reg.num_vagas,
         reg.centro_custo_resp,
         reg.centro_custo_soli,
         reg.uni_resp);
         

      commit;
    
      IF (reg.gera_resp_turma is null) THEN
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'ENVIADO',
               data_ultimo_envio = sysdate,
               PRJDRH05          = 'ENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      ELSE
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'REENVIADO',
               data_ultimo_envio = sysdate,
               PRJDRH05          = 'REENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      END IF;
    
    END LOOP;
  
  END CNP_RESPONSAVEL;

  PROCEDURE CNP_PARTICIPANTE AS

  BEGIN
    FOR reg in (SELECT lpad(to_char(rownum), 4, '0') contador,
                       dw.id_turma_r3 id_turma_r3,
                       dw.TRCIA gera_participantes,
                       dw.status_envio_r3,
                       t.custom9 tipo_evento,
                       c.ss_no mat_part,
                       s.id id_session,
                       oa.STATUS,
                       c.ss_no,
                       oa.score,
                       oa.action_status,
                       p.description,
                       c.username
                  FROM let_ext_offering_template t,
                       let_ext_offering_session  s,
                       cnt_envio_dw             dw,
                       tpt_registration          r,
                       cmt_person                c,
                       tpt_config_info           i,
                       tpt_offering_action       oa,
                       CNT_cliente_CNC_PURPOSE p
                 WHERE t.id = s.offering_temp_id
                   AND s.id = dw.id_session
                   AND r.class_id = s.id
                   AND r.student_id = c.id
                   AND (dw.TRCIA is null OR dw.TRCIA = 'REENVIAR')
                   AND s.custom7 = 'true'
                   AND s.status = '200'
                   AND oa.PARTY_ID = c.ID
                   and oa.id = r.OFFERING_ACTION_ID
                   and oa.status = '200'
                   AND s.locale_id = i.default_locale_id
                   AND t.locale_id = i.default_locale_id
                   AND p.seq_id = s.custom1
                   AND NOT EXISTS
                 (select 1
                          from cnt_TB_class_composition cc1
                         where cc1.subclass_id = s.id)) LOOP
    
       Insert into CNT_TB_PARTICIPANTES
        (COD_TURMA,
         MAT_PARTICIP,
         CHAVE_PARTICIP,
         STATUS,
         MOTIVO_CANCEL,
         MEDIA,
         ORG_PAG,
         ORG_LOT,
         MES,
         FUNC,
         MAT_ATU,
         SEQ,
         TIPO_MOV,
         NUM_DOC,
         COD_OCOR,
         COD_PROJ)
      values
        (reg.id_turma_r3,
         reg.ss_no,
         reg.username,
         reg.action_status,
         reg.description,
         reg.score,
         NULL,
         NULL,
         to_char(sysdate, 'MM'),
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL); 
    
      commit;
    
      IF (reg.gera_participantes is null) THEN
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'ENVIADO',
               data_ultimo_envio = sysdate,
               TRCIA             = 'ENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      ELSE
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'REENVIADO',
               data_ultimo_envio = sysdate,
               TRCIA             = 'REENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      END IF;
    
    END LOOP;
  
  END CNP_PARTICIPANTE;

  PROCEDURE CNP_DOCENTE AS
  
  BEGIN
    FOR reg in (SELECT max(lpad(to_char(rownum), 4, '0')) contador,
                       id_turma_r3,
                       gera_docente,
                       id_session,
                       status_envio_r3,
                       tipo_evento,
                       lpad(to_char(sum(carga_horaria)), 4, '0') carga_horaria,
                       data_inicio,
                       data_termino,
                       mat_prof
                  from (SELECT dw.id_turma_r3 id_turma_r3,
                               dw.DOCIA gera_docente,
                               dw.id_session,
                               dw.status_envio_r3,
                               t.custom9 tipo_evento,
                               round(h.duration / 60) carga_horaria,
                               to_char(s.start_date, 'DDMMYYYY') data_inicio,
                               to_char(s.end_date, 'DDMMYYYY') data_termino,
                               nvl(c.ss_no, ' ') mat_prof,
                               h.RESOURCEASSIGNMENTID
                          FROM let_ext_offering_template t,
                               let_ext_offering_session  s,
                               cnt_TB_class_composition cc,
                               cnt_envio_dw             dw,
                               fgt_assignments           a,
                               cmt_person                c,
                               tpt_config_info           i,
                               cnt_TB_carga_hr          h
                         WHERE t.id = s.offering_temp_id
                           AND s.id = dw.id_session
                           AND a.project_id = cc.subclass_id
                           AND a.resource_id = c.ID
                           and cc.class_id = dw.id_session
                           AND (dw.DOCIA is null OR dw.DOCIA = 'REENVIAR')
                           AND s.custom7 = 'true'
                           AND s.status = '200'
                           AND a.purpose = 'recat000000000000001' 
                           and a.id = h.RESOURCEASSIGNMENTID
                           AND s.locale_id = i.default_locale_id
                           AND t.locale_id = i.default_locale_id
                        union
                        SELECT dw.id_turma_r3 id_turma_r3,
                               dw.DOCIA gera_docente,
                               dw.id_session,
                               dw.status_envio_r3,
                               t.custom9 tipo_evento,
                               round(h.duration / 60) carga_horaria,
                               to_char(s.start_date, 'DDMMYYYY') data_inicio,
                               to_char(s.end_date, 'DDMMYYYY') data_termino,
                               nvl(c.ss_no, ' ') mat_prof,
                               h.RESOURCEASSIGNMENTID
                          FROM let_ext_offering_template t,
                               let_ext_offering_session  s,
                               cnt_envio_dw             dw,
                               fgt_assignments           a,
                               cmt_person                c,
                               tpt_config_info           i,
                               cnt_TB_carga_hr          h
                         WHERE t.id = s.offering_temp_id
                           AND s.id = dw.id_session
                           AND a.project_id = s.ID
                           AND a.resource_id = c.ID
                           AND (dw.DOCIA is null OR dw.DOCIA = 'REENVIAR')
                           AND s.custom7 = 'true'
                           AND s.status = '200'
                           AND a.purpose = 'recat000000000000001' 
                           and a.id = h.RESOURCEASSIGNMENTID
                           AND s.locale_id = i.default_locale_id
                           AND t.locale_id = i.default_locale_id
                           AND NOT EXISTS
                         (select 1
                                  from cnt_TB_class_composition cc1
                                 where cc1.subclass_id = s.id))
                 group by id_turma_r3,
                          gera_docente,
                          id_session,
                          status_envio_r3,
                          tipo_evento,
                          data_inicio,
                          data_termino,
                          mat_prof) LOOP
    
      Insert into CNT_TB_DOCIA
        (Id_campo1,
         Id_campo2,
         Id_mes,
         Id_PJDRH,
         Id_num,
         Id_cod,
         mat_prof,
         id_turma_r3,
         data_inicio,
         data_termino,
         carga_horaria)
      values
        ('000',
        substr(reg.id_turma_r3,1,14),
         to_char(sysdate, 'MM'),
         'DOCIA',
         reg.contador,
         'I',
         lpad(reg.mat_prof, 7, ' '),
         substr(reg.id_turma_r3,15,3),
         reg.data_inicio,
         reg.data_termino,
         reg.carga_horaria);
         

    
      commit;
    
      IF (reg.gera_docente is null) THEN
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'ENVIADO',
               data_ultimo_envio = sysdate,
               DOCIA             = 'ENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      ELSE
        UPDATE cnt_envio_dw
           SET status_envio_r3   = 'REENVIADO',
               data_ultimo_envio = sysdate,
               DOCIA             = 'REENVIADO'
         WHERE id_session = reg.id_session;
      
        commit;
      END IF;
    
    END LOOP;
    COMMIT;
  
  END CNP_DOCENTE;

  PROCEDURE CNP_CARREGA_TABELA AS
    
  BEGIN
   
    MERGE INTO cnt_envio_dw a
    USING (SELECT distinct s.id,
                           t.custom9,
                           s.class_no,
                           t.offering_template_no
             FROM let_ext_offering_session  s,
                  tpt_config_info           i,
                  let_ext_offering_template t
            WHERE s.locale_id = i.default_locale_id
              and s.OFFERING_TEMP_ID = t.ID
              and s.custom7 = 'true'
              and t.custom9 is not null
              and not exists (select 1
                     from cnt_TB_class_composition cc
                    where cc.subclass_id = s.id)) b
    ON (a.id_session = b.id)
    WHEN NOT MATCHED THEN
      INSERT
      VALUES
        (b.id,
          substr(lpad(chr(66+substr(lpad(ID_R3_SAB_SEQ.nextval,9,0),1,1)-1)||substr(lpad(ID_R3_SAB_SEQ.nextval,9,0),2,9),9,0), 1, 6) ||b.custom9||
          substr(lpad(chr(66+substr(lpad(ID_R3_SAB_SEQ.nextval,9,0),1,1)-1)||substr(lpad(ID_R3_SAB_SEQ.nextval,9,0),2,9),9,0), 7, 3),
          lpad(chr(66+substr(lpad(ID_R3_SAB_SEQ.nextval,9,0),1,1)-1)||substr(lpad(ID_R3_SAB_SEQ.nextval,9,0),2,9),9,0),

         
         b.class_no,
         null,
         null,
         null,
         null,
         null,
         null,
         null);
  
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('ERRO:: SQLCODE: <' || SQLCODE || '>');
      dbms_output.put_line('ERRO:: SQLERRM: <' || SUBSTR(SQLERRM, 1, 100) || '>');
    
  END CNP_CARREGA_TABELA;

  PROCEDURE CNP_INICIA_GERACAO(xfilepath IN VARCHAR) AS
   
  BEGIN
  
    CNP_CARREGA_TABELA;
  
    CNP_IDENTIFICADOR_TURMA;
  
    CNP_CARGA_HORARIA;
  
    CNP_RESPONSAVEL;
  
    CNP_PARTICIPANTE;
  
    CNP_DOCENTE;
  
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('ERRO:: SQLCODE: <' || SQLCODE || '>');
      dbms_output.put_line('ERRO:: SQLERRM: <' || SUBSTR(SQLERRM, 1, 100) || '>');
    
  END CNP_INICIA_GERACAO;

END PG_GERA_ARQUIVO;
/
