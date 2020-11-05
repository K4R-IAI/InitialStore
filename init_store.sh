#!/usr/bin/env bash

storeName='Refills Lab'

#hostname='localhost'
hostname='ked.informatik.uni-bremen.de'

function get_id ()
{
	echo "Searching for store ID of $storeName..."
	for ((i=0;i<$(curl -s http://${hostname}:8090/k4r-core/api/v0/stores | jq '. | length');i++))
	do	
		if [[ $(curl -s http://${hostname}:8090/k4r-core/api/v0/stores | jq ".[$i] | .storeName") == \"$storeName\" ]]
		then	
			id=$(curl -s http://${hostname}:8090/k4r-core/api/v0/stores | jq ".[$i] | .id")
			echo "Store $storeName found with id $id"
		fi
	done
}

get_id

if [ -z "$id" ]
then
	echo "Store $storeName not found, create one"
	curl -X POST -H "Content-Type: application/json" -d @store.json http://${hostname}:8090/k4r-core/api/v0/stores
	echo -e "\nStore $storeName is created"
	get_id
fi

echo "Upload map for store $storeName with id $id"
curl -s -X POST -H "Content-Type: application/json" -d @map.json http://${hostname}:8090/k4r-core/api/v0/stores/$id/map2d > /dev/null
