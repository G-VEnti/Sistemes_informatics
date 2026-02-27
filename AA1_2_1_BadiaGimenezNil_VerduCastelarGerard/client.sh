#!/bin/bash

#telnet 10.40.2.115 23 IP Nil

SERVER_IP="10.0.2.15"
PORT=60000

#Enviament de capçalera
echo "HELLO" | nc -q 0 $SERVER_IP $PORT
echo "Capcalera enviada, esperant permis de connexio..."

#Esperant rebuda de capçalera
response=$(nc -l -p $PORT)

if [[ "$response" != "OK" ]]; then
  exit 1
fi

echo "Permis concedit, connexió establerta"

while [[ "$response"]]; do

  echo "Esperant el torn ..."

  # Sacaba el temps despera quan el servidor acaba el torn
  response=$(nc -l -p $PORT)
  echo $response  


  # TODO: Gestió de missatges rebuts

  # SERVER_WIN  
  if [[ "$response" = "SERVER_WIN" || "$response" = "CLIENT_WIN" || "$response" = "Empat" ]]; then
    break
  fi

  # ...

  # == TORN CLIENT ==
  # TODO: pregunta posició i s'envia al servidor
  # No sabem perque, pero el Nil ha descobert que si passes clientPos sense $
  # server.sh agafa el numero de chars de la paraula clientPos
  read -p "Posició del client (1-9): " clientPos
  echo $clientPos | nc -q 0 $SERVER_IP $PORT

done

echo "Partida finalitzada"

exit 0