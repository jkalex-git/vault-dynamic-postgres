-- parent role for dynamically created roles
CREATE ROLE gift WITH NOLOGIN;
-- create database with gift as owner
CREATE DATABASE gift OWNER gift;
-- used by vault to dynamically create new roles
CREATE USER "vault-gift" WITH ENCRYPTED PASSWORD 'initPassword' CREATEROLE;
-- allows vault-gift to grant dynamic roles permission for existing objects with gift role
GRANT gift TO "vault-gift";

\connect gift;
CREATE TABLE ITEMS ( id int, name varchar(255));
INSERT INTO ITEMS VALUES (1, 'TeddyBear');
INSERT INTO ITEMS VALUES (2, 'Playstation');
SELECT * FROM ITEMS;
ALTER TABLE ITEMS OWNER TO gift;