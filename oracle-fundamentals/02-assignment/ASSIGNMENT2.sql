PROMPT ASSIGNMENT 2 By Kyle Santin 778217
PROMPT =============================================================
PROMPT 1. Create a table named CustCopy using the subquery method. 
PROMPT The new table should contain the data from the sales_rep_id, 
PROMPT name, address, city, state or province, zip or postal code, 
PROMPT and phone number columns in the s_customer table.
PROMPT
PROMPT Check out the table definition using the DESCRIBE command.
PROMPT
PROMPT Assign yourself and a friend as new customers and place your 
PROMPT data into the CustCopy table. Insert appropriate fictitious 
PROMPT data into the table. 
PROMPT =============================================================

CREATE TABLE CustCopy AS
SELECT sales_rep_id, name, address, city, state, zip_code, phone
FROM s_customer;

/*
DESCRIBE CustCopy;

Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 SALES_REP_ID                                       NUMBER(7)
 NAME                                      NOT NULL VARCHAR2(50)
 ADDRESS                                            VARCHAR2(400)
 CITY                                               VARCHAR2(30)
 STATE                                              VARCHAR2(20)
 ZIP_CODE                                           VARCHAR2(75)
 PHONE                                              VARCHAR2(25)
 */

INSERT INTO CustCopy (SALES_REP_ID, NAME, ADDRESS, CITY, STATE, ZIP_CODE, PHONE)
VALUES (1, 'Kyle Santin', '10 CatStreet', 'Calgary', 'AB', 'C2T 1NT', '587-574-1265');

INSERT INTO CustCopy (SALES_REP_ID, NAME, ADDRESS, CITY, STATE, ZIP_CODE, PHONE)
VALUES (1, 'Mr Cat', '10 CatStreet', 'Calgary', 'AB', 'C2T 1NT', '403-484-6152');

PROMPT =============================================================
PROMPT 2. a) Create a table named representative to record the 
PROMPT representatives to the customers of Summit Sporting Goods. 
PROMPT Besides the sales_rep_id, the table should contain the name, 
PROMPT address, city, state, zip code and phone number.
PROMPT Use the explicit definition of the characteristics method, 
PROMPT not the subquery method. Since this is just another table in 
PROMPT the Summit Sporting Goods database, column definitions should 
PROMPT be consistent between tables. That is, the address column in 
PROMPT the representative table should be of the same data type and 
PROMPT size as the address column in the s_customer table.
PROMPT
PROMPT b) Add a primary key constraint to the sales_rep_id column. 
PROMPT
PROMPT c) Hire yourself and a friend as reps and place your data 
PROMPT into the representative table. Insert appropriate fictitious 
PROMPT data into the table.
PROMPT =============================================================

/*
We can verify the datatype and size by using DESCRIBE CustCopy;

I've added the primary key to the inital table create. the other way to do it
would be to create the table and then alter it and add the constratint

CREATE TABLE representative (
    SALES_REP_ID NUMBER(7),
    NAME VARCHAR(50),
    ADDRESS VARCHAR(400),
    CITY VARCHAR(30),
    STATE_PROVINCE VARCHAR(20),
    ZIP_POSTAL VARCHAR(75),
    PHONE_NUMBER VARCHAR(25)
);

ALTER TABLE respresentative
ADD CONSTRAINT sales_rep_id_pk PRIMARY KEY (sales_rep_id);
*/

CREATE TABLE representative (
    SALES_REP_ID NUMBER(7) PRIMARY KEY,
    NAME VARCHAR(50),
    ADDRESS VARCHAR(400),
    CITY VARCHAR(30),
    STATE VARCHAR(20),
    ZIP_CODE VARCHAR(75),
    PHONE VARCHAR(25)
);

-- I have copied the previous value entries and changed the table name

INSERT INTO Representative (SALES_REP_ID, NAME, ADDRESS, CITY, STATE, ZIP_CODE, PHONE)
VALUES (1, 'Kyle Santin', '10 CatStreet', 'Calgary', 'AB', 'C2T 1NT', '587-574-1265');

INSERT INTO Representative (SALES_REP_ID, NAME, ADDRESS, CITY, STATE, ZIP_CODE, PHONE)
VALUES (1, 'Mr Cat', '10 CatStreet', 'Calgary', 'AB', 'C2T 1NT', '403-484-6152');

