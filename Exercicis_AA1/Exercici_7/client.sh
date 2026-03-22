SERVER_IP="127.0.0.1"
PORT=60000

# Enviament de capçalera
echo "HELLO" | nc -q 0 $SERVER_IP $PORT

# Espera un missatge del servidor
echo "Esperant capcalera"
msg=$(nc -l -p $PORT)


# Validacio de la capçalera
if [[ "$msg" != "OK_HEADER" ]]; then
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
fi


# Imprimeix per pantalla el missatge i escolta l'input de l'usuari
read -p "Envia el teu moviment (PEDRA, PAPER, TISORA)" clientMove

echo "MOVE $clientMove" | nc -q 0 $SERVER_IP $PORT

# Esperant rebuda de capçalera
msg=$(nc -l -p $PORT)

serverResult=$(echo $msg | cut -d " " -f 2)
msg=$(echo $msg | cut -d " " -f 1)


# Comprobació de la capçalera
if [[ "$msg" != "RESULT" ]]; then 
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
fi

if [[ "$serverResult" == "DRAW" ]]; then
  echo "DRAW"
elif [[ "$serverResult" == "CLIENT_WIN" ]]; then
  echo "CLIENT_WIN"
elif [[ "$serverResult" == "SERVER_WIN" ]]; then
  echo "SERVER_WIN"
fi

exit 0