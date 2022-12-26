#!/bin/bash
# author: eleAche
# description: recovers pdf files, filters duplicates, and organizes for later compression.

sudo apt install poppler-utils translate-shell parallel

# environment
output_dir=/home/user/ficheros
[[ -d $output_dir ]] || mkdir $output_dir
dashboard=$(mktemp)
script=$output_dir/.script_container

# collection of objects
sudo find / -iname '*.pdf' -exec sha1sum {} \; >> $dashboard
remover_duplicados=$(cat $dashboard | awk '{print $1}' | sort -u | uniq)

# object processing
convertiratexto() {
  local fichero="$1"
  ruta_de_fichero=$(grep $fichero $dashboard | head -1 | awk '{print $2}')
  nuevo_nombre=$(echo ${ruta_de_fichero%.pdf} | awk -F/ '{print $NF}' | grep -Eo '[a-zA-Z0-9]+' | tr '\n' ' ' | sed 's/ //g')
  pdftotext "$ruta_de_fichero" $output_dir/$nuevo_nombre.txt
}
for hash_fichero in $remover_duplicados
  do
    echo -en " procesando: \e[3${RANDOM::1}m ${hash_fichero} \e[m\r"
    convertiratexto $hash_fichero
  done 2>/dev/null

cd $output_dir
cat << 'EOF' > $script
trans -b :es -input "$1" -output "${1%.txt}-es.txt"
EOF

parallel bash $script ::: ls *.txt
exit



