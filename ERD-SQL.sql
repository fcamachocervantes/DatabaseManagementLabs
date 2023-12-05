-- ERD 2 SQL

--step 1
DROP TABLE IF EXISTS employee;
CREATE TABLE employee(
    id SERIAL PRIMARY KEY,
    ssn integer NOT NULL,
    name text,
    posiition text,
    pay_rate numeric (10,2),
    pay_type text
);

DROP TABLE IF EXISTS factory CASCADE;
CREATE TABLE factory(
    city text PRIMARY KEY
);

DROP TABLE IF EXISTS model;
CREATE TABLE model(
    name text,
    model_no text,
    model_type text,

    PRIMARY KEY (name, model_no)
);

DROP TABLE IF EXISTS part;
CREATE TABLE part(
    part_no text PRIMARY KEY,
    description text NOT NULL DEFAULT ' '
);

DROP TABLE IF EXISTS vendor;
CREATE TABLE vendor(
    name text PRIMARY KEY,
    email text,
    phone text
);

--step 2: weak entities

DROP TABLE IF EXISTS assembly_line;
CREATE TABLE IF EXISTS assembly_line(
    city text REFERENCES factory(city),
    assembly_no text,
    capacity integer,
    PRIMARY KEY (city, assembly_no)
);

--step 3: 1:1 relationships

ALTER TABLE factory
ADD COLUMN manager_id integer
    NOT NULL -- total
    UNIQUE -- 1:1
    REFERENCES employee(id); -- 1:1

--step 4: 1:N relationships

ALTER TABLE employee
ADD COLUMN factory_city text
    REFERENCES factory(city);

ALTER TABLE employee
ADD COLUMN supervisor_id integer
    REFERENCES employee(id);

--builds tbd

--step 5: M:N relationships

DROP TABLE IF EXISTS model_part_xref;
CREATE TABLE model_part_xref(
    model_name text,
    model_no text,
    part_no text,
    PRIMARY KEY (model_name, model_no, part_no),
    FOREIGN KEY (model_name, model_no) REFERENCES model(name, model_no),
    FOREIGN KEY (part_no) REFERENCES part(part_no)
);

--supplies tbd

--step 6 multivalues attributes

--separate table

--step 7 n-ary, none here

--step 8 derived attributes

CREATE VIEW factory_view AS
SELECT city, manager_id 42 AS capacity 
FROM factory;
--replace 42 when aggregates/subqueries are covered