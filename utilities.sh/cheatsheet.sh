#!/bin/bash
# author: eleAche
# descripcion: utilidad para consultar trucos de forma accesible.
mensaje_ayuda() {
  local trucos=$(curl cheat.sh/:list | wc -l)
cat << EOF
Utilidad para consultar trucos desde la terminal.
Hay un total de $trucos listas de trucos disponibles.
  uso: $0 [keyword]
  ejemplos:
    $0 qemu
    $0 find
    $0 nc
 --=[ Autor de cheat.sh:   @igor_chubin   ]=--
EOF
}

query() {
  local entry="$1"
  curl "https://cheat.sh/${entry}"
}

if (( $# -eq 0 ))
  then
    mensaje_ayuda
    exit
elif (( $# >= 2 ))
  then
    echo "solo se admite 1 argumento."
    exit
fi

query "$1"