PROMPT =============================================================
PROMPT 3. a) Add the following constraints to the s_emp table.
PROMPT (1) Business rule: No employee's salary can be greater than 
PROMPT $5000. (2) Business rule: All employee names (First & Last) 
PROPMT must be stored in upper case only. Try inserting data into 
PROMPT the s_emp table that violates these constraints to confirm 
PROMPT that you have properly applied them. Include these test 
PROMPT inserts in your answer document.
PROMPT b) Business rules change…Give the president a $1000 raise. 
PROMPT What happened? How can you ensure this task is complete 
PROMPT (permanent) and the president will receive the updated 
PROMPT salary? Verify with a SELECT statement. (10 marks)
PROMPT =============================================================

/*
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ID                                        NOT NULL NUMBER(7)
 LAST_NAME                                 NOT NULL VARCHAR2(25)
 FIRST_NAME                                         VARCHAR2(25)
 USERID                                             VARCHAR2(8)
 START_DATE                                         DATE
 COMMENTS                                           VARCHAR2(255)
 MANAGER_ID                                         NUMBER(7)
 TITLE                                              VARCHAR2(25)
 DEPT_ID                                            NUMBER(7)
 SALARY                                             NUMBER(11,2)
 COMMISSION_PCT                                     NUMBER(4,2)
*/

ALTER TABLE s_emp
ADD CONSTRAINT CHK_SALARY CHECK (salary <= 5000);

/*
SQL> ALTER TABLE s_emp ADD CONSTRAINT CHK_UPPERCASE_NAME CHECK (FIRST_NAME = UPPER(FIRST_NAME) AND LAST_NAME = UPPER(LAST_NAME));
                                 *
ERROR at line 1:
ORA-02293: cannot validate (SYS.CHK_UPPERCASE_NAME) - check constraint violated

After viewing the table it looks like there are already values in the table with lowercase
so we need to set them to UPPERCASE
*/

UPDATE s_emp SET FIRST_NAME = UPPER(FIRST_NAME), LAST_NAME = UPPER(LAST_NAME);

-- 25 rows updated. And now we can add the constraint

ALTER TABLE s_emp ADD CONSTRAINT CHK_UPPERCASE_NAME CHECK (FIRST_NAME = UPPER(FIRST_NAME) AND LAST_NAME = UPPER(LAST_NAME));

-- Now to rest the contraint

INSERT INTO s_emp (ID, LAST_NAME, FIRST_NAME, USERID) VALUES (101, 'Santin', 'Kyle', 10);

/*
SQL> INSERT INTO s_emp (ID, LAST_NAME, FIRST_NAME, USERID) VALUES (101, 'Santin', 'Kyle', 1011);
INSERT INTO s_emp (ID, LAST_NAME, FIRST_NAME, USERID) VALUES (101, 'Santin', 'Kyle', 1011)

ERROR at line 1:
ORA-02290: check constraint (SYS.CHK_UPPERCASE_NAME) violated

So the constraint has worked

SELECT FIRST_NAME, LAST_NAME, SALARY FROM s_emp
WHERE TITLE = 'PRESIDENT';

FIRST_NAME                LAST_NAME                     SALARY
------------------------- ------------------------- ----------
CARMEN                    VELASQUEZ                       5000

UPDATE s_emp
SET SALARY = SALARY + 1000
WHERE TITLE = 'PRESIDENT';

0 rows updated.

After checking DESC s_emp again I can see that title is set to VARCHAR2 which is case sensitive

UPDATE s_emp
SET SALARY = SALARY + 1000
WHERE TITLE = 'President';

SQL> UPDATE s_emp
  2  SET SALARY = SALARY + 1000
  3  WHERE TITLE = 'President';
UPDATE s_emp
*
ERROR at line 1:
ORA-02290: check constraint (SYS.CHK_SALARY) violated

The constraint previously created is working as intended
*/

ALTER TABLE s_emp
DISABLE CONSTRAINT CHK_SALARY;

UPDATE s_emp
SET SALARY = SALARY + 1000
WHERE TITLE = 'President';

-- make permanent with commit

COMMIT;

