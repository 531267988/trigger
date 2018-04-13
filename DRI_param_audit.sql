TRIG_PROJ_DDL_CHG_DTL_DEL_ADT -- To capture DEL changes 
TRIG_PROJ_DDL_CHG_DTL_INS_ADT -- To capture INS changes  
TRIG_PROJ_DDL_CHG_DTL_UPD_ADT -- To capture UPD changes
PROJ_DDL_CHG_DTL_ADT -- if this one is enabled, change can be done through BOSS portal only
  
alter trigger  TRIG_PROJ_DDL_CHG_DTL_DEL_ADT disable; 
alter trigger  TRIG_PROJ_DDL_CHG_DTL_INS_ADT disable;
alter trigger  TRIG_PROJ_DDL_CHG_DTL_UPD_ADT disable;

alter trigger  TRIG_PROJ_DDL_CHG_DTL_ADT enable;


DROP TABLE PROJ_DDL_CHG_DTL_ADT;  
CREATE TABLE 	PROJ_DDL_CHG_DTL_ADT(
PROJ_ID          VARCHAR2(20),                          
PROJ_TYP         VARCHAR2(4),                            
USR_STRY         VARCHAR2(10),                            
TBL_CHG_TYP      VARCHAR2(20),
TBL_NM           VARCHAR2(500),                           
CLMN_CHG_TYP     VARCHAR2(6),                         
CLMN_NM          VARCHAR2(500),
OLD_PROJ_ID      VARCHAR2(20),                          
OLD_PROJ_TYP     VARCHAR2(4),                            
OLD_USR_STRY     VARCHAR2(10),                            
OLD_TBL_CHG_TYP  VARCHAR2(20),
OLD_TBL_NM       VARCHAR2(500),                           
OLD_CLMN_CHG_TYP VARCHAR2(6),                         
OLD_CLMN_NM      VARCHAR2(500),                           
F_CHANGE_TYPE	VARCHAR2(1),
D_CHANGE_DATETIME	TIMESTAMP,
V_CHANGE_SOEID	VARCHAR2(10),
V_CHANGE_SERVERNAME	VARCHAR2(50));



CREATE OR REPLACE TRIGGER TRIG_PROJ_DDL_CHG_DTL_DEL_ADT
BEFORE DELETE ON PROJ_DDL_CHG_DTL FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
  lc_chg_type varchar2(1) := 'D';

BEGIN  
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

 	INSERT INTO PROJ_DDL_CHG_DTL_ADT
	(PROJ_ID, PROJ_TYP, USR_STRY, TBL_CHG_TYP, TBL_NM, CLMN_CHG_TYP, CLMN_NM,
	F_CHANGE_TYPE,D_CHANGE_DATETIME, V_CHANGE_SOEID, V_CHANGE_SERVERNAME)
	VALUES
	(:old.PROJ_ID, :old.PROJ_TYP, :old.USR_STRY, :old.TBL_CHG_TYP, :old.TBL_NM, 
	:old.CLMN_CHG_TYP, :old.CLMN_NM, lc_chg_type, SYSDATE, lc_os_user, lc_host);

EXCEPTION
 WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20002,'Error in INSERTING to PROJ_DDL_CHG_DTL_ADT');
END TRIG_PROJ_DDL_CHG_DTL_DEL_ADT;
/

create or replace TRIGGER TRIG_PROJ_DDL_CHG_DTL_UPD_ADT
BEFORE UPDATE OF PROJ_ID, PROJ_TYP, USR_STRY, TBL_CHG_TYP, TBL_NM, CLMN_CHG_TYP, CLMN_NM ON PROJ_DDL_CHG_DTL FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
  lc_chg_type varchar2(1) := 'U';

BEGIN  
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

 	INSERT INTO PROJ_DDL_CHG_DTL_ADT
	(  PROJ_ID, PROJ_TYP, USR_STRY, TBL_CHG_TYP, TBL_NM, CLMN_CHG_TYP, CLMN_NM,
	   OLD_PROJ_ID, OLD_PROJ_TYP, OLD_USR_STRY, OLD_TBL_CHG_TYP, OLD_TBL_NM, OLD_CLMN_CHG_TYP, OLD_CLMN_NM,
	 F_CHANGE_TYPE, D_CHANGE_DATETIME, V_CHANGE_SOEID, V_CHANGE_SERVERNAME)
	VALUES
	(:NEW.PROJ_ID, :NEW.PROJ_TYP, :NEW.USR_STRY, :NEW.TBL_CHG_TYP, :NEW.TBL_NM, :NEW.CLMN_CHG_TYP, :NEW.CLMN_NM,
   :old.PROJ_ID, :old.PROJ_TYP, :old.USR_STRY, :old.TBL_CHG_TYP, :old.TBL_NM, :old.CLMN_CHG_TYP, :old.CLMN_NM,	  
	lc_chg_type, 
	SYSDATE, lc_os_user, lc_host);

