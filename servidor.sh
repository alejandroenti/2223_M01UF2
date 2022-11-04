#!/bin/bash

# Nombre del protocolo
# Transfer Unite Recursive International Protocol
# TURIP
# Puerto 2223

echo "Servidor Transfer Unite Recursive International Protocol"

echo "(0) LISTEN"
MSG=`nc -l 2223`

# Revisamos si el mensaje recibido es correcto
# En caso de no ser correcto, mostraremos un mensaje de ERROR
# 	y salimos con el código de estado 1
if [ "$MSG" != "HOLI_TURIP" ]
then
	echo "ERROR 1: Handshake incorrecto"
	exit 1
fi
