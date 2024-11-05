
CREATE OR REPLACE PROCEDURE Zap_objects(
    object_type_in IN VARCHAR2)
AS
TYPE t_tab
IS
  TABLE OF user_tables%ROWTYPE;
  objects_tab t_tab := t_tab();
TYPE seq_tab
IS
  TABLE OF user_sequences%ROWTYPE;
  objects_seq seq_tab := seq_tab();
TYPE trg_tab
IS
  TABLE OF user_triggers%ROWTYPE;
  objects_trg trg_tab := trg_tab();
TYPE view_tab
IS
  TABLE OF user_views%ROWTYPE;
  objects_view view_tab := view_tab();
TYPE object_tab
IS
  TABLE OF all_objects%ROWTYPE;
  objects_obj object_tab := object_tab();
  v_sql VARCHAR2(2000);
  v_cnt NUMBER(9);
BEGIN
  IF object_type_in = 'TABLE' THEN
    SELECT COUNT(*) INTO v_cnt FROM user_tables;
    IF v_cnt > 0 THEN
      SELECT * BULK COLLECT INTO objects_tab FROM user_tables;
      FOR i IN objects_tab.first .. objects_tab.last
      LOOP
        v_sql := 'Drop table ' || '"' || objects_tab(i).table_name || '"' ||  ' cascade constraints';
        EXECUTE immediate v_sql;
      END LOOP;
    END IF;
    RETURN;
  END IF;
  IF object_type_in = 'TRIGGER' THEN
    SELECT COUNT(*) INTO v_cnt FROM user_triggers;
    IF v_cnt > 0 THEN
      SELECT * BULK COLLECT INTO objects_trg FROM user_triggers;
      FOR i IN objects_trg.first .. objects_trg.last
      LOOP
        v_sql := 'Drop trigger ' || objects_trg(i).trigger_name ;
        EXECUTE immediate v_sql;
      END LOOP;
    END IF;
    RETURN;
  END IF;
  IF object_type_in = 'SEQUENCE' THEN
    SELECT COUNT(*) INTO v_cnt FROM user_sequences;
    IF v_cnt > 0 THEN
      SELECT * BULK COLLECT INTO objects_seq FROM user_sequences;
      FOR i IN objects_seq.first .. objects_seq.last
      LOOP
        v_sql := 'Drop sequence ' || objects_seq(i).sequence_name ;
        EXECUTE immediate v_sql;
      END LOOP;
    END IF;
    RETURN;
  END IF;
  IF object_type_in = 'VIEW' THEN
    SELECT COUNT(*) INTO v_cnt FROM user_views;
    IF v_cnt > 0 THEN
      SELECT * BULK COLLECT INTO objects_view FROM user_views;
      FOR i IN objects_view.first .. objects_view.last
      LOOP
        v_sql := 'Drop view ' || objects_view(i).view_name ;
        EXECUTE immediate v_sql;
      END LOOP;
    END IF;
    RETURN;
  END IF;
  --
  SELECT COUNT(*)
  INTO v_cnt
  FROM ALL_OBJECTS
  WHERE upper(OBJECT_TYPE) = upper(OBJECT_TYPE_IN)
  AND owner                = USER;
  DBMS_OUTPUT.PUT_LINE('COUNT: ' || V_CNT);
  IF v_cnt > 0 THEN
    SELECT * BULK COLLECT
    INTO objects_obj
    FROM ALL_OBJECTS
    WHERE upper(OBJECT_TYPE) = upper(OBJECT_TYPE_IN)
    AND owner                = USER;
    FOR i IN objects_obj.first .. objects_obj.last
    LOOP
      IF objects_obj(i).object_name != 'ZAP_OBJECTS' THEN
        v_sql                       := 'Drop ' || OBJECT_TYPE_IN || ' ' || objects_obj(i).object_name ;
        EXECUTE immediate v_sql;
      END IF;
    END LOOP;
  END IF;
END;
/
BEGIN
  Zap_objects('VIEW');
  Zap_objects('TRIGGER');
  Zap_objects('TABLE');
  Zap_objects('SEQUENCE');
  Zap_objects('PROCEDURE');
  Zap_objects('FUNCTION');
  Zap_objects('PACKAGE');
END;
/
DROP PROCEDURE Zap_objects;

PURGE RECYCLEBIN;
/

