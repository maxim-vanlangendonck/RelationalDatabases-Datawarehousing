# 1.SQL Review
## SQL sub languages
### Data Definition Language (DDL)

- CREATE, ALTER, DROP

### Data Manipulation Language (DML)

- SELECT, INSERT, UPDATE, DELETE

### Data Control Language (DCL)

- GRANT, REVOKE, DENY

## Consulting data
### 1 table

- SELECT
- FROM
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- AS

### >1 table

- JOIN
    - inner join
    - outer join
    - cross join

![JOIN TABLE](img/image1.png)

- UNION ⇒ combineert het resultaat van 2 of meer queries
- INTERSECT
- EXCEPT

# 2.SQL Advanced

- Subquery's
    - Simple nested query's
    - Correlated subquery's
    - Operator EXISTS
- Set Operators
- Common Table Expressions

## Subqueries
- basic form
    ``` sql
    SELECT
    FROM
    WHERE condition
    ```
### nested subqueries

- outer level query
    - ⇒ de eerste SELECT, de main question
- inner level query
    - ⇒ de SELECT in de WHERE clause (of HAVING clause)
        - altijd eerst uitgevoerd
        - altijd tussen ( )
        - kan in meer levels bevatten
- subqueries that returns a single value
    - met alle relational operators: =, >, <, ≤, ≥, <>
- subqueries that returns a single column
    - operators IN, NOT IN, ANY, ALL
- ANY and ALL keywords
    - gebruikt in combinatie met de relational operators en subqueries dat een kolom van waarde weergeeft
    - ALL geeft TRUE wanneer alle waarden die in subquery voldoen aan de conditie
    - ANY geeft TRUE weer wanneer er minstens 1 voldoet aan de conditie

### Correlated subqueries
- de inner query gebruikt informatie uit de outer query
- de subquery bevat een zoek conditie dat verwijst naar de main query, wat de subquery doet afhangen van de main query
- de order van uitvoeren is van boven naar beneden
  - niet van beneden naar boven zoalls een simpele subquery
- stappenplan
    
    ![stappenplan](img/image2.png)

- voorbeeld
    ```sql
    SELECT FirstName + ' ' + LastName As Fullname, Salary
    FROM Employees
    WHERE Salary > (SELECT AVG(Salary) FROM Employees)
    ```
- de EXISTS operator
  - test het bestaan van de result set
  - voorbeeld
        ```sql
        SELECT *
        FROM Customers AS c
        WHERE EXISTS
        (SELECT * FROM Orders WHERE CustomerID = c.customerID)
- NOT EXISTS
    ```sql
    SELECT *
    FROM Customers AS c
    WHERE NOT EXISTS
    (SELECT * FROM Orders WHERE CustomerID = customerID)

### 3 manieren om hetzelfde resultaat te verkrijgen
- OUTER JOIN
    ```sql
    SELECT *
    FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE o.CustomerID is NULL
    ```
- simple subquery
    ```sql
    SELECT *
    FROM Customers
    WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders)
    ```
- Correlated subquery
    ```sql
    SELECT *
    FROM Customers AS c
    WHERE NOT EXISTS
    (SELECT * FROM Orders WHERE CustomerID = c.customerID)
    ```
### subqueries in the FROM-clause
- doordat het resultaat van een query een tabel is, kan deze ook gebruikt worden in een FROM-clause
- dit wordt een derived table genoemd
- in MS-SQL Server de tabel in een subquery moet een naam hebben
### subqueries in the SELECT-clause

## DML
### Tip for not destroying your database

```sql
BEGIN TRANSACTION -- starts a new "transaction" --> Saves previous state of DB in buffer

-- several "destructive" commands can go here:
INSERT INTO Products(ProductName) 
values ('TestProduct');

-- only you (in  your session) can see changes
SELECT * FROM Products WHERE ProductID = (SELECT MAX(ProductID) FROM Products)

ROLLBACK;   --> ends transaction and restores database in previous state

-- COMMIT;  --> ends transaction and makes changes permanen
```

### INSERT: add new records

- 1 rij
    - alleen de not NULL waarden for de specifieke kolomen
    - alle kolom waarden meegeven
- 

### UPDATE: modify values

- alle rijen in een tabel
    
    ```sql
    UPDATE Products
    SET UnitPrice = UnitPrice * 1.1
    ```
    
