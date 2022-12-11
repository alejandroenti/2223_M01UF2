#!/bin/bash

IP_LOCAL="127.0.0.1"
PORT="2223"
SERVER_ADDRESS="localhost"

echo "Cliente TURIP"

echo "(1) SEND MSG: HOLI_TURIP $IP_LOCAL IP_MD5"
IP_MD5=`echo $IP_LOCAL | md5sum | cut -d " " -f 1`
echo "HOLI_TURIP $IP_LOCAL $IP_MD5" | nc $SERVER_ADDRESS $PORT

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

# Enviamos el número de archivos que se van a generar
echo "(5) SEND MSG: NUM_FILES num"
NUM_FILES=`ls vaca | wc -l`
NUM_FILES_MD5=`echo $NUM_FILES | md5sum | cut -d " " -f 1`
echo "NUM_FILES $NUM_FILES $NUM_FILES_MD5" | nc $SERVER_ADDRESS $PORT

echo "(6) LISTEN: Comprobacion Num Files"
MSG=`nc -l $PORT`

# Comprobamos el número de archivos le ha llegado coorrectamente al servidor
if [ "$MSG" != "OK_FILE_NUM" ]
then
	echo "ERROR 3: Numero de archivos incorrecto"
	exit 3
fi

# Comenzamos el bucle de envíos

for FILE in `ls vacas`
do
	# Enviamos el nombre del archivo a generar por el servidor
	FILENAME_MD5=`echo $FILE | md5sum | cut -d " " -f 1`
	echo "FILE_NAME $FILE $FILENAME_MD5" | nc $SERVER_ADDRESS $PORT
	

	echo "(10) LISTEN: Comprobacion Filename"
	MSG=`nc -l $PORT`

	if [ "$MSG" != "OK_FILE_NAME" ]
	then
		echo "ERROR 2: Nombre de archivo incorrecto"
		exit 2
	fi

	#Eviamos el contenido del archivo
	echo "(11) SEND: Enviamos el contenido del archivo"
	cat vacas/$FILE | nc $SERVER_ADDRESS $PORT
done

exit 0
