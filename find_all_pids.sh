export API_TOKEN=
export SERVER_URL=https://borealisdata.ca
#export PERSISTENT_ID=doi:10.80240/FK2/UKKWRJ
export DATAVERSE=odesi
export ROWS=1000
export START=0
export PAGE=1

IFS=" "
url="$SERVER_URL/api/search?q=*&type=dataset&subtree=$DATAVERSE&start=$START&per_page=$PAGE"
url2="$SERVER_URL/api/search?q=*&type=dataset&subtree=$DATAVERSE&start=$START&per_page=$ROWS"
total_count="$(curl -s ${url} | jq -r '.data.total_count')"
echo $total_count

while [ $START -le $total_count  ]
do
    url2="$SERVER_URL/api/search?q=*&type=dataset&subtree=$DATAVERSE&start=$START&per_page=$ROWS"
    curl  $url2 |  jq -r '.data.items[].global_id'
    START=$(($START + $ROWS))
done