- 1 rij aanpassen of een groep van rijen
    
    ```sql
    UPDATE Products
    SET UnitPrice = UnitPrice * 1.1, UnitsInStock = 0
    WHERE ProductName LIKE '%Bröd%'
    ```
    
- rijen aanpassen obv data in andere tabel
    - via subqueries (niet via JOIN)
    
    ```sql
    UPDATE Products
    SET UnitPrice = (UnitPrice * 1.1)
    WHERE SupplierID IN
    (SELECT SupplierID FROM Suppliers WHERE country = 'USA')
    ```
    

### DELETE: remove records

- verwijder een paar rijen
    - samen met WHERE clause
    
    ```sql
    DELETE FROM Products
    WHERE ProductName LIKE '%Bröd%'
    ```
    
- alle rijen
    - via DELETE: identiteit waarden blijft verder gaan
    - via TRUNCATE: identiteit start terug van 1, maar heeft geen WHERE clause
- rijen aanpassen obv data in een andere tabel
    - nie via JOIN, alleen maar subqueries
    
    ```sql
    DELETE FROM OrderDetails
    WHERE OrderID IN
     (SELECT OrderID FROM Orders WHERE OrdersDate = (SELECT MAX(OrderDate) FROM Orders))
    ```
    

### MERGE: combine INSERT, UPDATE, DELETE

- combineren van INSERT, UPDATE en DELETE

## Views

### Introductie

- een opgeslagen SELECT statement
- Voordelen
    - het verbergen van de complexiteit van de database
    - gebruik voor het beveiligen van data
    - organiseren van data voor het exporteren van andere applicaties

```sql
CREATE VIEW view_name [(column_list] AS select_statement
[with check option]
```

### CRUD Operations

- Creating a view
    ```sql
    CREATE VIEW V_ProductsCustomer(productcode, company, quantity)
    AS SELECT od.ProductID, c.CompanyName, sum(od.Quantity)
    FROM Customers c
    JOIN Orders o ON o.CustomerID = c.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY od.ProductID, c.CompanyName;
    ```
    
- using a view
    ```sql
    SELECT * FROM V_ProductsCostumer;
    ```
    
- Changing a view
    ```sql
    ALTER VIEW V_ProductsCustomer(productcode, company)
    AS SELECT od.ProductID, c.CompanyName
    FROM Customers c
    JOIN Orders o ON o.CustomerID = c.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY od.ProductID, c.CompanyName;
    ```
    
- Deleting a view
    
    ```sql
    DROP VIEW V_ProductsCustomer
    ```
    

## Common Table Expressions (CTE)
### Definition
- CTE = WITH-componenten gebruiken zodat je de subquery een naam kan geven en het hergebruiken in de rest van de query
### Example
``` sql
WITH numberOfOrdersPerCustomer(customerid, numberOfOrders) AS
(SELECT customerid, COUNT(orderid)
FROM orders
GROUP BY customerid)

SELECT AVG(numberOfOrders * 1.0) AS AveragerNumberOfOrdersPerCustomer
FROM numberOfOrdersPerCustomer
```
### CTE's vs Views
- gelijkheden
  - WITH ~ CREATE VIEW
  - zijn beide virtuele tabellen: de inhoud is afgeleid van andere tabellen
- verschillen
  - een CTE is er enkel tijdens een SELECT-statement
  - CTE is niet zichtbaar voor andere gebruikers en applicatie's
  
### CTE's vs Subqueries
- gelijkheden:
  - beide zijn virtuele tabellen
- verschillen:
  - CTE kan hergebruikt worden in dezelfde query
  - een subquery is gedefinieerd in de clause waar het gebruikt werd (SELECT/FROM/WHERE/...)
  - een CTE is gedefinieerd in het begin van de query
  - een simpele subquery kan altijd vervangen worden door een CTE

### Recursive SELECT's
- 

# 3.Windows Functions
## Business case
- curante sales vergelijken met vorige sales
- geïntroduceerd in SQL: 2003
  
## OVER clause
- de resultaten van een SELECT zijn verdeeld
- de OVER clause creërt partition en ordening
- de partitie gedraagt zich als een windows die over de data shift
- de OVER clause kan gebruikt worden met een standaar aggregate functies (sum, avg,..) of specifieke window functies(rank, lag, ...)

### voorbeeld: running total
```sql
SELECT CategoryID, ProductID, UnitsInStock, 
SUM(UnitInStock) OVER (PARTITION BY CategoryID ORDER BY CategoryID,
ProductID) TotalUnitsInStockPerCategory
FROM Products
ORDER BY CategoryID, ProductID
```
- OVER clause:
  - simpeler, efficiënter
  - de som is uitgerekend voor iedere partities
  
