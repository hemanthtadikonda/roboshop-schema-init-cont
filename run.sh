#!/bin/bash

git clone https://github.com/hemanthtadikonda/$COMPONENT
cd $COMPONENT/schema

SCHEMA_SETUP=$(aws ssm get-parameter  --name ${$DB_TYPE}.${env}.schema_setup --with-decryption | jq .Parameter.Value | sed -e 's/"//g')

if [ "$DB_TYPE" == "sql" ]; then
  ${SCHEMA_SETUP} <$COMPONENT.sql
  #mysql -h dev-mysql-rds-cluster.cluster-cec9yfajj5ic.us-east-1.rds.amazonaws.com -udevrdsadmin -proboshop1234 <$COMPONENT.sql
  #aws ssm get-parameter  --name ${$DB_TYPE}.${env}.schema_setup --with-decryption | jq .Parameter.Value | sed -e 's/"//g' <$COMPONENT.sql
fi

if [ "$DB_TYPE" == "docdb" ]; then
  curl -o rds-combined-ca-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
  ${SCHEMA_SETUP} <$COMPONENT.js

  #mongo --ssl --host dev-docdb-cluster.cluster-cec9yfajj5ic.us-east-1.docdb.amazonaws.com:27017 --sslCAFile rds-combined-ca-bundle.pem --username docdbadmin --password roboshop1234 <$COMPONENT.js
  #aws ssm get-parameter  --name docdb.${env}.schema_setup --with-decryption | jq .Parameter.Value | sed -e 's/"//g' <$COMPONENT.js

fi
