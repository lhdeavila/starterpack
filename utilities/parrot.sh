#!/bin/bash

function learn(){
	sudo apt update -y
	sudo apt install translate-shell poppler-utils
}

function bad(){
	sudo macchanger -r $(ip link | grep -Eo '(wlp|enp)+')
	
}

{
	"$1"
}
