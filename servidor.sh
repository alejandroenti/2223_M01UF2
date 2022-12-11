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
IP_CLIENT_MD5=`echo $MSG | cut -d " " -f 3`

#Comprobamos que la IP recibida es correcta con la que nos ha llegado

IP_MD5=`echo $IP_CLIENT | md5sum | cut -d " " -f 1`

if [ "$IP_MD5" != "$IP_CLIENT_MD5" ]
then
	echo "Error 0: IP Cliente incorrecta"
	exit 1
fi

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

echo "(4) LISTEN NUMER OF FILES"
MSG=`nc -l $PORT`

# Cogemos el prefijo el número de archivos y verificamos
PREFIX=`echo $MSG | cut -d " " -f 1`
NUM_FILES_CLIENT=`echo $MSG | cut -d " " -f 2`
NUM_FILES_CLIENT_MD5=`echo $MSG | cut -d " " -f 3`

NUM_FILES_MD5=`echo $NUM_FILES_CLIENT | md5sum | cut -d " " -f 1`

echo "(7) SEND MSG: OK_NUM_FILE / KO_NUM_FILE"
if [ "$NUM_FILES_MD5" != "$NUM_FILES_CLIENT_MD5" ]
then
	echo "Error 3: Numero de archivos incorrecto"
	echo "KO_FILE_NUM" | nc $IP_CLIENT $PORT
	exit 3
fi

echo "OK_FILE_NUM" | nc $IP_CLIENT $PORT

# Hacemos bucle de recepción de los archivos
for FILE in `seq $NUM_FILES_CLIENT`
do
	echo "Escuchamos para el filename"
	MSG=`nc -l $PORT`
	# Cogemos el prefijo y el nombre de archivo
	PREFIX=`echo $MSG | cut -d " " -f 1`
	NAMEFILE=`echo $MSG | cut -d " " -f 2`
	NAMEFILE_CLIENT_MD5=`echo $MSG | cut -d " " -f 3`
	
	NAMEFILE_MD5=`echo $NUM_FILES | md5sum | cut -d " " -f 1`

	echo "(8) SEND MSG: OK_FILE_NAME / KO_FILE_NAME"
	if [ "$NAMEFILE_MD5" != "$NAMEFILE_CLIENT_MD5" ]
	then
		echo "ERROR 2: Nombre de archivo incorrecto"
		echo "KO_FILE_NAME" | nc $IP_CLIENT $PORT
		exit 2
	fi

	echo "OK_FILE_NAME" | nc $IP_CLIENT $PORT

	#Nos ponemos a escuchar el contenido del archivo
	echo "(9) LISTEN FILE CONTENT"
	nc -l $PORT > inbox/$NAMEFILE
done

exit 0