## RANGE
- de echte bedoleing van windows functions: het aanstellen tot een windows dat over een result set shifts
- met RANGE, 3 opties:
  - `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`
  - `RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING`
  - `RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`
- PARTITION is optioneel
- ORDER BY is verplicht

## ROWS
- bij het gebruik van RANGE, de currante rij wordt vergeleken met de andere rijen en gegroepeerd gebaseerd op de ORDER BY predicate
- 3 opties voor RANGE
  - `ROWS BETWEEN N PRECEDING AND CURRENT ROW`
  - `ROWS BETWEEN CURRENT ROW AND N FOLLOWING`
  - `ROWS BETWEEN N PRECEDING AND N FOLLOWING`
- voorbeeld
  - maak een overzicht van het loon per werknemer en het gemiddelde loon en 2 werknemers voor hem
  ```sql
  SELECT EmployeeID, FirstName + ' ' + LastName AS FullName, Salary,
  AVG(Salary) OVER (ORDER BY Salary DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS AvgSalary2Preceding
  FROM Employees

# 4.Database Programming
## SQL as complete language (PSM)
### Persistent Stored Modules

- SQL/PSM, als een complete programmeertaal
    -variabelen, constanten, datatypes
    -operatoren
    - controle structuren
        -if, case, while, for,...
    - procedures, functies
    - exception handling
- PSM = stored procedures en stored functies

### PSM: voordelen
- code modularisatie
    - 
### PSM: nadelen

## Stored Procedures
- a stored procedure is a named collection of SQL and control-of-flow commands (program that is stored as a database object)

### Variabelen
- variabelen naam start met @
    `DECLARE @variable_name1 data_type [....]`
- variabelen assignment 
    `SET @variable_name = expression`
    `SELECT @variable_name = column_specification`
- PRINT SQL Server Management Studio toont een bericht in de message tab
    `PRINT string_expression`

### Operators in Transact SQL
- Arithmetic operators
    - -,+,*,/, %
- Comparison operators
    - <, >, =, ..., IS NULL, LIKE, BETWEEN, IN
- Alphanumeric operators
    - + (string concatenation)
- Logic operators
    - AND, OR, NOT

### Creation of SP
```sql
CREATE PROCEDURE <proc_name> [parameter declaratie]
AS
<sql_statements>
```
- maakt een db object, via DDL instructies

### Procedural database objects
- het gedrag van een stored procedure
  
  ![behaviour of a stored procedure](img/image3.png)

### Changing and removing a SP
- veranderen van een SP
```sql
ALTER PROCEDURE <proc_name> [parameter_declaration]
AS
<sql_statements>
```
- het verwijderen van een SP
  `DROP PROCEDURE <proc_name>`
### Return value of SP
- achter het uitvoeren van een SP, het geeft een waarde terug
  - van datatype int
  - default return value = 0
- RETURN statement
  - de uitvoering van SP stopt
  - de return waarde kan veranderd worden
### SP met parameters
- types van parameters
  - een parameter is doorgegeven aan de SP met een input parameter
  - met een output 

### Error handling in Transact SQL
- RETURN
  - het direct stoppen van de uitvoering van de batch procedure
- @@error
  - het bevat de error nummer van het laatst uitgevoerd SDL instructie
  - als het OK is, value = 0
- gebruik TRY....CATCH block
- alle syteem error berichten zitten in de system table sysmessages
- je kun je eigen berichten maken via raiserror
  - RAISERROR(msg, severity, state)
    - msg: het error bericht
    - severity: waarden tussen 0 en 18
    - state: waarden tussen 1 en 127, 
### Exception Handling: catch-block functions
- ERROR_LINE(): lijn nummer waar de exception gebeurde
- ERROR_MESSAGE(): error bericht
- ERROR_PROCEDURE(): SP waar de exception gebeurde
- ERROR_NUMBER(): error nummer
- ERROR_SEVERITY(): severity level
- voorbeeld:
    ```sql
    CREATE PROCEDURE DeleteShipper @ShipperID int, @NumberOfDeletedShippers int OUT
    AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
            DELETE FROM Shippers WHERE ShipperID = @ShipperID
            SET @NumberOfDeletedShippers = @@ROWCOUNT
            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            INSERT INTO log values(GETDATE(), ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_SEVERITY())
        END CATCH
    END
    ```
### Throw
- het is een alternatief voor RAISERROR
- gooit een exception en geeft de uitvoering door aan een CATCH-block of een TRY..CATCH contruct in SQL Server
- zonder parameters: alleen in catch block
- met parameters: uit de catch block
- maak je eigen defined exception
  - `THROW(error_number, message, state)`
    - error_number: is een int tussen 50000 en 2147483647
    - state: waarden tussen 1 en 127

## Cursors
### Cursors
- is een database object dat verwijst naar het resultaat van een query
- 5 belangrijke cursor gerelateerde statements
  - `DECLARE CURSOR`: maakt en definieert de cursor
  - `OPEN`: opent de gedeclareerde cursor
  - `FETCH`: fetcht 1 rij
  - `CLOSE`: sluit de cursor (tegenhanger van OPEN)
  - `DEALLOCATE`: verwijdert de cursor definitie (tegenhanger van DECLARE)
  
### Cursor declaratie
```sql
DECLARE <cursor_name> [INSENSITIVE][SCROLL] CURSOR 
FOR <SELECT_statement>
[FOR {READ ONLY | UPDATE[OF <column list>]}]
```
- INSENSITIVE
  - de cursor gebruikt een voorlopig kopie van de data
  - als INSENSITIVE aanstaat, verwijderingen en updates zijn gereflecteerd in de cursor
- SCROLL
  - alle fetch operaties zijn toegelaten
    - FIRST, LAST, PRIOR, NEXT, RELATIVE en ABSOLUTE
  - if SCROLL 
- READ ONLY
- UPDATE
  - data veranderingen zijn toegelaten

### het openen van een cursor
`OPEN <cursor_name>`
- de cursor is geopend
- de cursor is 'gevuld'
  - het SELECT-statement is uitgevoerd. Een virtuele tabel is gevuld met een "actieve set"

### Fetching date with a cursor
```sql
FETCH [NEXT | PRIOR | FIRST | LAST | {ABSOLUTE | RELATIVE <row_number>}]
FROM <cursor_name>
    [INTO <variable_name>[,...<last_variable_name>]]
