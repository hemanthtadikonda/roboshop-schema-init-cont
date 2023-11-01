#!/bin/bash

git clone https://github.com/hemanthtadikonda/$COMPONENT
cd $COMPONENT/schema

if [ "$DB_TYPE" == "mysql"]; then
  aws ssm get-parameter  --name sql.${env}.schema_setup --with-decryption | jq .Parameter.Value | sed -e 's/"//g' <$COMPONENT.sql
fi

if ["$DB_TYPE" == "docdb"]; then
  curl -o https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
  aws ssm get-parameter  --name docdb.${env}.schema_setup --with-decryption | jq .Parameter.Value | sed -e 's/"//g' <$COMPONENT.js
fi


