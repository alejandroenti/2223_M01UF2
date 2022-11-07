#!/bin/bash

# Nombre del protocolo
# Transfer Unite Recursive International Protocol
# TURIP
# Puerto 2223

echo "Servidor Transfer Unite Recursive International Protocol"

echo "(0) LISTEN"
MSG=`nc -l 2223`

# Revisamos si el mensaje recibido es correcto
# Para ello separados el código de error recibido de la IP
# En caso de no ser correcto, mostraremos un mensaje de ERROR
# 	y salimos con el código de estado 1

ERRORCLIENTE=`echo $MSG | cut -d " " -f 1`
IPCLIENTE=`echo $MSG | cut -d " " -f 1`

if [ "$ERRORCLIENTE" != "HOLI_TURIP" ]
then
	echo "ERROR 1: Handshake incorrecto"
	echo "KO_TURIP" | nc localhost 2223
	exit 1
else
	echo "OK_TURIP" | nc localhost 2223
fi
