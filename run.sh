#!/bin/bash

git clone https://github.com/hemanthtadikonda/$COMPONENT
cd $COMPONENT/schema

if [ "$DB_TYPE" == "sql" ]; then
  mysql -h dev-mysql-rds-cluster.cluster-cec9yfajj5ic.us-east-1.rds.amazonaws.com -udevrdsadmin -proboshop1234 <$COMPONENT.sql
  #aws ssm get-parameter  --name sql.${env}.schema_setup --with-decryption | jq .Parameter.Value | sed -e 's/"//g' <$COMPONENT.sql
fi

if [ "$DB_TYPE" == "docdb" ]; then
  curl -o rds-combined-ca-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
  mongo --host dev-docdb-cluster.cluster-cec9yfajj5ic.us-east-1.docdb.amazonaws.com:27017 --sslCAFile rds-combined-ca-bundle.pem --username docdbadmin --password roboshop1234 <$COMPONENT.js
  #aws ssm get-parameter  --name docdb.${env}.schema_setup --with-decryption | jq .Parameter.Value | sed -e 's/"//g' <$COMPONENT.js
fi