--------------------------------------------------------
--  DDL for Table CUSTOMER
--------------------------------------------------------

  CREATE TABLE "CUSTOMER" 
   (	"CUSTOMER_ID" VARCHAR2(38 BYTE), 
	"CUSTOMER_FIRST_NAME" VARCHAR2(30 BYTE), 
	"CUSTOMER_MIDDLE_NAME" VARCHAR2(30 BYTE), 
	"CUSTOMER_LAST_NAME" VARCHAR2(30 BYTE), 
	"CUSTOMER_DATE_OF_BIRTH" DATE, 
	"CUSTOMER_GENDER" VARCHAR2(10 BYTE), 
	"CUSTOMER_CRTD_ID" VARCHAR2(40 BYTE), 
	"CUSTOMER_CRTD_DT" DATE, 
	"CUSTOMER_UPDT_ID" VARCHAR2(40 BYTE), 
	"CUSTOMER_UPDT_DT" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table ORDERS
--------------------------------------------------------

  CREATE TABLE "ORDERS" 
   (	"ORDERS_ID" VARCHAR2(32 BYTE), 
	"ORDERS_DATE" TIMESTAMP (6), 
	"ORDERS_CUSTOMER_ID" VARCHAR2(32 BYTE), 
	"ORDERS_CRTD_ID" VARCHAR2(40 BYTE), 
	"ORDERS_CRTD_DT" DATE, 
	"ORDERS_UPDT_ID" VARCHAR2(40 BYTE), 
	"ORDERS_UPDT_DT" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table ORDERS_LINE
--------------------------------------------------------

  CREATE TABLE "ORDERS_LINE" 
   (	"ORDERS_LINE_ID" VARCHAR2(32 BYTE), 
	"ORDERS_LINE_ORDERS_ID" VARCHAR2(32 BYTE), 
	"ORDERS_LINE_PRODUCT_ID" VARCHAR2(32 BYTE), 
	"ORDERS_LINE_QTY" NUMBER(4,0), 
	"ORDERS_LINE_PRICE" NUMBER(9,2), 
	"ORDERS_LINE_CRTD_ID" VARCHAR2(40 BYTE), 
	"ORDERS_LINE_CRTD_DT" DATE, 
	"ORDERS_LINE_UPDT_ID" VARCHAR2(40 BYTE), 
	"ORDERS_LINE_UPDT_DT" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table PRODUCT
--------------------------------------------------------

  CREATE TABLE "PRODUCT" 
   (	"PRODUCT_ID" VARCHAR2(32 BYTE) DEFAULT SYS_GUID(), 
	"PRODUCT_NAME" VARCHAR2(200 BYTE), 
	"PRODUCT_DESC" VARCHAR2(2000 BYTE), 
	"PRODUCT_PRODUCT_STATUS_ID" VARCHAR2(32 BYTE), 
	"PRODUCT_CRTD_ID" VARCHAR2(40 BYTE), 
	"PRODUCT_CRTD_DT" DATE, 
	"PRODUCT_UPDT_ID" VARCHAR2(40 BYTE), 
	"PRODUCT_UPDT_DT" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table PRODUCT_STATUS
--------------------------------------------------------

  CREATE TABLE "PRODUCT_STATUS" 
   (	"PRODUCT_STATUS_ID" VARCHAR2(32 BYTE) DEFAULT SYS_GUID(), 
	"PRODUCT_STATUS_DESC" VARCHAR2(32 BYTE), 
	"PRODUCT_STATUS_CRTD_ID" VARCHAR2(40 BYTE), 
	"PRODUCT_STATUS_CRTD_DT" DATE, 
	"PRODUCT_STATUS_UPDT_ID" VARCHAR2(40 BYTE), 
	"PRODUCT_STATUS_UPDT_DT" DATE
   ) ;
--------------------------------------------------------
--  DDL for Index CUSTOMER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "CUSTOMER_PK" ON "CUSTOMER" ("CUSTOMER_ID") 
  ;
--------------------------------------------------------
--  DDL for Index ORDERS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "ORDERS_PK" ON "ORDERS" ("ORDERS_ID") 
  ;
--------------------------------------------------------
--  DDL for Index ORDERS_LINE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "ORDERS_LINE_PK" ON "ORDERS_LINE" ("ORDERS_LINE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PRODUCT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PRODUCT_PK" ON "PRODUCT" ("PRODUCT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index PRODUCT_STATUS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PRODUCT_STATUS_PK" ON "PRODUCT_STATUS" ("PRODUCT_STATUS_ID") 
  ;

--------------------------------------------------------
--  Constraints for Table CUSTOMER
--------------------------------------------------------

  ALTER TABLE "CUSTOMER" MODIFY ("CUSTOMER_ID" NOT NULL ENABLE);
  ALTER TABLE "CUSTOMER" MODIFY ("CUSTOMER_FIRST_NAME" NOT NULL ENABLE);
  ALTER TABLE "CUSTOMER" MODIFY ("CUSTOMER_LAST_NAME" NOT NULL ENABLE);
  ALTER TABLE "CUSTOMER" MODIFY ("CUSTOMER_CRTD_ID" NOT NULL ENABLE);
  ALTER TABLE "CUSTOMER" MODIFY ("CUSTOMER_CRTD_DT" NOT NULL ENABLE);
  ALTER TABLE "CUSTOMER" MODIFY ("CUSTOMER_UPDT_ID" NOT NULL ENABLE);
  ALTER TABLE "CUSTOMER" MODIFY ("CUSTOMER_UPDT_DT" NOT NULL ENABLE);
  ALTER TABLE "CUSTOMER" ADD CONSTRAINT "CUSTOMER_PK" PRIMARY KEY ("CUSTOMER_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table ORDERS
--------------------------------------------------------

  ALTER TABLE "ORDERS" MODIFY ("ORDERS_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" MODIFY ("ORDERS_DATE" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" MODIFY ("ORDERS_CUSTOMER_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" MODIFY ("ORDERS_CRTD_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" MODIFY ("ORDERS_CRTD_DT" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" MODIFY ("ORDERS_UPDT_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" MODIFY ("ORDERS_UPDT_DT" NOT NULL ENABLE);
  ALTER TABLE "ORDERS" ADD CONSTRAINT "ORDERS_PK" PRIMARY KEY ("ORDERS_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table ORDERS_LINE
--------------------------------------------------------

  ALTER TABLE "ORDERS_LINE" MODIFY ("ORDERS_LINE_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS_LINE" MODIFY ("ORDERS_LINE_ORDERS_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS_LINE" MODIFY ("ORDERS_LINE_PRODUCT_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS_LINE" MODIFY ("ORDERS_LINE_QTY" NOT NULL ENABLE);
  ALTER TABLE "ORDERS_LINE" MODIFY ("ORDERS_LINE_PRICE" NOT NULL ENABLE);
  ALTER TABLE "ORDERS_LINE" MODIFY ("ORDERS_LINE_CRTD_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS_LINE" MODIFY ("ORDERS_LINE_CRTD_DT" NOT NULL ENABLE);
  ALTER TABLE "ORDERS_LINE" MODIFY ("ORDERS_LINE_UPDT_ID" NOT NULL ENABLE);
  ALTER TABLE "ORDERS_LINE" MODIFY ("ORDERS_LINE_UPDT_DT" NOT NULL ENABLE);
  ALTER TABLE "ORDERS_LINE" ADD CONSTRAINT "ORDERS_LINE_PK" PRIMARY KEY ("ORDERS_LINE_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table PRODUCT
--------------------------------------------------------

  ALTER TABLE "PRODUCT" MODIFY ("PRODUCT_ID" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT" MODIFY ("PRODUCT_NAME" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT" MODIFY ("PRODUCT_DESC" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT" MODIFY ("PRODUCT_PRODUCT_STATUS_ID" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT" MODIFY ("PRODUCT_CRTD_ID" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT" MODIFY ("PRODUCT_CRTD_DT" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT" MODIFY ("PRODUCT_UPDT_ID" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT" MODIFY ("PRODUCT_UPDT_DT" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT" ADD CONSTRAINT "PRODUCT_PK" PRIMARY KEY ("PRODUCT_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table PRODUCT_STATUS
--------------------------------------------------------

  ALTER TABLE "PRODUCT_STATUS" MODIFY ("PRODUCT_STATUS_CRTD_ID" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT_STATUS" MODIFY ("PRODUCT_STATUS_CRTD_DT" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT_STATUS" MODIFY ("PRODUCT_STATUS_UPDT_ID" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT_STATUS" MODIFY ("PRODUCT_STATUS_ID" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT_STATUS" MODIFY ("PRODUCT_STATUS_DESC" NOT NULL ENABLE);
  ALTER TABLE "PRODUCT_STATUS" ADD CONSTRAINT "PRODUCT_STATUS_PK" PRIMARY KEY ("PRODUCT_STATUS_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "PRODUCT_STATUS" MODIFY ("PRODUCT_STATUS_UPDT_DT" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table ORDERS
--------------------------------------------------------

  ALTER TABLE "ORDERS" ADD CONSTRAINT "ORDERS_FK1" FOREIGN KEY ("ORDERS_CUSTOMER_ID")
	  REFERENCES "CUSTOMER" ("CUSTOMER_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ORDERS_LINE
--------------------------------------------------------

  ALTER TABLE "ORDERS_LINE" ADD CONSTRAINT "ORDERS_LINE_FK1" FOREIGN KEY ("ORDERS_LINE_ORDERS_ID")
	  REFERENCES "ORDERS" ("ORDERS_ID") ENABLE;
  ALTER TABLE "ORDERS_LINE" ADD CONSTRAINT "ORDERS_LINE_FK2" FOREIGN KEY ("ORDERS_LINE_PRODUCT_ID")
	  REFERENCES "PRODUCT" ("PRODUCT_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PRODUCT
--------------------------------------------------------

  ALTER TABLE "PRODUCT" ADD CONSTRAINT "PRODUCT_FK1" FOREIGN KEY ("PRODUCT_PRODUCT_STATUS_ID")
	  REFERENCES "PRODUCT_STATUS" ("PRODUCT_STATUS_ID") ENABLE;

CREATE OR REPLACE PROCEDURE PRC_CREATE_TRG01_TRIGGERS
(TABLE_NAME_IN VARCHAR2)
AS
V_SQL VARCHAR2(2000);
BEGIN

        V_SQL := 'CREATE OR REPLACE TRIGGER trg01_' || TABLE_NAME_IN || ' BEFORE ';
        V_SQL := V_SQL || ' INSERT OR UPDATE ON ' || TABLE_NAME_IN;
        V_SQL := V_SQL || ' FOR EACH ROW ';
        V_SQL := V_SQL || ' BEGIN';
        V_SQL := V_SQL || ' IF inserting THEN ';
        V_SQL := V_SQL || ' :new.' || TABLE_NAME_IN || '_crtd_id := user;';
        V_SQL := V_SQL || ' :new.' || TABLE_NAME_IN || '_crtd_dt := sysdate;';
        V_SQL := V_SQL || ' END IF;';
        V_SQL := V_SQL || ' :new.' || TABLE_NAME_IN || '_updt_id := user;';
        V_SQL := V_SQL || ' :new.' || TABLE_NAME_IN || '_updt_dt := sysdate;';
        V_SQL := V_SQL || ' END;';
        
        EXECUTE IMMEDIATE V_SQL;

    
END;
/
CREATE OR REPLACE PROCEDURE PRC_CREATE_TRG02_TRIGGERS
(TABLE_NAME_IN VARCHAR2,
 COLUMN_NAME_IN VARCHAR2)
AS
V_SQL VARCHAR2(2000);

BEGIN
        V_SQL := 'CREATE OR REPLACE TRIGGER trg02_' || TABLE_NAME_IN || ' BEFORE ';
        V_SQL := V_SQL || ' INSERT OR UPDATE ON ' || TABLE_NAME_IN;
        V_SQL := V_SQL || ' FOR EACH ROW ';
        V_SQL := V_SQL || ' BEGIN';
        V_SQL := V_SQL || ' IF inserting THEN ';
        V_SQL := V_SQL || ' IF :NEW.' || COLUMN_NAME_IN  || ' IS NULL THEN ';
        V_SQL := V_SQL || ' :NEW.' || COLUMN_NAME_IN || ' := SYS_GUID();';
        V_SQL := V_SQL || ' END IF;';
        V_SQL := V_SQL || ' END IF;';
        V_SQL := V_SQL || ' IF UPDATING THEN';
        V_SQL := V_SQL || ' :NEW.' || COLUMN_NAME_IN || ' := :OLD.' || COLUMN_NAME_IN || ';';
        V_SQL := V_SQL || ' END IF;';
        V_SQL := V_SQL || ' END;';
        
        
        EXECUTE IMMEDIATE V_SQL;
    
    
END;
/
create or replace PROCEDURE prc_create_triggers as

  CURSOR C_TABLES IS
  SELECT * FROM USER_TABLES;
  
  FUNCTION GET_PK(TABLE_NAME_IN VARCHAR2)
  RETURN VARCHAR2
  AS
    V_KEY_COL VARCHAR2(200);  
  
  BEGIN
  SELECT UCC.COLUMN_NAME
    INTO V_KEY_COL
    FROM SYS.user_constraints UC
    INNER JOIN user_cons_columns UCC
    ON UC.OWNER = UCC.OWNER
    AND UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
    WHERE CONSTRAINT_TYPE = 'P'
    AND UC.TABLE_NAME = TABLE_NAME_IN;

    RETURN V_KEY_COL;
  
  END;
BEGIN
    FOR R_TABLE IN C_TABLES
    LOOP    
        PRC_CREATE_TRG01_TRIGGERS(R_TABLE.TABLE_NAME);
        PRC_CREATE_TRG02_TRIGGERS(R_TABLE.TABLE_NAME, GET_PK(R_TABLE.TABLE_NAME));
    END LOOP;
END;
/

BEGIN
  PRC_CREATE_TRIGGERS();
END;
/


CREATE OR REPLACE PACKAGE pkg_data AS
    TYPE varray IS
        VARRAY(1000) OF VARCHAR2(50);
    PROCEDURE create_customers (
        nbr_cust_in NUMBER
    );
    PROCEDURE create_orders (
        nbr_cust_in NUMBER
    );
    
END pkg_data;
/

CREATE OR REPLACE PACKAGE BODY pkg_data wrapped 
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
8079 31a6
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
LHt41sQ=

/


BEGIN
  PKG_DATA.CREATE_CUSTOMERS(50);
  PKG_DATA.CREATE_ORDERS(500);
END;
/
COMMIT;


CREATE TABLE gender (
    gender_id      VARCHAR2(32) NOT NULL,
    gender_name    VARCHAR2(20) NOT NULL,
    gender_crtd_id VARCHAR2(40) NOT NULL,
    gender_crtd_dt DATE NOT NULL,
    gender_updt_id VARCHAR2(40) NOT NULL,
    gender_updt_dt DATE NOT NULL,
    CONSTRAINT gender_pk PRIMARY KEY ( gender_id ) ENABLE
);

ALTER TABLE GENDER  
MODIFY (GENDER_ID DEFAULT sys_guid() );

BEGIN
  PRC_CREATE_TRIGGERS();
END;
/

ALTER TABLE customer ADD (
    customer_gender_id VARCHAR2(32)
);

INSERT INTO gender ( gender_name )
    SELECT DISTINCT
        customer_gender
    FROM
        customer;

UPDATE customer c
SET
    customer_gender_id = (
        SELECT
            g.gender_id
        FROM
            gender g
        WHERE
            g.gender_name = c.customer_gender
    );

ALTER TABLE customer DROP COLUMN customer_gender;

ALTER TABLE customer
    ADD CONSTRAINT customer_fk1 FOREIGN KEY ( customer_gender_id )
        REFERENCES gender ( gender_id )
    ENABLE;


UPDATE GENDER
SET GENDER_NAME = 'Transgender'
where GENDER_NAME = 'Transgendr';
commit;

CREATE TABLE product_price (
    product_price_id         VARCHAR2(32) NOT NULL,
    product_price_product_id VARCHAR2(32) NOT NULL,
    product_price_eff_date   DATE NOT NULL,
    product_price_price      NUMBER(9, 2) NOT NULL,
    product_price_crtd_id    VARCHAR2(40) NOT NULL,
    product_price_crtd_dt    DATE NOT NULL,
    product_price_updt_id    VARCHAR2(40) NOT NULL,
    product_price_updt_dt    DATE NOT NULL,
    CONSTRAINT product_price_pk PRIMARY KEY ( product_price_id ) ENABLE
);

ALTER TABLE product_price
    ADD CONSTRAINT product_price_fk1 FOREIGN KEY ( product_price_product_id )
        REFERENCES product ( product_id )
    ENABLE;

ALTER TABLE product_price ADD CONSTRAINT product_price_chk1 CHECK ( product_price_price > 0 ) ENABLE;

BEGIN
  PRC_CREATE_TRIGGERS();
END;
/

set appinfo on
select 'Begin Executing ' || sys_context('USERENV', 'MODULE') MSG  from dual;

CREATE TABLE ADDRESS 
(
  ADDRESS_ID VARCHAR2(32) NOT NULL 
, ADDRESS_LINE1 VARCHAR2(50) NOT NULL 
, ADDRESS_LINE2 VARCHAR2(50) 
, ADDRESS_LINE3 VARCHAR2(50) 
, ADDRESS_CITY VARCHAR2(40) NOT NULL 
, ADDRESS_STATE CHAR(2) NOT NULL 
, ADDRESS_ZIP VARCHAR2(9) NOT NULL 
, ADDRESS_CRTD_ID VARCHAR2(40) NOT NULL 
, ADDRESS_CRTD_DT DATE NOT NULL 
, ADDRESS_UPDT_ID VARCHAR2(40) NOT NULL 
, ADDRESS_UPDT_DT DATE NOT NULL 
, CONSTRAINT ADDRESS_PK PRIMARY KEY 
  (
    ADDRESS_ID 
  )
  ENABLE 
);

CREATE TABLE ADDRESS_TYPE 
(
  ADDRESS_TYPE_ID VARCHAR2(32) NOT NULL 
, ADDRESS_TYPE_DESC VARCHAR2(10) NOT NULL 
, ADDRESS_TYPE_CRTD_ID VARCHAR2(40) NOT NULL 
, ADDRESS_TYPE_CRTD_DT DATE NOT NULL 
, ADDRESS_TYPE_UPDT_ID VARCHAR2(40) NOT NULL 
, ADDRESS_TYPE_UPDT_DT DATE NOT NULL 
, CONSTRAINT ADDRESS_TYPE_PK PRIMARY KEY 
  (
    ADDRESS_TYPE_ID 
  )
  ENABLE 
);


CREATE TABLE CUSTOMER_ADDRESS 
(
  CUSTOMER_ADDRESS_ID VARCHAR2(32) NOT NULL 
, CUSTOMER_ADDRESS_CUSTOMER_ID VARCHAR2(32) NOT NULL 
, CUSTOMER_ADDRESS_ADDRESS_ID VARCHAR2(32) NOT NULL 
, CUSTOMER_ADDRESS_ADDRESS_TYPE_ID VARCHAR2(32) NOT NULL 
, CUSTOMER_ADDRESS_ACTV_IND NUMBER(1) NOT NULL 
, CUSTOMER_ADDRESS_DEFAULT_IND NUMBER(1) NOT NULL 
, CUSTOMER_ADDRESS_CRTD_ID VARCHAR2(40) NOT NULL 
, CUSTOMER_ADDRESS_CRTD_DT DATE NOT NULL 
, CUSTOMER_ADDRESS_UPDT_ID VARCHAR2(40) NOT NULL 
, CUSTOMER_ADDRESS_UPDT_DT DATE NOT NULL 
, CONSTRAINT CUSTOMER_ADDRESS_PK PRIMARY KEY 
  (
    CUSTOMER_ADDRESS_ID 
  )
  ENABLE 
);

ALTER TABLE CUSTOMER_ADDRESS
ADD CONSTRAINT CUSTOMER_ADDRESS_FK1 FOREIGN KEY
(
  CUSTOMER_ADDRESS_CUSTOMER_ID 
)
REFERENCES CUSTOMER
(
  CUSTOMER_ID 
)
ENABLE;

ALTER TABLE CUSTOMER_ADDRESS
ADD CONSTRAINT CUSTOMER_ADDRESS_FK2 FOREIGN KEY
(
  CUSTOMER_ADDRESS_ADDRESS_ID 
)
REFERENCES ADDRESS
(
  ADDRESS_ID 
)
ENABLE;

ALTER TABLE CUSTOMER_ADDRESS
ADD CONSTRAINT CUSTOMER_ADDRESS_FK3 FOREIGN KEY
(
  CUSTOMER_ADDRESS_ADDRESS_TYPE_ID 
)
REFERENCES ADDRESS_TYPE
(
  ADDRESS_TYPE_ID 
)
ENABLE;

CREATE TABLE order_status (
    order_status_id                   VARCHAR2(32) NOT NULL,
    order_status_desc                 VARCHAR2(20) NOT NULL,
    order_status_next_order_status_id VARCHAR2(32),
    order_status_crtd_id              VARCHAR2(40) NOT NULL,
    order_status_crtd_dt              DATE NOT NULL,
    order_status_updt_id              VARCHAR2(40) NOT NULL,
    order_status_updt_dt              DATE NOT NULL,
    CONSTRAINT order_status_pk PRIMARY KEY ( order_status_id ) ENABLE
);

ALTER TABLE ORDER_STATUS
ADD CONSTRAINT ORDER_STATUS_FK1 FOREIGN KEY
(
  ORDER_STATUS_NEXT_ORDER_STATUS_ID 
)
REFERENCES ORDER_STATUS
(
  ORDER_STATUS_ID 
)
DEFERRABLE INITIALLY DEFERRED
ENABLE;



CREATE TABLE ORDER_STATE 
(
  ORDER_STATE_ID VARCHAR2(32) NOT NULL 
, ORDER_STATE_ORDERS_ID VARCHAR2(32) NOT NULL 
, ORDER_STATE_ORDER_STATUS_ID VARCHAR2(32) NOT NULL 
, ORDER_STATE_EFF_DATE DATE NOT NULL 
, ORDER_STATE_CRTD_ID VARCHAR2(40) NOT NULL 
, ORDER_STATE_CRTD_DT DATE NOT NULL 
, ORDER_STATE_UPDT_ID VARCHAR2(40) NOT NULL 
, ORDER_STATE_UPDT_DT DATE NOT NULL 
, CONSTRAINT ORDER_STATE_PK PRIMARY KEY 
  (
    ORDER_STATE_ID 
  )
  ENABLE 
);

ALTER TABLE ORDER_STATE
ADD CONSTRAINT ORDER_STATE_FK1 FOREIGN KEY
(
  ORDER_STATE_ORDERS_ID 
)
REFERENCES ORDERS
(
  ORDERS_ID 
)
ENABLE;

ALTER TABLE ORDER_STATE
ADD CONSTRAINT ORDER_STATE_FK2 FOREIGN KEY
(
  ORDER_STATE_ORDER_STATUS_ID 
)
REFERENCES ORDER_STATUS
(
  ORDER_STATUS_ID 
)
ENABLE;

BEGIN
  PRC_CREATE_TRIGGERS();
END;
/


DECLARE
    V_NEW_STATUS VARCHAR2(32);
    V_PICKING_STATUS VARCHAR2(32);
    V_PICKED_STATUS VARCHAR2(32);
    V_SHIPPING_STATUS VARCHAR2(32);
    V_SHIPPED_STATUS VARCHAR2(32);
BEGIN
    V_NEW_STATUS := sys_guid();
    V_PICKING_STATUS:= sys_guid();
    V_PICKED_STATUS:= sys_guid();
    V_SHIPPING_STATUS:= sys_guid();
    V_SHIPPED_STATUS:= sys_guid();
    
    INSERT INTO ORDER_STATUS
    (order_status_id, order_status_desc, order_status_next_order_status_id)
    values
    (V_NEW_STATUS, 'New',V_PICKING_STATUS);

    INSERT INTO ORDER_STATUS
    (order_status_id, order_status_desc, order_status_next_order_status_id)
    values
    (V_PICKING_STATUS, 'Picking',V_PICKED_STATUS);

    INSERT INTO ORDER_STATUS
    (order_status_id, order_status_desc, order_status_next_order_status_id)
    values
    (V_PICKED_STATUS, 'Picked',V_SHIPPING_STATUS);

    INSERT INTO ORDER_STATUS
    (order_status_id, order_status_desc, order_status_next_order_status_id)
    values
    (V_SHIPPING_STATUS, 'Shipping',V_SHIPPED_STATUS);

    INSERT INTO ORDER_STATUS
    (order_status_id, order_status_desc, order_status_next_order_status_id)
    values
    (V_SHIPPED_STATUS, 'Shipped',null);
END;
/



CREATE OR REPLACE PACKAGE pkg_order AS
    PROCEDURE set_order_status (
        order_state_orders_id_in       orders.orders_id%TYPE,
        order_state_order_status_id_in order_state.order_state_order_status_id%TYPE,
        order_state_eff_date_in        order_state.order_state_eff_date%TYPE
    );

    PROCEDURE advance_order_status (
        orders_id_in            orders.orders_id%TYPE,
        order_state_eff_date_in order_state.order_state_eff_date%TYPE
    );

END pkg_order;
/

CREATE OR REPLACE PACKAGE BODY pkg_order AS

    FUNCTION fn_current_order_status (
        order_id_in VARCHAR2
    ) RETURN VARCHAR2 AS

        v_cnt NUMBER(3);
        CURSOR c_status IS
        SELECT
            *
        FROM
            (
                SELECT
                    order_status_id,
                    order_status_desc,
                    level lvl
                FROM
                    order_status
                CONNECT BY
                    PRIOR order_status_id = order_status_next_order_status_id
                START WITH order_status_next_order_status_id IS NULL
            )
        ORDER BY
            lvl;

    BEGIN
        FOR r_status IN c_status LOOP
            --dbms_output.put_line(r_status.order_status_desc);
            SELECT
                COUNT(*)
            INTO v_cnt
            FROM
                order_state
            WHERE
                    order_state_orders_id = order_id_in
                AND order_state_order_status_id = r_status.order_status_id;

            IF v_cnt > 0 THEN
                RETURN r_status.order_status_id;
            END IF;
        END LOOP;

        RETURN NULL;
    END fn_current_order_status;

    FUNCTION fn_next_status (
        order_status_id_in VARCHAR2
    ) RETURN VARCHAR2 AS
        v_next_order_status_id VARCHAR2(32);
        v_cnt                  NUMBER(1);
    BEGIN
        IF order_status_id_in IS NULL THEN
            SELECT
                order_status_id
            INTO v_next_order_status_id
            FROM
                order_status
            WHERE
                order_status_id NOT IN (
                    SELECT
                        order_status_next_order_status_id
                    FROM
                        order_status
                    WHERE
                        order_status_next_order_status_id IS NOT NULL
                );

            RETURN v_next_order_status_id;
        END IF;

        SELECT
            COUNT(*)
        INTO v_cnt
        FROM
            order_status
        WHERE
            order_status_id = order_status_id_in;

        IF v_cnt = 0 THEN
            RETURN NULL;
        END IF;
        SELECT
            order_status_next_order_status_id
        INTO v_next_order_status_id
        FROM
            order_status
        WHERE
            order_status_id = order_status_id_in;

        RETURN v_next_order_status_id;
    END fn_next_status;

    PROCEDURE set_order_status (
        order_state_orders_id_in       orders.orders_id%TYPE,
        order_state_order_status_id_in order_state.order_state_order_status_id%TYPE,
        order_state_eff_date_in        order_state.order_state_eff_date%TYPE
    ) AS
    BEGIN
        INSERT INTO order_state (
            order_state_id,
            order_state_orders_id,
            order_state_order_status_id,
            order_state_eff_date
        ) VALUES (
            sys_guid(),
            order_state_orders_id_in,
            order_state_order_status_id_in,
            order_state_eff_date_in
        );

    END set_order_status;

    PROCEDURE advance_order_status (
        orders_id_in            orders.orders_id%TYPE,
        order_state_eff_date_in order_state.order_state_eff_date%TYPE
    ) AS
        v_current_order_status_id VARCHAR2(32);
        v_next_order_status_id    VARCHAR2(32);
    BEGIN
        v_current_order_status_id := fn_current_order_status(orders_id_in);
        v_next_order_status_id := fn_next_status(v_current_order_status_id);
        IF v_next_order_status_id IS NOT NULL THEN
            set_order_status(orders_id_in, v_next_order_status_id, order_state_eff_date_in);
        END IF;
    END advance_order_status;

END pkg_order;
/
CREATE OR REPLACE PACKAGE pkg_data AS
    TYPE varray IS
        VARRAY(1000) OF VARCHAR2(50);
    PROCEDURE create_customers (
        nbr_cust_in NUMBER
    );

    PROCEDURE create_orders (
        nbr_cust_in NUMBER
    );

    PROCEDURE advance_random_orders (
        nbr_order_in NUMBER
    );

END pkg_data;
/
CREATE OR REPLACE PACKAGE BODY pkg_data AS

    vgender_names  varray := varray('Male', 'Female', 'Cisgender', 'Transgender', 'Nonbinary');
    vstreet_names1 varray := varray('Oak', 'Elm', 'Beaver', 'Quail', 'Red',
                                   'North', 'South', 'East', 'West', 'Green',
                                   'Farrell', 'Pinkerton', 'Derry', 'Vergennes', 'Silver',
                                   'Golden', 'Cavalier', 'Laurel', 'Connecticut', 'Columbia',
                                   'Hilltopper', 'Stirling', 'Silica', 'Norh', 'Yorkchester',
                                   'Ziegler', 'Crutch', 'Phyllis', 'Jaquar', 'Willakenzie',
                                   'Hard', 'Terry', 'Frankfort', 'Fews', 'Arapahoe',
                                   'Morrissey', 'Learning,', 'Monroe', 'Back', 'Cedar',
                                   'Ingram', 'Chestnut', 'Compton', 'Westminster', 'Hennepin',
                                   'Richley', 'Adams', 'Otterburn', 'Maverick', 'Level',
                                   'Pear', 'Rose', 'Medford', 'Summit', 'Swanwick',
                                   'Munchach', 'Miles', 'Plum', 'Misty', 'Ward',
                                   'Goodridge', 'Matthews', 'White', 'Olympian', 'Panorama',
                                   'Law', 'Lindsey', 'Barnes', 'Dunlap', 'Husky',
                                   'Pomona', 'Royal', 'Jacquard', 'Lunaliho', 'Cayuga',
                                   'Sugar', 'Kalanianaole', 'Ray', 'Monmouth', 'Tarrar',
                                   'Pettis', 'All', 'Genoa', 'Oakwood', 'Cabot',
                                   'Basse', 'Southridge', 'Shorehaven', 'Burcham', 'McCrimmon',
                                   'Keaau-Pahoa', 'Legion', 'Santa', 'Olinda', 'Waterhouse',
                                   'Goddard', 'Haygood', 'Maynard', 'East-West', 'Seeger');
    vstreet_names2 varray := varray('Ridge', 'Valley', 'Creek', 'Forest', 'Mill',
                                   'Ferry', 'River', 'Mountain', 'Hill', 'Woods',
                                   'Butternut', 'Kennedy', 'Loyalsock', 'Tusculum', 'Via',
                                   'Franconia', 'Fieldston', 'Grand', 'Perimeter', 'Nortus',
                                   'Westheimer', 'Yosemite', 'Slaughter', 'Hillyer', 'Points',
                                   'Hawkins', 'Smoky', 'Stabler', 'Cottonville', 'Lakota',
                                   'London', 'Georgetown', 'Mulberry', 'Avon', 'Grindstone',
                                   'Hornet', 'Jagerson', 'Aviation', 'Lamm', 'Hocking',
                                   'Uvalde', 'Appleyard', 'Nox', 'Bowman', 'Walzem',
                                   'Warrendale', 'Senecca', 'Perryville', 'Galloway', 'Clarke',
                                   'Admore', 'Walker', 'Peace', 'Southwest', 'Gifford',
                                   'Underwood', 'Thorne', 'Stanley', 'Harlin', 'Bryan',
                                   'Ferndale', 'Schubert', 'Lafayette', 'Vista', 'Voices',
                                   'Ohio', 'Shroyer', 'Telegraph', 'Higby', 'Hunsberger',
                                   'Middlebelt', 'Weymouth', 'Mapleton', 'Hollingsworth', 'Copeland',
                                   'Francis', 'Saulino', 'Hawthorne', 'Northeast', 'International',
                                   'Kamehameha', 'Huebner', 'Edgemere', 'Gorsuch', 'Chasepeak',
                                   'Rockfish', 'Riley', 'Elk', 'Ainsworth', 'Silo',
                                   'Aurora', 'Farmdale', 'Monte', 'Porter', 'Horsham',
                                   'Warfath', 'Widefield', 'Hillsmere', 'Crozier', 'Proffett');
    vstreet_names3 varray := varray('Street', 'Avenue', 'Court', 'Highway', 'Lane',
                                   'Parkway', 'Circle', 'Road', 'Boulevard', 'Crossing',
                                   'S.W.', 'Rdg.', 'Ne', 'Alley', 'HS',
                                   'S.E.', 'Dr', 'Bldg', 'rrugÃƒÆ’Ã‚Â«', 'Section',
                                   'Walk', 'Promenade', 'Northeast', 'Commune', 'Complex',
                                   'Essex', 'Trail', 'Terrace', 'Hwy', 'Route',
                                   'Development', 'Drive', 'Studios', 'Annex', 'Commission',
                                   'Spur', 'Academies', 'Yard', 'Preserve', 'South',
                                   'Ministry', 'Ulica', 'Strada', 'Rue', 'Straat',
                                   'Carrer', 'Calle', 'Gata', 'Ulice', 'CestnÃƒÆ’Ã‚Â¡',
                                   'Route', 'Estrada', 'Via', 'Tee', 'Jalan',
                                   'Building', 'Floor', 'House', 'Assembly', 'Rd');
    vemail1        varray := varray('Big', 'Little', 'Happy', 'Red', 'Green',
                            'Top', 'Silver', 'Golden', 'Deep', 'Wide',
                            'Wig.', 'Smile.', 'Fig.', 'Yellow.', 'Orange.',
                            'Bottom.', 'Train.', 'Dog.', 'Merry.', 'Hope.',
                            'Ja', 'Nein', 'Danke', 'Vielen', 'Dank',
                            'Guten', 'Tag', 'Gute', 'Wie', 'Nacht',
                            'smanning.', 'cosima.', 'hendrix.', 'rduncan.', 'magchan.',
                            'insight.', 'swan.', 'chicken.', 'delphine.', 'monkey.',
                            'The.', 'yoyo', 'lorax', 'Yo.', 'Milo.',
                            'Fanta.', 'Vamp.', 'Sir.', 'Hairy.', 'Vanilla.',
                            'oui', 'vous', 'merci', 'voici', 'bonne',
                            'nuit', 'pas', 'sais', 'pouvez', 'voudrais',
                            'silver', 'zeus', 'mint', 'opt', 'clear',
                            'oiy', 'puppy', 'soap', 'canny', 'savvy',
                            'buenos', 'dias', 'noches', 'mucho', 'gusto',
                            'hasta', 'adios', 'luego', 'siento', 'por',
                            'bus.', 'love.', 'open.', 'violin.', 'boxer.',
                            'mud.', 'steward.', 'paws.', 'fingers.', 'snake.',
                            'Grazie', 'Prego.', 'Salve', 'Ciao.', 'Addio',
                            'Buona.', 'Parla', 'Cosi.', 'Pepe', 'Manzo.');
    vemail2        varray := varray('Cars', 'Bells', 'Tiger', 'Dog', 'Cat',
                            'Mountain', 'Tree', 'Key', 'Feather', 'Road',
                            'swim', 'foot', 'door', 'tennis', 'mop',
                            'quiche', 'onion', 'circle', 'deco', 'clay',
                            'Biz', 'Chocolate', 'Sunshine', 'Bead', 'Gamer',
                            'Shy', 'One', 'Apple', 'Whale', 'Rose',
                            'leda', 'castor', 'cloneclub', 'agricola', 'drmoreau',
                            'orphan', 'black', 'bchild', 'dyad', 'art',
                            'bis', 'muto', 'adepto', 'mora', 'aptus',
                            'barba', 'colo', 'decorus', 'mox', 'levo',
                            'hunc', 'Tendo', 'gravo', 'Rumor', 'Solus',
                            'Sane', 'Tamen', 'Levis', 'lam', 'hodiernus',
                            'Sinistra', 'Destra', 'Lontano', 'Vincino', 'Lungo',
                            'Corto', 'Breve', 'Museo', 'Banca', 'Negozio',
                            'Scuola', 'Chiesa', 'Valle', 'Collina', 'Picco',
                            'Monte', 'Lago', 'Fiume', 'Piscina', 'Torre',
                            'Ponte', 'febbraio', 'oggi', 'leri', 'compleanno',
                            'maggio', 'estate', 'duco', 'cerno', 'dexter',
                            'Pipeline', 'Doster', 'Club', 'Tribe', 'Clan',
                            'Ski', 'West', 'East', 'South', 'North');
    vemail3        varray := varray('Pacific.com', 'Caribbean.com', 'Indian.net', 'Bering.net', 'Arabian.com',
                            'Tasman.com', 'Barents.com', 'Antarctic.com', 'Mediterranean.com', 'Atlantic.com',
                            'countermail.com', 'neomailbox.com', 'runbox.net', 'safemail.net', 'vmail.com',
                            'mutemail.com', 'crypto.com', 'sestra.com', 'rediff.com', 'zoho.com',
                            'moonshine.com', 'copperhead.com', 'starfeet.net', 'fonstuff.net', 'reference.com',
                            'ncs.com', 'hostit.com', 'baggins.com', 'augustus.com', 'zebra.com',
                            'bluelight.com', 'adelphia.com', 'prodigy.net', 'netzero.net', 'juno.com',
                            'toucan.com', 'flash.com', 'mindspring.com', 'brutus.com', 'celtic.com',
                            'starmail.com', 'mailbox.com', 'batbox.net', 'speedymail.net', 'xyzmail.com',
                            'sunshinel.com', 'heaven.com', 'brosestra.com', 'bluedriff.com', 'whoho.com',
                            'siu.edu', 'sife.org', 'isdls.org', 'ri.org', 'sprintmail.com',
                            'gmail.com', 'worldboston.org', 'ihrco.com', 'ajshotels.com', 'hilton.com',
                            'knology.net', 'theinter.com', 'aloha.com', 'ihclt.org', 'radisson.com',
                            'phelpsstokes.org', 'jsums.edu', 'adnc.com', 'onondagacoach.com', 'twinlimo.com',
                            'infionline.net', 'eurocentres.com', 'Grandecom.net', 'understandourworld.org', 'ivcdetroit.org',
                            'aviahotels.com', 'cdsintl.org', 'quincysuites.com', 'aaionline.org', 'indigoinn.com',
                            'hitlon.com', 'wyndham.com', 'agreatwaytogo.com', 'northstate.net', 'kdsi.net',
                            'sheratonkc.com', 'innisfree.com', 'hotmail.com', 'miusa.org', 'aiesecus.org',
                            'bc.edu', 'irex.org', 'jalc.org', 'usicomos.org', 'bu.edu',
                            'internationalsport.com', 'kennesaw.edu', 'wtci.org', 'umn.edu', 'yahoo.co.uk');
    v_product_name varray := varray('Kia Forte', 'Chery A5', 'Suzuki Celerio', 'Lykan HyperSport', 'Ferrari 488',
                                   'Toyota Land Cruiser Prado', 'Mercedes-Benz SLK-Class', 'Mercedes-Benz SL-Class (R231)', 'Lexus LFA',
                                   'Ã…Â koda Octavia',
                                   'Honda Brio', 'Ford Taurus (sixth generation)', 'McLaren P1', 'Volkswagen Jetta Pionier', 'Suzuki Lapin',
                                   'Ascari KZ1', 'Mitsubishi Mirage', 'Infiniti M', 'Volvo XC90', 'Honda N-One',
                                   'Opel Adam', 'Lada Riva', 'Ã…Â koda Rapid (2011)', 'Renault Espace', 'Nissan NV (North America)',
                                   'BMW X5', 'BMW 2 Series (F22)', 'Nissan Armada', 'Daihatsu Sigra', 'Nissan Qashqai',
                                   'BMW 5 Series Gran Turismo', 'Hyundai ix20', 'Hyundai Veracruz', 'Opel Mokka', 'Jeep Compass',
                                   'Porsche 991', 'Volkswagen Atlas', 'Volkswagen Scirocco', 'Daewoo Lacetti', 'Buick Park Avenue',
                                   'Smart Forfour', 'Honda Clarity', 'Lancia Ypsilon', 'CitroÃƒÂ«n C2', 'Bentley Continental Flying Spur (2005)',
                                   'Range Rover Sport', 'Cadillac DTS', 'Alfa Romeo GT', 'Fiat Grande Punto', 'Toyota Allion',
                                   'Audi Q7', 'Ferrari California', 'Lexus CT', 'Toyota 86', 'BMW M4',
                                   'Honda S660', 'Chevrolet Captiva', 'Peugeot 5008', 'Mercedes-Benz GLA-Class', 'Alfa Romeo Stelvio',
                                   'Renault Clio', 'Mahindra Quanto', 'Renault Laguna', 'Audi Q3', 'Acura RDX',
                                   'CitroÃƒÂ«n C6', 'Infiniti QX80', 'Suzuki Ignis', 'Pontiac Solstice', 'Honda BR-V',
                                   'BYD e6', 'Tata Indigo', 'Great Wall Voleex C30', 'Renault Fluence Z.E.', 'Mazdaspeed3',
                                   'SsangYong Musso', 'Toyota Aygo', 'Chevrolet Cobalt', 'Lada Granta', 'Renault Koleos',
                                   'Volvo S40', 'Mercedes-Maybach 6', 'Tata Aria', 'Cadillac CTS', 'Ford Fusion (Americas)',
                                   'SEAT Altea', 'Vehicle Production Group', 'Lotus Evora', 'Audi A3', 'Perodua Bezza',
                                   'Saturn Vue', 'Volkswagen Touareg', 'Volkswagen Jetta', 'Land Rover Discovery Sport', 'Chevrolet Volt (second generation)',
                                   'Ford EcoSport', 'Toyota Belta', 'Jaguar F-Pace', 'Geely CK', 'Lotus Elise');
    v_prsn_name    varray := varray('Aaronson', 'Abra', 'Absa', 'Abshier', 'Adaiha',
                                'Adama', 'Adams', 'Addi', 'Addia', 'Adebayo',
                                'Adelaida', 'Adey', 'Adriaens', 'Adrian', 'Adrianna',
                                'Adriene', 'Aguste', 'Aia', 'Airlie', 'Alair',
                                'Albin', 'Alburga', 'Aldercy', 'Alek', 'Alessandra',
                                'Aleta', 'Alfi', 'Algy', 'Alis', 'Alitta',
                                'Allcot', 'Alodie', 'Alpheus', 'Alrick', 'Alvie',
                                'Alysa', 'Alyson', 'Alysoun', 'Amadeus', 'Amand',
                                'Amaris', 'Amati', 'Amend', 'Amick', 'Amity',
                                'An', 'Ananna', 'Anastase', 'Anastasius', 'Ancelin',
                                'Andrea', 'Anissa', 'Anjali', 'Anna-Diana', 'Annecorinne',
                                'Anurag', 'Any', 'Anya', 'Aphra', 'Aprilette',
                                'Ardeth', 'Areta', 'Arezzini', 'Argile', 'Arissa',
                                'Armbruster', 'Arni', 'Arratoon', 'Artemus', 'Asare',
                                'Ashlen', 'Ashli', 'Asia', 'Askari', 'Astra',
                                'Aubert', 'Auburta', 'Aubyn', 'Aurel', 'Azaria',
                                'Badger', 'Baggett', 'Bailie', 'Ban', 'Baptista',
                                'Barber', 'Barfuss', 'Barkley', 'Barnes', 'Barnet',
                                'Barrie', 'Basilio', 'Bass', 'Baxie', 'Bayer',
                                'Beau', 'Beaudoin', 'Beaulieu', 'Bebe', 'Beghtol',
                                'Beichner', 'Beilul', 'Belcher', 'Bellda', 'Benzel',
                                'Bergren', 'Berkow', 'Bertelli', 'Bertilla', 'Beryle',
                                'Bess', 'Bessy', 'Binah', 'Bing', 'Birecree',
                                'Birkner', 'Bishop', 'Blinnie', 'Block', 'Blondell',
                                'Bluhm', 'Blumenthal', 'Blythe', 'Boar', 'Boffa',
                                'Bolger', 'Bolton', 'Bondy', 'Boonie', 'Bopp',
                                'Borras', 'Bortz', 'Bouchier', 'Bourn', 'Bovill',
                                'Bowlds', 'Bowyer', 'Boyden', 'Bracci', 'Bradwell',
                                'Brady', 'Branch', 'Branden', 'Brandon', 'Brasca',
                                'Brebner', 'Brew', 'Brig', 'Brigida', 'Broder',
                                'Buck', 'Buckingham', 'Buehrer', 'Burkhardt', 'Burra',
                                'Buseck', 'Bushey', 'Button', 'Byrne', 'Bywaters',
                                'Calabresi', 'Call', 'Camel', 'Camila', 'Campman',
                                'Caniff', 'Cannell', 'Carder', 'Carita', 'Carry',
                                'Case', 'Casimir', 'Cassandry', 'Cassy', 'Castillo',
                                'Castro', 'Catherin', 'Cathrin', 'Chambers', 'Chandler',
                                'Chappy', 'Charie', 'Charlotte', 'Chellman', 'Cherise',
                                'Cheshire', 'Chiaki', 'Chisholm', 'Chrisman', 'Christean',
                                'Christian', 'Christiane', 'Christis', 'Chrotoem', 'Chrystel',
                                'Ciapas', 'Cicero', 'Cindie', 'Cinnamon', 'Ciro',
                                'Claiborn', 'Clarisa', 'Clarita', 'Clayborn', 'Clayborne',
                                'Cleopatra', 'Cocks', 'Cohberg', 'Cohl', 'Cointon',
                                'Colb', 'Coltun', 'Concha', 'Coniah', 'Conlan',
                                'Constance', 'Corabel', 'Cordelia', 'Cormick', 'Cornell',
                                'Cornie', 'Corny', 'Corotto', 'Cosma', 'Craner',
                                'Crary', 'Creath', 'Crellen', 'Crispin', 'Cristabel',
                                'Croteau', 'Cruce', 'Crysta', 'Curran', 'Cybill',
                                'Cyndy', 'Dabney', 'Daffodil', 'Damek', 'Danica',
                                'Danni', 'Daphna', 'Darcey', 'Darrick', 'Darton',
                                'Daveen', 'Davie', 'Ddene', 'Debbie', 'Deborah',
                                'Delaney', 'Delwin', 'Demetris', 'Demitria', 'Dempsey',
                                'Denman', 'Deppy', 'Deragon', 'Derk', 'Derna',
                                'Derwood', 'Desirae', 'Dewain', 'Dewhurst', 'Diantha',
                                'Dincolo', 'Dionne', 'Dodwell', 'Dogs', 'Dolf',
                                'Donnenfeld', 'Doscher', 'Dott', 'Dotti', 'Dougherty',
                                'Doughman', 'Dragelin', 'Drolet', 'Drusus', 'Dukey',
                                'Durst', 'Dusen', 'Eade', 'Eckel', 'Edwyna',
                                'Eidson', 'Eiger', 'Eisler', 'Eldwon', 'Eleanore',
                                'Elfrida', 'Eliath', 'Elihu', 'Elliot', 'Elsy',
                                'Elvia', 'Em', 'Emilia', 'Emmott', 'Eolande',
                                'Er', 'Erhard', 'Erie', 'Errick', 'Erroll',
                                'Ervin', 'Eshelman', 'Etti', 'Eustatius', 'Evan',
                                'Everard', 'Ez', 'Fachini', 'Fagen', 'Fagin',
                                'Fahland', 'Fanechka', 'Fanya', 'Farica', 'Farika',
                                'Farlie', 'Fauman', 'Favata', 'Fayina', 'Featherstone',
                                'Feeley', 'Feingold', 'Fennell', 'Fennessy', 'Fernyak',
                                'Ferro', 'Fiann', 'Fidelio', 'Fields', 'Fifine',
                                'Figone', 'Fillander', 'Fleming', 'Fontana', 'Forrest',
                                'Forsta', 'Francesca', 'Frasch', 'Frasier', 'Fredel',
                                'French', 'Fronia', 'Fronniah', 'Frost', 'Fryd',
                                'Furey', 'Gabe', 'Gabi', 'Gaddi', 'Galven',
                                'Gannie', 'Gapin', 'Gardy', 'Garey', 'Gargan',
                                'Geer', 'Geibel', 'Geldens', 'Genevieve', 'Genevra',
                                'Genisia', 'Geno', 'George', 'Georgeanne', 'Geraud',
                                'Gereld', 'Gerkman', 'Germann', 'Gerome', 'Gerrald',
                                'Gertrude', 'Gigi', 'Gilchrist', 'Gilmour', 'Ginevra',
                                'Gittle', 'Giusto', 'Glick', 'Gnni', 'Goddard',
                                'Golden', 'Goldsmith', 'Goldsworthy', 'Golightly', 'Gollin',
                                'Goody', 'Goran', 'Gould', 'Graehme', 'Grail',
                                'Grange', 'Grearson', 'Greenwood', 'Grenville', 'Grissom',
                                'Grounds', 'Gruber', 'Guevara', 'Guibert', 'Guild',
                                'Gulgee', 'Gunther', 'Gurevich', 'Gustavus', 'Gustie',
                                'Gypsy', 'Hachman', 'Haddad', 'Haff', 'Hakan',
                                'Haleigh', 'Hallett', 'Hallock', 'Hamann', 'Hamid',
                                'Hamlen', 'Hannibal', 'Hansen', 'Hanzelin', 'Hardin',
                                'Harley', 'Hartmunn', 'Harwill', 'Haughay', 'Haukom',
                                'Hecht', 'Hedelman', 'Hedgcock', 'Heidi', 'Heilner',
                                'Helve', 'Henri', 'Henriha', 'Henryetta', 'Hephzipah',
                                'Hermina', 'Herodias', 'Herrmann', 'Heti', 'Hett',
                                'Heyman', 'Hicks', 'Hindorff', 'Hirsh', 'Hitchcock',
                                'Hitoshi', 'Hluchy', 'Hock', 'Hogan', 'Hoi',
                                'Holden', 'Hollenbeck', 'Hollister', 'Honniball', 'Hooge',
                                'Hoopes', 'Horter', 'Horwitz', 'Houghton', 'Hourihan',
                                'Hugh', 'Huldah', 'Humph', 'Hung', 'Hussein',
                                'Hyrup', 'Iaria', 'Ibbie', 'Ibrahim', 'Idoux',
                                'Iiette', 'Ilke', 'Immanuel', 'Ingrim', 'Ireland',
                                'Isa', 'Isaiah', 'Island', 'Ivah', 'Ivanah',
                                'Jacqui', 'Jago', 'Jakob', 'Jamesy', 'Jamila',
                                'Jania', 'Jann', 'Jasisa', 'Jayson', 'Jecoa',
                                'Jeconiah', 'Jehiah', 'Jemie', 'Jenne', 'Jennine',
                                'Jerrome', 'Jo', 'Joe', 'Joerg', 'Jone',
                                'Jordain', 'Jordanna', 'Josey', 'Joyann', 'Joye',
                                'Jueta', 'Juliann', 'Julieta', 'Junina', 'Kal',
                                'Kamp', 'Karina', 'Karlin', 'Karp', 'Kauslick',
                                'Kawai', 'Kellina', 'Kendyl', 'Kentigerma', 'Kenway',
                                'Kerge', 'Keverian', 'Khichabia', 'Khoury', 'Kikelia',
                                'Killarney', 'Kimitri', 'Kimmi', 'Kirchner', 'Kirst',
                                'Kirstyn', 'Kirwin', 'Kleiman', 'Kloster', 'Kneeland',
                                'Koffler', 'Koser', 'Krasner', 'Krasnoff', 'Kraul',
                                'Kroll', 'Kruse', 'Krystin', 'Kunin', 'Kylila',
                                'La Verne', 'Lacombe', 'Lais', 'Lambard', 'Lamont',
                                'Landa', 'Lanford', 'Lanita', 'Lanta', 'Lattonia',
                                'Launcelot', 'Laurens', 'Leahey', 'Lemar', 'Lenna',
                                'Lesslie', 'Leverick', 'Levesque', 'Levison', 'Leyla',
                                'Libna', 'Lilli', 'Lillian', 'Lily', 'Lindeberg',
                                'Lindholm', 'Lindi', 'Lindsey', 'Ling', 'Link',
                                'Linkoski', 'Lipfert', 'Lisetta', 'Lisette', 'Lissak',
                                'Liz', 'Lombard', 'Lopes', 'Lorant', 'Lorenz',
                                'Losse', 'Lovato', 'Lovell', 'Lovett', 'Lowson',
                                'Lucius', 'Lunetta', 'Lussier', 'Lyris', 'Lyudmila',
                                'Macario', 'MacIntosh', 'MacLean', 'Madelyn', 'Madonia',
                                'Magavern', 'Magda', 'Maison', 'Maje', 'Malamut',
                                'Mallen', 'Mandal', 'Manlove', 'Manning', 'Margit',
                                'Margreta', 'Mariande', 'Marie-Jeanne', 'Mariquilla', 'Marissa',
                                'Marks', 'Marozik', 'Marr', 'Martell', 'Martina',
                                'Massingill', 'Mastrianni', 'Mathias', 'Mathilda', 'Matilde',
                                'Maupin', 'Maurreen', 'Mayberry', 'McAllister', 'McDonald',
                                'McNair', 'Meek', 'Meggs', 'Mehetabel', 'Mel',
                                'Melan', 'Melisandra', 'Melvyn', 'Menashem', 'Mera',
                                'Meraree', 'Metzgar', 'Michell', 'Mickey', 'Middendorf',
                                'Miett', 'Migeon', 'Mikael', 'Milena', 'Milinda',
                                'Milla', 'Millman', 'Mingche', 'Mireille', 'Mirisola',
                                'Missy', 'Mitzi', 'Mogerly', 'Mohandas', 'Monty',
                                'Morna', 'Morocco', 'Morton', 'Moskow', 'Mott',
                                'Mount', 'Mowbray', 'Mueller', 'Mychal', 'Myo',
                                'Myriam', 'Myrt', 'Na', 'Naara', 'Nadab',
                                'Nadaba', 'Nadeau', 'Naima', 'Nally', 'Nancee',
                                'Nanni', 'Naples', 'Natalie', 'Nate', 'Nathanial',
                                'Nea', 'Neff', 'Nelda', 'Neom', 'Nesline',
                                'Nessy', 'Nesto', 'Nevada', 'Nevil', 'Newhall',
                                'Nichy', 'Nickey', 'Nickolas', 'Nicole', 'Niki',
                                'Nino', 'Noble', 'Noreen', 'Norri', 'Nova',
                                'Nunciata', 'Oak', 'Odeen', 'Odrick', 'Ody',
                                'Odysseus', 'Oira', 'Ola', 'Olfe', 'Olimpia',
                                'Omer', 'Oneal', 'Oneil', 'Orland', 'Orvie',
                                'Osbourn', 'Pacien', 'Pages', 'Palmira', 'Panther',
                                'Papke', 'Pappas', 'Parcel', 'Paris', 'Parris',
                                'Patrica', 'Paulie', 'Pauly', 'Pedaiah', 'Peer',
                                'Peterus', 'Phaidra', 'Pilar', 'Pillsbury', 'Pine',
                                'Pomeroy', 'Poock', 'Poole', 'Powder', 'Powel',
                                'Priscilla', 'Prisilla', 'Profant', 'Pru', 'Publia',
                                'Pugh', 'Purdum', 'Purse', 'Quirita', 'Radack',
                                'Raddatz', 'Rai', 'Raimondo', 'Rajewski', 'Raji',
                                'Rame', 'Randolf', 'Ransome', 'Rapp', 'Raquel',
                                'Rasia', 'Rawlinson', 'Razid', 'Reade', 'Rebel',
                                'Reddy', 'Redmund', 'Reider', 'Reilly', 'Reina',
                                'Relly', 'Rento', 'Reseda', 'Reviel', 'Rex',
                                'Rexana', 'Rhine', 'Rhodes', 'Richard', 'Rickey',
                                'Rind', 'Rivi', 'Roanna', 'Robbin', 'Roberts',
                                'Rodie', 'Rodman', 'Roehm', 'Romalda', 'Romney',
                                'Ronalda', 'Roper', 'Rosabelle', 'Rosanne', 'Roseanna',
                                'Ross', 'Rriocard', 'Rudiger', 'Rudman', 'Rumilly',
                                'Ruttger', 'Ryan', 'Rye', 'Sackville', 'Safko',
                                'Saint', 'Salot', 'Samanthia', 'Sampson', 'Sanburn',
                                'Sander', 'Sandie', 'Sandy', 'Saree', 'Sashenka',
                                'Sass', 'Saum', 'Saunderson', 'Scarrow', 'Schaffel',
                                'Schaper', 'Schargel', 'Scherle', 'Schiffman', 'Schmeltzer',
                                'Scholz', 'Scornik', 'Scotney', 'Scrope', 'Seaden',
                                'Seafowl', 'Seaton', 'Sedberry', 'Sefton', 'Sergo',
                                'Serra', 'Seta', 'Shaina', 'Shanda', 'Sharai',
                                'Shawnee', 'Shenan', 'Sheree', 'Sherlock', 'Shetrit',
                                'Shewchuk', 'Shira', 'Shoshanna', 'Shotton', 'Sidran',
                                'Siloa', 'Silvanus', 'Silvie', 'Sim', 'Simone',
                                'Sion', 'Skantze', 'Skees', 'Skilken', 'Skylar',
                                'Slavic', 'Sloane', 'Slocum', 'Smail', 'Small',
                                'Smoot', 'Sollows', 'Sonnnie', 'Sophi', 'Spurgeon',
                                'Squier', 'Stamata', 'Stanhope', 'Stanway', 'Steffi',
                                'Stent', 'Steven', 'Stolzer', 'Strickler', 'Stronski',
                                'Studley', 'Sumer', 'Sung', 'Sven', 'Swagerty',
                                'Sylvia', 'Talbert', 'Tallbot', 'Tallulah', 'Tandy',
                                'Tannie', 'Tarr', 'Tarrel', 'Terrill', 'Terti',
                                'Tewfik', 'Thadeus', 'Thalassa', 'Thanos', 'Theadora',
                                'Theola', 'Theresa', 'Therine', 'Thilda', 'Thill',
                                'Thirion', 'Thorwald', 'Thurmann', 'Tibbetts', 'Tien',
                                'Tiffi', 'Tolmann', 'Tomlinson', 'Tonneson', 'Torrance',
                                'Torrence', 'Trask', 'Tremaine', 'Trip', 'Trish',
                                'Tristram', 'Trojan', 'Truitt', 'Tseng', 'Tulley',
                                'Turrell', 'Tut', 'Tutto', 'Uela', 'Ulphiah',
                                'Uriisa', 'Uttasta', 'Valaree', 'Valentin', 'Valley',
                                'Vano', 'Vargas', 'Vashti', 'Vasos', 'Veneaux',
                                'Vento', 'Verada', 'Verina', 'Verlie', 'Vick',
                                'Victoria', 'Vig', 'Vigen', 'Vins', 'Viola',
                                'Virnelli', 'Vitek', 'Volny', 'Vories', 'Waers',
                                'Waldner', 'Waller', 'Walrath', 'Wedurn', 'Weibel',
                                'Weidar', 'Weide', 'Wein', 'Wertheimer', 'Whallon',
                                'Whyte', 'Wie', 'Wier', 'Wiggins', 'Willabella',
                                'Willner', 'Win', 'Wina', 'Wing', 'Winston',
                                'Winwaloe', 'Witcher', 'Woodley', 'Woodman', 'Wrand',
                                'Wrennie', 'Wystand', 'Yelich', 'Yurik', 'Yves',
                                'Zamora', 'Zebapda', 'Zeiler', 'Zellner', 'Zucker');

    FUNCTION product RETURN VARCHAR2 AS
    BEGIN
        RETURN v_product_name(floor(dbms_random.value(1, 100)));
    END;

    FUNCTION prsn_name RETURN VARCHAR2 AS
    BEGIN
        RETURN v_prsn_name(floor(dbms_random.value(1, 1000)));
    END;

    FUNCTION gender RETURN VARCHAR2 AS
    BEGIN
        RETURN vgender_names(floor(dbms_random.value(1, 5)));
    END;

    FUNCTION email RETURN VARCHAR2 AS
    BEGIN
        RETURN vemail1(floor(dbms_random.value(1, 101)))
               || vemail2(floor(dbms_random.value(1, 101)))
               || '@'
               || vemail3(floor(dbms_random.value(1, 101)));
    END;

    FUNCTION adrs RETURN VARCHAR2 AS
    BEGIN
        RETURN floor(dbms_random.value(1, 50000))
               || ' '
               || vstreet_names1(floor(dbms_random.value(1, 101)))
               || ' '
               || vstreet_names2(floor(dbms_random.value(1, 101)))
               || ' '
               || vstreet_names3(floor(dbms_random.value(1, 61)));
    END;

    FUNCTION phone RETURN VARCHAR2 AS
    BEGIN
        RETURN '('
               || floor(dbms_random.value(100, 999))
               || ') '
               || floor(dbms_random.value(100, 999))
               || '-'
               || floor(dbms_random.value(1000, 9999));
    END;

    FUNCTION bdate RETURN DATE AS
    BEGIN
        RETURN trunc(sysdate - floor(dbms_random.value(7300, 25550)));  -- Between 20 and 70 yrs ago
    END;

    FUNCTION get_random_customer RETURN customer%rowtype AS
        v_customer_row customer%rowtype;
    BEGIN
        SELECT
            *
        INTO v_customer_row
        FROM
            (
                SELECT
                    *
                FROM
                    customer
                ORDER BY
                    dbms_random.random
            )
        WHERE
            ROWNUM < 2;

        RETURN v_customer_row;
    END;

    FUNCTION get_random_order RETURN orders%rowtype AS
        v_orders_row orders%rowtype;
    BEGIN
        SELECT
            *
        INTO v_orders_row
        FROM
            (
                SELECT
                    *
                FROM
                    orders
                ORDER BY
                    dbms_random.random
            )
        WHERE
            ROWNUM < 2;

        RETURN v_orders_row;
    END;

    FUNCTION get_random_gender RETURN VARCHAR2 AS
        v_gender_id VARCHAR2(32);
    BEGIN
        SELECT
            gender_id
        INTO v_gender_id
        FROM
            (
                SELECT
                    *
                FROM
                    gender
                ORDER BY
                    dbms_random.random
            )
        WHERE
            ROWNUM < 2;

        RETURN v_gender_id;
    END;

    FUNCTION ins_orders (
        orders_date_in        DATE,
        orders_customer_id_in VARCHAR2
    ) RETURN VARCHAR2 AS
        v_key VARCHAR2(32);
    BEGIN
        INSERT INTO orders (
            orders_id,
            orders_date,
            orders_customer_id
        ) VALUES (
            sys_guid(),
            orders_date_in,
            orders_customer_id_in
        ) RETURN orders_id INTO v_key;

        RETURN v_key;
    END ins_orders;

    FUNCTION ins_customer (
        customer_first_name_in    VARCHAR2,
        customer_middle_name_in   VARCHAR2,
        customer_last_name_in     VARCHAR2,
        customer_date_of_birth_in DATE,
        customer_gender_id_in     VARCHAR2
    ) RETURN VARCHAR2 AS
        v_key VARCHAR2(32);
    BEGIN
        INSERT INTO customer (
            customer_first_name,
            customer_middle_name,
            customer_last_name,
            customer_date_of_birth,
            customer_gender_id
        ) VALUES (
            customer_first_name_in,
            customer_middle_name_in,
            customer_last_name_in,
            customer_date_of_birth_in,
            customer_gender_id_in
        ) RETURNING customer_id INTO v_key;

        RETURN v_key;
    END;

    PROCEDURE load_gender AS
        v_cnt NUMBER(1);
    BEGIN
        FOR idx IN 1..vgender_names.count LOOP
            SELECT
                COUNT(*)
            INTO v_cnt
            FROM
                gender
            WHERE
                gender_name = vgender_names(idx);

            IF v_cnt = 0 THEN
                NULL;
                INSERT INTO gender ( gender_name ) VALUES ( vgender_names(idx) );

            END IF;

        END LOOP;
    END load_gender;

    PROCEDURE create_customers (
        nbr_cust_in NUMBER
    ) AS

        v_adrs_cnt    NUMBER(2);
        v_customer_id VARCHAR2(32);
        v_address_id  VARCHAR2(32);
        v_dflt_ind    NUMBER(1);
    BEGIN
        --  Ensure all the possible genders are loaded.
        load_gender();
        FOR idx IN 1..nbr_cust_in LOOP
            NULL;
            v_customer_id := ins_customer(prsn_name(), prsn_name(), prsn_name(), bdate(), get_random_gender());

        END LOOP;

    END create_customers;

    PROCEDURE create_orders (
        nbr_cust_in NUMBER
    ) AS
        v_customer_rec customer%rowtype;
        v_orders_id    VARCHAR2(32);
    BEGIN
        FOR idx IN 1..nbr_cust_in LOOP
            v_customer_rec := get_random_customer();
            v_orders_id := ins_orders(sysdate, v_customer_rec.customer_id);
        END LOOP;
    END create_orders;

    PROCEDURE advance_random_orders (
        nbr_order_in NUMBER
    ) AS
        v_orders_rec  orders%rowtype;
    BEGIN
        FOR idx IN 1..nbr_order_in LOOP
            v_orders_rec := get_random_order();
            pkg_order.advance_order_status(v_orders_rec.orders_id,sysdate);
        END LOOP;
    END advance_random_orders;
    
END pkg_data;
/

DECLARE
  NBR_ORDER_IN NUMBER;
BEGIN
  NBR_ORDER_IN := 120;

  PKG_DATA.ADVANCE_RANDOM_ORDERS(
    NBR_ORDER_IN => NBR_ORDER_IN
  );
--rollback; 
END;


/
commit;