/*
verify change

SQL> SELECT FIRST_NAME, LAST_NAME, SALARY FROM s_emp
  2  WHERE TITLE = 'President';

FIRST_NAME                LAST_NAME                     SALARY
------------------------- ------------------------- ----------
CARMEN                    VELASQUEZ                       6000

ALTER TABLE s_emp
ENABLE CONSTRAINT CHK_SALARY;

ERROR at line 2:
ORA-02293: cannot validate (SYS.CHK_SALARY) - check constraint violated

This is because the President's salary is over 5000. We need to find a new way
to ensure the President is an exception. We may have to edit the constraint with a WHERE

*/

ALTER TABLE s_emp
ADD CONSTRAINT CHK_SALARY
CHECK (TITLE = 'President' OR SALARY <= 5000);

-- now we can update the President's salary again

UPDATE s_emp
SET SALARY = SALARY + 1000
WHERE TITLE = 'President';

commit;

/*
The president currently has 7000 as their salary because we commited prior to the fix.
when this entire code is ran, it will be the right number since the first commit is now in
a comment and not an executable
*/

PROMPT =============================================================
PROMPT 4. Increase the amount_in_stock value of product 32779 in 
PROMPT warehouse 10501 by 10% in the s_inventory table. Update the 
PROMPT restock_date to reflect todays date. Make the change 
PROMPT permanent.
PROMPT =============================================================

/*
 lets check what is in the s_inventory table in regards to
prodcut 32779 in warehouse 10501

SELECT * FROM s_inventory
WHERE PRODUCT_ID = '32779' AND WAREHOUSE_ID = '10501';

PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK REORDER_POINT MAX_IN_STOCK
---------- ------------ --------------- ------------- ------------
OUT_OF_STOCK_EXPLANATION
--------------------------------------------------------------------------------
RESTOCK_D
---------
     32779        10501             280           200          350
*/

UPDATE s_inventory
SET AMOUNT_IN_STOCK = AMOUNT_IN_STOCK * 1.10, RESTOCK_DATE = SYSDATE
WHERE PRODUCT_ID = '32779' AND WAREHOUSE_ID = '10501';

/*
Confirm update with 

SELECT * FROM s_inventory
WHERE PRODUCT_ID = '32779' AND WAREHOUSE_ID = '10501';

PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK REORDER_POINT MAX_IN_STOCK
---------- ------------ --------------- ------------- ------------
OUT_OF_STOCK_EXPLANATION
--------------------------------------------------------------------------------
RESTOCK_D
---------
     32779        10501             308           200          350

17-OCT-25
*/

commit;

PROMPT =============================================================
PROMPT 5. It is time to get rid of some old data. Remove all items 
PROMPT from the s_item table where the order was dated before 
PROMPT 1-SEP-19. Then remove all orders from the s_ord table dated 
PROMPT before 1-SEP-19. Make the change permanent. (14 marks)
PROMPT =============================================================

