CLIENT_IP="127.0.0.1"
PORT=60000


# Esperant rebuda de capçalera
msg=$(nc -l -p $PORT)


# Validacio de la capçalera rebuda
if [[ "$msg" != "HELLO" ]]; then
  echo "KO_HEADER" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
elif [[ "$msg" == "HELLO" ]]; then
  echo "OK_HEADER" | nc -q 0 $CLIENT_IP $PORT
  echo "Connexio establerta"
fi

# Esperant missatge del client
msg=$(nc -l -p $PORT)


# Divisio del missatge rebut en capçalera i moveiment
clientMove=$(echo $msg | cut -d " " -f 2)
msg=$(echo $msg | cut -d " " -f 1)


# Comproba la capçalera
if [[ "$msg" != "MOVE" ]]; then
  echo "KO_FORMAT" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
fi

read -p "Fes el teu moviment (PEDRA, PAPER, TISORA)" serverMove

# Comproba el moviment
if [[ "$clientMove" == "PEDRA" && "$serverMove" == "PEDRA" ]]; then
  echo "RESULT DRAW" | nc -q 0 $CLIENT_IP $PORT
  echo "DRAW"
elif [[ "$clientMove" == "PAPER" && "$serverMove" == "PAPER" ]]; then
  echo "RESULT DRAW" | nc -q 0 $CLIENT_IP $PORT
  echo "DRAW"
elif [[ "$clientMove" == "TISORA" && "$serverMove" == "TISORA" ]]; then
  echo "RESULT DRAW" | nc -q 0 $CLIENT_IP $PORT
  echo "DRAW"
elif [[ "$clientMove" == "PEDRA" && "$serverMove" == "TISORA" ]]; then
  echo "RESULT CLIENT_WIN" | nc -q 0 $CLIENT_IP $PORT
  echo "CLIENT_WIN"
elif [[ "$clientMove" == "PAPER" && "$serverMove" == "PEDRA" ]]; then
  echo "RESULT CLIENT_WIN" | nc -q 0 $CLIENT_IP $PORT
  echo "CLIENT_WIN"
elif [[ "$clientMove" == "TISORA" && "$serverMove" == "PAPER" ]]; then
  echo "RESULT CLIENT_WIN" | nc -q 0 $CLIENT_IP $PORT
  echo "CLIENT_WIN"
elif [[ "$clientMove" == "PEDRA" && "$serverMove" == "PAPER" ]]; then
  echo "RESULT SERVER_WIN" | nc -q 0 $CLIENT_IP $PORT
  echo "SERVER_WIN"
elif [[ "$clientMove" == "PAPER" && "$serverMove" == "TISORA" ]]; then
  echo "RESULT SERVER_WIN" | nc -q 0 $CLIENT_IP $PORT
  echo "SERVER_WIN"
elif [[ "$clientMove" == "TISORA" && "$serverMove" == "PEDRA" ]]; then
  echo "RESULT SERVER_WIN" | nc -q 0 $CLIENT_IP $PORT
  echo "SERVER_WIN"
fi

exit 0