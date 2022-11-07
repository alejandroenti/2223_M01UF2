#!/bin/bash

echo "Cliente TURIP"

echo "(1) SEND MSG: HOLI_TURIP 127.0.0.1"
echo "HOLI_TURIP 127.0.0.1" | nc localhost 2223

# Nos ponemos en escucha por el puerto 2223 para recibir la respuesta

ERROR=`nc -l 2223`

# Validamos si el mensaje recibido es OK_TURIP
# En caso de recibir KO_TURIP, mostramos mensaje de error y salimos
#	con el código de estado 1

if [ "$ERROR" != "OK_TURIP" ]
then
	echo "ERROR 1: Handshake incorrecto"
	exit 1
fi