/*
This will need a subquery. So we need to get the items from the date ranged first

SELECT * FROM s_item;

    ORD_ID    ITEM_ID PRODUCT_ID      PRICE   QUANTITY QUANTITY_SHIPPED
---------- ---------- ---------- ---------- ---------- ----------------
       100          1      10011        135        500              500
       100          2      10013        380        400              400
       100          3      10021         14        500              500
       100          5      30326        582        600              600
       100          7      41010          8        250              250
       100          6      30433         20        450              450
       100          4      10023         36        400              400
       101          1      30421         16         15               15
       101          3      41010          8         20               20
       101          5      50169       4.29         40               40
       101          6      50417         80         27               27

    ORD_ID    ITEM_ID PRODUCT_ID      PRICE   QUANTITY QUANTITY_SHIPPED
---------- ---------- ---------- ---------- ---------- ----------------
       101          7      50530         45         50               50
       101          4      41100         45         35               35
       101          2      40422         50         30               30
       102          1      20108         28        100              100
       102          2      20201        123         45               45
       103          1      30433         20         15               15
       103          2      32779          7         11               11
       104          1      20510          9          7                7
       104          4      30421         16         35               35
       104          2      20512          8         12               12
       104          3      30321       1669         19               19

    ORD_ID    ITEM_ID PRODUCT_ID      PRICE   QUANTITY QUANTITY_SHIPPED
---------- ---------- ---------- ---------- ---------- ----------------
       105          1      50273      22.89         16               16
       105          3      50532         47         28               28
       105          2      50419         80         13               13
       106          1      20108         28         46               46
       106          4      50273      22.89         75               75
       106          5      50418         75         98               98
       106          6      50419         80         27               27
       106          2      20201        123         21               21
       106          3      50169       4.29        125              125
       107          1      20106         11         50               50
       107          3      20201        115        130              130

    ORD_ID    ITEM_ID PRODUCT_ID      PRICE   QUANTITY QUANTITY_SHIPPED
---------- ---------- ---------- ---------- ---------- ----------------
       107          5      30421         16         55               55
       107          4      30321       1669         75               75
       107          2      20108         28         22               22
       108          1      20510          9          9                9
       108          6      41080         35         50               50
       108          7      41100         45         42               42
       108          5      32861         60         57               57
       108          2      20512          8         18               18
       108          4      32779          7         60               60
       108          3      30321       1669         85               85
       109          1      10011        140        150              150

    ORD_ID    ITEM_ID PRODUCT_ID      PRICE   QUANTITY QUANTITY_SHIPPED
---------- ---------- ---------- ---------- ---------- ----------------
       109          5      30426      18.25        500              500
       109          7      50418         75         43               43
       109          6      32861         60         50               50
       109          4      30326        582       1500             1500
       109          2      10012        175        600              600
       109          3      10022      21.95        300              300
       110          1      50273      22.89         17               17
       110          2      50536         50         23               23
       111          1      40421         65         27               27
       111          2      41080         35         29               29
        97          1      20106          9       1000             1000

    ORD_ID    ITEM_ID PRODUCT_ID      PRICE   QUANTITY QUANTITY_SHIPPED
---------- ---------- ---------- ---------- ---------- ----------------
        97          2      30321       1500         50               50
        98          1      40421         85          7                7
        99          1      20510          9         18               18
        99          2      20512          8         25               25
        99          3      50417         80         53               53
        99          4      50530         45         69               69
       112          1      20106         11         50               50

SELECT * FROM s_ord;

        ID CUSTOMER_ID DATE_ORDE DATE_SHIP SALES_REP_ID      TOTAL PAYMEN O
---------- ----------- --------- --------- ------------ ---------- ------ -
       100         204 31-AUG-19 10-SEP-19           11     601100 CREDIT Y
       101         205 31-AUG-19 15-SEP-19           14     8056.6 CREDIT Y
       102         206 01-SEP-19 08-SEP-19           15       8335 CREDIT Y
       103         208 02-SEP-19 22-SEP-19           15        377 CASH   Y
       104         208 03-SEP-19 23-SEP-19           15      32430 CREDIT Y
       105         209 04-SEP-19 18-SEP-19           11    2722.24 CREDIT Y
       106         210 07-SEP-19 15-SEP-19           12      15634 CREDIT Y
       107         211 07-SEP-19 21-SEP-19           15     142171 CREDIT Y
       108         212 07-SEP-19 10-SEP-19           13     149570 CREDIT Y
       109         213 08-SEP-19 28-SEP-19           11    1020935 CREDIT Y
       110         214 09-SEP-19 21-SEP-19           11    1539.13 CASH   Y

        ID CUSTOMER_ID DATE_ORDE DATE_SHIP SALES_REP_ID      TOTAL PAYMEN O
---------- ----------- --------- --------- ------------ ---------- ------ -
       111         204 09-SEP-19 21-SEP-19           11       2770 CASH   Y
        97         201 28-AUG-19 17-SEP-19           12      84000 CREDIT Y
        98         202 31-AUG-19 10-SEP-19           14        595 CASH   Y
        99         203 31-AUG-19 18-SEP-19           14       7707 CREDIT Y
       112         210 31-AUG-19 10-SEP-19           12        550 CREDIT Y

SELECT ID from s_ord
WHERE DATE_ORDERED < TO_DATE('01-SEP-2019', 'DD-MON-YYYY');

        ID
----------
       100
       101
        97
        98
        99
       112

This gets us all the ID's and satisfies the subquery.
*/