EXCEPTION
 WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20002,'Error in INSERTING to PROJ_DDL_CHG_DTL_ADT');
END TRIG_PROJ_DDL_CHG_DTL_UPD_ADT;

/

CREATE OR REPLACE TRIGGER TRIG_PROJ_DDL_CHG_DTL_INS_ADT
BEFORE INSERT ON PROJ_DDL_CHG_DTL FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
  lc_chg_type varchar2(1) := 'I';

BEGIN  
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

	INSERT INTO PROJ_DDL_CHG_DTL_ADT
	(  PROJ_ID, PROJ_TYP, USR_STRY, TBL_CHG_TYP, TBL_NM, CLMN_CHG_TYP, CLMN_NM,
	F_CHANGE_TYPE,D_CHANGE_DATETIME, V_CHANGE_SOEID,V_CHANGE_SERVERNAME)
	VALUES
	(:NEW.PROJ_ID, :NEW.PROJ_TYP, :NEW.USR_STRY, :NEW.TBL_CHG_TYP, 
	:NEW.TBL_NM, :NEW.CLMN_CHG_TYP, :NEW.CLMN_NM,
	 lc_chg_type, SYSDATE, lc_os_user, lc_host);
EXCEPTION
 WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20002,'Error in INSERTING to PROJ_DDL_CHG_DTL_ADT');
END TRIG_PROJ_DDL_CHG_DTL_INS_ADT;
/


create or replace TRIGGER TRIG_PROJ_DDL_CHG_DTL_ADT
BEFORE UPDATE or delete or insert on PROJ_DDL_CHG_DTL FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN  
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;
  
  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_PROJ_DDL_CHG_DTL_ADT;
/

create or replace TRIGGER TRIG_PROJ_MSTR_PRO_ADT
BEFORE UPDATE or delete or insert on PROJ_MSTR_PRO FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN  
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;
  
  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_PROJ_MSTR_PRO_ADT;
/

create or replace TRIGGER TRIG_RSRC_MSTR_ADT
BEFORE UPDATE or delete or insert on RSRC_MSTR FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_RSRC_MSTR_ADT;
/


create or replace TRIGGER TRIG_ROLE_MSTR_ADT
BEFORE UPDATE or delete or insert on ROLE_MSTR FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_ROLE_MSTR_ADT;
/

create or replace TRIGGER TRIG_RLSE_MSTR_ADT
BEFORE UPDATE or delete or insert on RLSE_MSTR FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_RLSE_MSTR_ADT;
/

create or replace TRIGGER TRIG_PROJ_TWS_CHG_DTL_ADT
BEFORE UPDATE or delete or insert on PROJ_TWS_CHG_DTL FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_PROJ_TWS_CHG_DTL_ADT;
/

create or replace TRIGGER TRIG_PROJ_NON_FCN_CHG_DTL_ADT
BEFORE UPDATE or delete or insert on PROJ_NON_FCN_CHG_DTL FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_PROJ_NON_FCN_CHG_DTL_ADT;
/

create or replace TRIGGER TRIG_PROJ_FID_CHG_DTL_ADT
BEFORE UPDATE or delete or insert on PROJ_FID_CHG_DTL FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_PROJ_FID_CHG_DTL_ADT;
/

create or replace TRIGGER TRIG_PROJ_CD_CHG_DTL_ADT
BEFORE UPDATE or delete or insert on PROJ_CD_CHG_DTL FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_PROJ_CD_CHG_DTL_ADT;
/

create or replace TRIGGER TRIG_PROJ_ASGN_ADT
BEFORE UPDATE or delete or insert on PROJ_ASGN FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_PROJ_ASGN_ADT;
/

create or replace TRIGGER TRIG_PROJ_MSTR_PRO_NGC_ADT
BEFORE UPDATE or delete or insert on PROJ_MSTR_PRO_NGC FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_PROJ_MSTR_PRO_NGC_ADT;
/


create or replace TRIGGER TRIG_PROJ_ASGN_NGC_ADT
BEFORE UPDATE or delete or insert on PROJ_ASGN_NGC FOR EACH ROW
DECLARE
  lc_host varchar(50);
  lc_os_user varchar2(10);
  lc_session_user varchar2(30);
BEGIN
 	SELECT SUBSTR(NVL(SYS_CONTEXT('USERENV', 'HOST'),'#'),1,50),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'OS_USER'),'#'),1,10),
				SUBSTR(NVL(SYS_CONTEXT('USERENV', 'SESSION_USER'),'#'),1,30)
 	into		lc_host, lc_os_user, lc_session_user
 	FROM 	DUAL;

  if lc_os_user <> 'wsadmin' then
     RAISE_APPLICATION_ERROR(-20002, 'manual change not allowed, please do the change through BOSS portal');
  end if;
  END TRIG_PROJ_ASGN_NGC_ADT;
/