```
- de cursor is gepositioneerd
- de date is gefetcht
  - zonder INTO clause de resultaat data wordt op het scherm getoond
  - met INTO clause data is aan de specifieke variables gelinkt

### Closing a cursor
`CLOSE <cursor_name>`
- de cursor is gesloten

### Deallocating a cursor
`DEALLOCATE <cursor_name>`
- cursor definitie is verwijderd

### Nested cursors

### Update and delete via cursor
```sql
DELETE FROM <table_name>
WHERE CURRENT OF <cursor_name>
```
```sql
UPDATE <table_name>
SET ...
WHERE CURRENT OF <cursor_name>
```

## Triggers
### Triggers
- = een database programma, dat bestaat uit procedural en declaratieve instructies, opgeslage in een catalogus en geactiveerd door de DBMS
- DML Triggers
  - kan uitgevoerd worden met:
    - insert
    - update
    - delete
  - zijn geactiveerd:
    - before: voor het IUD is geprocesseerd
    - instead of: in plaats van IUD commando
    - after: achter de IUD is geprocesseerd
  - in sommige DMBS
    - for each row
    - for each statement
### Procedural database object
- procedural programma's
| Types | Saved as  | Execution | Supports Parameters |
| :---  | :---      | :---      | :----               |
| **script**  | seperate file | client tool (management studio) | no  |
| **stored procedure**  | database object | via application or SQL script | yes |
| **user defined function** | database object | via application or SQL script | yes |
| **trigger** | database object | via DML statement | no  |

### Why using triggers?
- de validatie van data en complex constraints
- de automatisch genereren van waarden
- supports voor alerts
- auditing
- replicatie en controle van update van redundante data
  
### Voordelen

### Nadelen

### Virtuele tabellen met triggers
- 2 verlopige tabellen
  - verwijderde tabel
    - bevat een kopie van de geupdate en verwijderde rijen
  - ingevoegde tabel
    - bevat kopies van geupdate en ingevoegde rijen

### Creation of an after trigger
```sql
CREATE TRIGGER triggerName
ON table
FOR [INSERT, UPDATE, DELETE]
AS ...
```
- alleen door SysAdmin of dbo
- gelinkt met 1 tabel
- is uitgevoerd
  - na de uitvoering van de triggering actie; insert, update, delete
  - achter een kopie van veranderingen naar voorlopige tabellen


# 5.Indexes and performance
## Space allocation by SQL Server
- SQL server gebruikt RAM files
- pagina = 8 kB of ruimte
- extent = 8 logische consectutieve pagines
  - unifrom extents: for 1 db object
  - mixed extents: kan gedeeld worden door 8 db objecten
- nieuwe tabel of index: allocation in mixed extent
- extension > 8: uniform extent

## Creation of indexen
```sql
CREATE [UNIQUE] [| NONCLUSTERED]
  INDEX index_name ON table (kolom [,...nl])
