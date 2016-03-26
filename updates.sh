#!/bin/bash

#Scrip for update DB  skein

folName=`find  / -type d -name update_sql`;

function finedVersion(){
origLine=$line;
line=$(echo $line | sed 's/ \{1,\}//g');

 if [ $line == "$(echo $line | grep -Po '^(\d)([0-9])*(.)?(createtable.sql)$')" ]
	then
	verNumber=$(echo $line | grep -Po '([1-9]([0-9])?)');
	arrayUpdates[$verNumber]=$origLine;
 fi
}

function executeSql(){
verSQL=`mysql --version|awk '{ print $5 }'|awk -F\, '{ print $1 }' | grep -Po '(\d*)$'`;

 for index in "${!arrayUpdates[@]}"
	do

	if [ $verSQL -le $index ]
		then
		mysql -uroot -p123 -D skein <  "$folName/${arrayUpdates[$index]}"
		fi

 done;
}


while read line;
do
        finedVersion;
#echo "${arrayUpdates[$verNumber]} intu and version $verNumber";

done < <(ls $folName) ;

executeSql;
