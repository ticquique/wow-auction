while getopts ":i:n:" arg; do
  case $arg in
    i) input=$OPTARG;;
  esac
done

input=${input:-"test.json"}
jq -c ".auctions[]" $input \
| head -n 500 \
| xargs -d "\n" -L1 -I {} \
curl -XPOST "http://localhost:9200/auctions/_doc/" -H 'Content-Type: application/json' -d"{}"