#!/bin/bash
#!/bin/bash
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

MONGO_USER=`read_var MONGO_USER .env`
MONGO_PASSWORD=`read_var MONGO_PASSWORD .env`
MONGO_DATABASE=`read_var MONGO_DATABASE .env`
today=`date +"%Y-%m-%d"`

docker run \
  --user=1000 \
  --network=wow-auction_default\
  --rm -v $(pwd):/workdir/ \
  -w /workdir/ mongo:latest mongorestore \
  --drop --host mongo --port 27017 --db ${MONGO_DATABASE} --username ${MONGO_USER} --password ${MONGO_PASSWORD}\
  --gzip --archive="/workdir/mongo_dump_new_${today}.gz" --authenticationDatabase admin