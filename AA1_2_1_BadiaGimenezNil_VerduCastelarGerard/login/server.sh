CLIENT_IP="10.0.2.15"
PORT=60000

# Esperant rebuda de capçalera
msg=$(nc -l -p $PORT)

# Validacio de la capçalera rebuda
if [[ "$msg" != "HELLO" ]]; then
  echo "KO_HEADER" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
elif [[ "$msg" == "HELLO" ]]; then
  salt=$RANDOM
  echo "OK_HEADER $salt" | nc -q 0 $CLIENT_IP $PORT
  echo "Connexio establerta, salt enviat."
fi


msg=$(nc -l -p $PORT)

if [[ "$msg" != "AUTH" ]]; then
  echo "KO_CAPCALERA" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
fi


clientUsername=$(nc -l -p $PORT)

if [[ "$clientUsername" != "$salt" ]]; then
  echo "KO_AUTH" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Nom d'usuari incorrecte."
  exit 1
fi


clientHash=$(nc -l -p $PORT)
if [[ "$clientHash" != "$hash_salt_salt" ]]; then
  echo "KO_AUTH" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Nom d'usuari incorrecte."
  exit 1
fi

echo "OK_AUTH" | nc -q 0 $SERVER_IP $PORT