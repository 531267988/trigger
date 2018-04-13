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
