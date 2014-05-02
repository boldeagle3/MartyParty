DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS products;
CREATE TABLE users(  id serial NOT NULL, name varchar(30) NOT NULL, role varchar(30), age int,state varchar(30) , PRIMARY KEY(id) );
CREATE TABLE category( id serial NOT NULL,name varchar(30) UNIQUE NOT NULL,description varchar(140));
CREATE TABLE products(id serial NOT NULL, name varchar(30) NOT NULL, sku varchar(30) UNIQUE NOT NULL, category varchar(30) NOT NULL, price numeric(18,2) NOT NULL CHECK (price>=0), PRIMARY KEY(id));
CREATE TABLE cart (id          SERIAL PRIMARY KEY, userid       INTEGER REFERENCES users (id) NOT NULL,product     INTEGER REFERENCES products (id) NOT NULL, amount INT);