DELETE FROM s_item
WHERE ORD_ID IN (SELECT ID from s_ord
WHERE DATE_ORDERED < TO_DATE('01-SEP-2019', 'DD-MON-YYYY'));

-- 22 rows deleted.

commit;

PROMPT =============================================================
PROMPT 6. Create a view for the manager of warehouse 401 
PROMPT (in the s_inventory table) that allows her to access 
PROMPT information about the stock in her warehouse. Make sure the 
PROMPT view includes the amount in stock from the s_inventory table 
PROMPT and the product id, order id, price, quantity and quantity 
PROMPT shipped from the s_item table. Show her how easy it is to 
PROMPT obtain a first-class (superb) report (ttitle, btitle, column 
PROMPT headings, column formatting, wrap, breaks, etc). (14 marks)
PROMPT =============================================================

CREATE VIEW vw_warehouse_401 AS
SELECT i.PRODUCT_ID, i.WAREHOUSE_ID, i.AMOUNT_IN_STOCK, s.ORD_ID, s.PRICE, s.QUANTITY, s.QUANTITY_SHIPPED
FROM s_inventory i
JOIN s_item s
ON i.PRODUCT_ID = s.PRODUCT_ID
WHERE i.WAREHOUSE_ID = 401;

/*
View created.

SELECT *
FROM vw_warehouse_401;

PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     30433          401               0        103         20         15
              15

     32779          401             135        103          7         11
              11

     20510          401              88        104          9          7
               7


PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     30421          401              85        104         16         35
              35

     20512          401              75        104          8         12
              12

     30321          401             102        104       1669         19
              19


PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     50273          401             224        105      22.89         16
              16

     50532          401             233        105         47         28
              28

     50419          401             151        105         80         13
              13


PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     50273          401             224        106      22.89         75
              75

     50418          401             156        106         75         98
              98

     50419          401             151        106         80         27
              27


PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     50169          401             240        106       4.29        125
             125

     30421          401              85        107         16         55
              55

     30321          401             102        107       1669         75
              75


PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     20510          401              88        108          9          9
               9

     41080          401             100        108         35         50
              50

     41100          401              75        108         45         42
              42


PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     32861          401             250        108         60         57
              57

     20512          401              75        108          8         18
              18

     32779          401             135        108          7         60
              60


PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     30321          401             102        108       1669         85
              85

     30426          401             135        109      18.25        500
             500

     50418          401             156        109         75         43
              43


PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     32861          401             250        109         60         50
              50

     30326          401             113        109        582       1500
            1500

     50273          401             224        110      22.89         17
              17


PRODUCT_ID WAREHOUSE_ID AMOUNT_IN_STOCK     ORD_ID      PRICE   QUANTITY
---------- ------------ --------------- ---------- ---------- ----------
QUANTITY_SHIPPED
----------------
     50536          401             138        110         50         23
              23

     40421          401              47        111         65         27
              27

     41080          401             100        111         35         29
              29

had to play with the linesize number to make sure the
ttitle and btitle were actually centered in my cmdprompt view

I also think I made a mistake in ASSIGNMENT1 by not including the SET HEADING ON
for some of the questions. Moving forward I need to remember to include this if 
I want the heading to actually center.

All the values are numbers. I would change them to VARCHAR if there
were strings included, but this will make ure everything is left-aligned
and will look consistent and clean.
*/

SET LINESIZE 75
SET PAGESIZE 50
SET WRAP ON
SET HEADING ON

COLUMN PRODUCT_ID FORMAT 99999 HEADING 'Product ID'
COLUMN WAREHOUSE_ID FORMAT 9999 HEADING 'Warehouse ID'
COLUMN AMOUNT_IN_STOCK FORMAT 9999 HEADING 'Stock'
COLUMN ORD_ID FORMAT 9999 HEADING 'Order ID'
COLUMN PRICE FORMAT $9999.99 HEADING 'Price'
COLUMN QUANTITY FORMAT 9999 HEADING 'Qty Ordered'
COLUMN QUANTITY_SHIPPED FORMAT 9999 HEADING 'Qty Shipped'

TTITLE CENTER 'Warehouse 401 Stock and Orders Report'
BTITLE CENTER 'Generated by Kyle Santin'

SELECT *
FROM vw_warehouse_401;