```
- unieke index: alle waarden in de index kolom moeten uniek zijn
- opmerking
  - wanneer je een index definieert, kan de tabel leeg of vol zijn
  - kolomen in een unieke index kunnen geen null constraint hebben

## Removing indexes
`DROP INDEX table_name.index [,...n]`
- alle waarden in de kolom moeten uniek zijn
- opmerking
  - wanneer je een index definieert, kan de tabel leeg of vol zijn
  - kolomen in een unieke index kunnen geen null constraint hebben

## Table scan
- Heap: ongeordende collectie of data-paginas zonder clustered index = default storage van de tabel
- access via Index Allocation Map (IAM)
- tabel scan: als een query alle pagina's van de tabel fetchen
- ander performantie problemen met heap:
  - fragmentatie: de tabel is over verschillende, niet-consectieve pagina's verspreid
  - forward pointers: 
- verschillende stappen van een table scan
  - **stap 1**: steek de ongeordende data in tabellen
    - zeer inefficiënt
  - **stap 2**: probeer de data in een fysieke volgorde te steken

## Clustered index
- achter dat de tabel data in een fysieke volgorde werd gestoken, dan zal de SQL server een set van index pagina's aanmaken zodat de queries toegelaten worden om direct naar de data te gaan waarin ze geïnteresseerd zijn. 
- deze hele structuur, met de basis tabel data, wordt een clustered index genoemd
- wanneer een query navigeert door de clustered index, noemt dit **clustered index seek**
## Non Clustered index
## Filtered index
- bevatten alleen rijen dat 
- een geclustered index kan geen filtered index zijn, want deze bevat alle data van in de tabel

## INCLUDES
- INCLUDE kolommen voegen een kopie toe van een non-key kolom waarden aan de blad-level van de index tree
- een clustered index heeft geen INCLUDE kolomen nodig omdat alle bladeren beschikbaar zijn in de bladeren

## Clustered vs Non Clustered index
- een clustered index is een manier om de basis data te tonen als een geheel
- een non clustered index is een fysieke scheiding dat refereert naar de base data en het kan een verschillende sorteer-volgorde hebben

## Indexes
- **Wat?**
  - een geordende structuur opgelegd op de records van een tabel
  - snelle toegang door de boomstructuur (B-tree = balanced tree)
- **Waarom?**
  - versnelt de ophaling van de data
  - kan de uniekheid van rijen vastleggen
- **Waarom niet?**
  - indexes nemen veel opslag (overhead)
  - indexes kunnen updates, delete and inserts vertragen omdat indexes ook geüpdate moeten worden

## SQL Optimizer
- SQL Optimizer => module in iedere DBMS
- analiseert en rephrased iedere SQL commando die verstuurt wordt naar de databank
- beslist de beste strategie voor welke index er gebruikt moeten worden, gebaseerd op de statistieken van tabel grootte, het gebruik van de tabel en de distributie van de data

## Clustered index
- de fysieke volgorde van de rijen in een tabel corresponderen aan de volgorde in de clustered index
- hierdoor, kan iedere tabel maar 1 clustered index bevattten

## Non Clustered index
- default index
- trager dan een clustered index
- meer dan 1 per tabel is toegelaten
- forward and backward pointers tussen bladeren
- ieder blad bevat een key waarde en een rij locator
  - naar de positie in de clustered index, als deze bestaat
  - anders naar de heap
- als een query meer velden nodig heeft dan dat er zijn in de index, dan zal deze moeten gefetcht worden van de data pagina's
- wanneer er gelezen wordt via non-clustered index:
  - RID lookup = bookmark lookups to the heap using RID's (Row Identifiers)
  - key lookup = bookmark lookups to a clustered index, als deze bestaat

## Covering Index
- als een non clustered index niet volledig de query covert, dan zal SQL server een opzoeking doen voor iedere rij om de data te fetchen
- **covering index** = non-clustered index dat alle kolomen bevat voor een bepaalde query

## Index seek vs Index scan
- **index seek**: boom-structuur van de index die gebruikt wordt, die resulteert in een snel ophalen van data
- **index scan**: de index wordt gebruikt maar wordt gescant van het begin totdat de gezochte records gevonden worden

## When to use an index?
- welke kolommen moeten worden indexed?
  - primaire en unieke kolommen worden automatisch geindext
  - vreemde keys worden soms gebruikt in joins
  - kolommen worden soms gebruikt in zoeken condities (WHERE, HAVING, GROUP BY) of in joins
  - kolommen worden vaak gebruikt in een ORDER BY clause
- wanneer niet?
  - kolommen dat heel raar gebruikt worden in queries
  - kolommen met kleine nummer of mogelijke waarden
  - kolommen in kleine tabellen
  - kolommen of type bit, text of afbeelding

## Tips & Tricks
1. vermijd het gebruik van functies
2. vermijd bewerkingen, isoleer de kolommen
3. verkies OUTER JOIN boven UNION
4. vermijd ANY en ALL

# 6.Basics of Transaction Management
--> multi-user databanken
## Transactions, Recovery and concurrency control
- DBMS moet ACID (Atomicity, Consistency, Isolation, Durability) eigenschappen ondersteunen
- **Transaction**: een deel van database operaties die gemaakt zijn door 1 gebruiker of applicatie, door gezien wordt als 1 individueel stuk van werk
  - dit loopt oftewel goed af of deze faalt in zijn geheel
  - rendert een databank van 1 consequente staat in een andere consequente staat
- **Recovery**: een activiteit die ervoor zorgt, wanneer er een probleem zou voordoen, dat de databank teruggaat naar een consequente staat zonder dataverlies te lijden
- **Concurrency Control**: de coördinatie van transacties die tegerlijkertijd worden uitgevoerd op dezelfde data, zodat dat dit niet tot inconsequenties in de data lijd

## Transactions and Transaction Management
### Delineating Transactions and the Transaction Lifecycle
- de grenzen van tranacties kunnen impliciet of expliciet aangeduid worden
  - expliciet
    - de developer kiest wanneer een transactie start en wanneer deze eindigt of welke stappen er ondernomen moeten worden als deze transactie faalt
    - **begin transaction** en **rollback transacton / commit transaction**
  - impliciet: eerste uitvoerbare SQL statement
- wanneer de eerste operaties uitgevoerd wordt, is de transactie actief
- wanneer de transactie volledig is, kan deze **gecommit** worden. Zo niet, dan moet deze **rolled back** worden, naar de oorspronkelijke toestand

### Triggers and transactie
- een trigger is een deel van dezelfde transactie

### DBMS Components involved in Transaction Management
![DBMS Components](img/image4.png)
### Logfile
- logfile registers
  - een unieke log sequentie nummer
  - een unieke transactie identifier
  - before images
  - after images
  - current state van de transactie
- logfile kunnen ook checkpoints bevatten
  - het tijdelijke geheugen wordt permanent gemaakt

## Recovery
### Types of Failures
- **transaction failure**
- **System Failure**
- **Media Failure**

### System Recovery
- in het geval van het falen van een systeem, 2 types van transacties
  - degene die al in een gecommite state zitten voor het falen
  - degene dit nog steeds in een actieve state zitten tijdens het falen
- de logfile is essentieel om te zien welke transacties er nog in welke staat zitten

### Media Recovery
- is gebaseerd op het type van date redunantie
  - offline opgeslagen (tape vault)
  - online opgeslagen (online backup hard disk drive)
- 2 types
  - disk mirroring
    - simultaan de date schrijven naar 2 of meer harde schijven
  - disk archiving
    - periodiek kopiëren op een andere storage media
- mixed approach: rollfoward recovery
  - het archiveren van database files en het mirroren van de logfile

## Concurrency Control
### Typical Concurrency Problems
- een scheduler is verantwoordleijk voor het pannen van de uitvoering van de transacties en zijn operaties
- problemen
  - **lost update**: 
  - **uncommitted dependency (dirty read)**
  - **inconsistent analysis**
  - **nonrepeatable read**
  - **phantom reads**
![Concurrency Problems](img/image5.png)

## Schedules
### Schedules and Serial Schedules
- een schedule S is een set van n transacties