#!/bin/bash

PORT="2223"
SERVER_ADDRESS="localhost"

echo "Cliente TURIP"

echo "(1) SEND MSG: HOLI_TURIP 127.0.0.1"
echo "HOLI_TURIP 127.0.0.1" | nc $SERVER_ADDRESS $PORT

# Nos ponemos en escucha por el puerto 2223 para recibir la respuesta

echo "(2) LISTEN: Comprobacion Handshake"
MSG=`nc -l $PORT`

# Validamos si el mensaje recibido es OK_TURIP
# En caso de recibir KO_TURIP, mostramos mensaje de error y salimos
#	con el código de estado 1

if [ "$MSG" != "OK_TURIP" ]
then
	echo "ERROR 1: Handshake incorrecto"
	exit 1
fi

# Enviamos el nombre del archivo a generar por el servidor
echo "(5) SEND MSG: FILE_NAME filename"
FILENAME="vaca.vaca"
echo "FILE_NAME $FILENAME" | nc $SERVER_ADDRESS $PORT

echo "(6) LISTEN: Comprobacion Filename"
MSG=`nc -l $PORT`

if [ "$MSG" != "OK_FILE_NAME" ]
then
	echo "ERROR 2: Nombre de archivo incorrecto"
	exit 2
fi

#Eviamos el contenido del archivo
echo "(9) SEND: Enviamos el contenido del archivo"
cat vacas/$FILENAME | nc $SERVER_ADDRESS $PORT


exit 0
