#!/bin/bash
secret=$WOW_SECRET
id=$WOW_ID

# europe=("shazzrah" "flamelash" "gandling" "razorgore" "firemaw" "gehennas" "golemag" "mograine")
europe=("tyrande" "exodar")

output='/home/results'
while getopts ":i:s:o:" arg; do
  case $arg in
    s) secret=$OPTARG;;
    i) id=$OPTARG;;
    o) output=$OPTARG;;
  esac
done

token=`curl -u ${id}:${secret} -d grant_type=client_credentials https://eu.battle.net/oauth/token | jq -j '.access_token'`

check_different_url() {
  last_updated=`tail -1 /tmp/updates$2.log`
  if [ "$last_updated" == "$1" ]
  then
    false
  else
    echo "$1" >> /tmp/updates$2.log 2>&1
    true
  fi
}

get_server_auction () {
  date=`date +"%Y-%m-%d %H:%M:%S"`
  response=`curl --header "Authorization: Bearer ${token}" https://eu.api.blizzard.com/wow/auction/data/$1?locale=en_US`
  last_updated=`echo $response | jq -j .files[0].lastModified`
  url=`echo $response | jq -j .files[0].url`
  if check_different_url "$last_updated" "$1"
  then
    curl $url > "${output}/auction_${i}_${date}.json"
    echo "Created file ${output}/auction_$1_${date}.json from ${url}" >> /var/log/cron.log 2>&1
  else
    echo "File from ${url} exists yet" >> /var/log/cron.log 2>&1
  fi
}

mkdir -p ${output}

for i in "${europe[@]}"; do   # The quotes are necessary here
  get_server_auction "$i"
done
