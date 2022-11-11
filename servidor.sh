#!/bin/bash

# Nombre del protocolo
# Transfer Unite Recursive International Protocol
# TURIP
# Puerto 2223

PORT="2223"

echo "Servidor Transfer Unite Recursive International Protocol"

echo "(0) LISTEN HANDSHAKE"
MSG=`nc -l $PORT`

# Revisamos si el mensaje recibido es correcto
# Para ello separados el código de error recibido de la IP
# En caso de no ser correcto, mostraremos un mensaje de ERROR
# 	y salimos con el código de estado 1

HANDSHAKE=`echo $MSG | cut -d " " -f 1`
IP_CLIENT=`echo $MSG | cut -d " " -f 2`

# Revisamos todas las opciones que se encuentran mal y por
# último hacemos la opción correcta fuera del IF
echo "(3) SEND MSG: OK_TURIP / KO_TURIP"
if [ "$HANDSHAKE" != "HOLI_TURIP" ]
then
	echo "ERROR 1: Handshake incorrecto"
	echo "KO_TURIP" | nc $IP_CLIENT $PORT 
	exit 1
fi

echo "OK_TURIP" | nc $IP_CLIENT $PORT 

echo "(4) LISTEN FILENAME"
MSG=`nc -l $PORT`

# Cogemos el prefijo y el nombre de archivo
PREFIX=`echo $MSG | cut -d " " -f 1`
FILENAME=`echo $MSG | cut -d " " -f 2`

echo "(7) SEND MSG: OK_FILE_NAME / KO_FILE_NAME"
if [ "$PREFIX" != "FILE_NAME" ]
then
	echo "ERROR 2: Nombre de archivo incorrecto"
	echo "KO_FILE_NAME" | nc $IP_CLIENT $PORT
	exit 2
fi

echo "OK_FILE_NAME" | nc $IP_CLIENT $PORT

#Nos ponemos a escuchar el contenido del archivo
echo "(8) LISTEN FILE CONTENT"
nc -l $PORT > inbox/$FILENAME

exit 0
