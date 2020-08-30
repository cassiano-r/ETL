
# Create a Schema in DB and give access 
create user user_loader identified by testloader;
grant connect, resource, unlimited tablespace to user_loader;


# Create a table
CREATE TABLE cine ( 
  ID   NUMBER PRIMARY KEY , 
  USER_ID       VARCHAR2(30), 
  MOVIE_ID      VARCHAR2(30), 
  RATING        DECIMAL EXTERNAL, 
  TIMESTAMP     VARCHAR2(256) 
);


# For load data in Oracle, we use SQL*Loader. Use example
# https://grouplens.org/datasets/movielens/

# File loader1.ctl
load data
INFILE 'ml-20m/ratings.csv'
INTO TABLE cine
APPEND
FIELDS TERMINATED BY ','
trailing nullcols
(id SEQUENCE (MAX,1),
 user_id CHAR(30),
 movie_id CHAR(30),
 rating   decimal external,
 timestamp  char(256))


# Execute the SQL*Loader in command line
sqlldr userid=engenheiro/dsacademy control=loader1.ctl log=loader.log







