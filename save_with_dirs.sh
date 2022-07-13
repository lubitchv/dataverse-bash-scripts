export API_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
export SERVER_URL=https://borealisdata.ca
export PERSISTENT_ID=doi:10.5683/SP3/PSWY62

IFS=" "
mkdir -p dataset

curl -H "X-Dataverse-key:$API_TOKEN" "$SERVER_URL/api/datasets/:persistentId//versions/:latest/files?persistentId=$PERSISTENT_ID" > dataset.json
jq  '.data |.[] | { id: .dataFile["id"], filename: .dataFile["filename"], directoryLabel} | join(" ")'  dataset.json | sed -e 's/^"//' -e 's/"$//' | while read -r out

do
    read -ra newarr <<< "$out"
    id="${newarr[0]}"
    directory="dataset/${newarr[2]}"
    filename="dataset/${newarr[2]}/${newarr[1]}"
    mkdir -p $directory
    echo $filename
    curl -H "X-Dataverse-key:$API_TOKEN" "$SERVER_URL/api/access/datafile/$id" > "$filename"
done


