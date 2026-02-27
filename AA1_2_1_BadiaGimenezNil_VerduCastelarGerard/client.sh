#!/bin/bash

#telnet 10.40.2.115 23 IP Nil

SERVER_IP="192.168.56.101"
PORT=60000

#Enviament de capçalera
echo "HELLO" | nc -q 0 $SERVER_IP $PORT

#Esperant rebuda de capçalera
response=$(nc -l -p $PORT)

if [[ "$response" != "OK" ]]; then
  exit 1
fi

echo "Connexió establerta"

while true; do

  echo "Esperant el torn ..."

  # Sacaba el temps despera quan el servidor acaba el torn
  response=$(nc -l -p $PORT)
  echo $response  


  # TODO: Gestió de missatges rebuts

  # SERVER_WIN  
  if [[ "$response" == "SERVER_WIN" ]]; then
    echo "Partida finalitzada"
    exit 0
  fi

  # CLIENT_WIN
  if [[ "$response" == "CLIENT_WIN" ]]; then
    echo "Partida finalitzada"
    exit 0
  fi

  # ...

  # == TORN CLIENT ==
  # TODO: pregunta posició i s'envia al servidor
  # No sabem perque, pero el Nil ha descobert que si passes clientPos sense $
  # server.sh agafa el numero de chars de la paraula clientPos
  read -p "Posició del client (1-9): " clientPos
  echo $clientPos | nc -q 0 $SERVER_IP $PORT

done

exit 0