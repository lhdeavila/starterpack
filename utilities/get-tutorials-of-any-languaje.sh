#!/usr/bin/env bash
# Author: eleAche
# description: utilidad para obtener documentacion de cualquier lenguaje de programacion en castellano.
query=${1,,}
function gettutorial {
	local q="$1"
	local raw=/tmp/$q.txt
	local output=${q^^}_tut.txt
	curl cheat.sh/$q/:learn > $raw
	parse_tutorial(){
		local file="$1"
		local parse coment
		cat "$file" | grep -E '.+' | while read line
		  do
  		  parse=$(echo $line | grep -c '#')
				# echo -en "\e[3${RANDOM::1}m[!] traduciendo... \e[m\r"
				if (( parse==0 ))
					then
					echo "$line"
					else
					coment=`echo "$line" | awk -F'#' '{print $2}' | trans -b :es`
					echo "`echo $line | awk -F'#' '{print $1}'` # ${coment}" | sed 's/\[39\;00m//g'
				fi
	done 2> /dev/null
	}
	parse_tutorial $raw # >> ${q^^}_tutorial.txt
}

function ayuda(){
cat << EOF
  Descripcion: Este script te consigue un tutorial en castellano del lenguaje de programacion que tu quieras!
	Uso: $0 [lenguaje]
	Ejemplo:
			$0 rUby
			$0 Ruby
			$0 ruby
	# los 3 ejemplos son validos!
EOF
}

[[ "$#" -eq "1" ]] && gettutorial "$query" || ayuda
