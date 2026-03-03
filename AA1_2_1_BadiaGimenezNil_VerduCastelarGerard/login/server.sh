CLIENT_IP="10.0.2.15"
PORT=60000

#Esperant rebuda de capçalera
msg=$(nc -l -p $PORT)

if [[ "$msg" != "HELLO" ]]; then
  echo "KO" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
fi

echo "Connexio establerta."

salt=$RANDOM

echo "OK_HEADER" | nc -q 0 $CLIENT_IP $PORT
echo "$salt" | nc -q 0 $CLIENT_IP $PORT

hash_salt=$(printf "%s" "$salt" | sha256sum | cut -d' ' -f1)
hash_salt_salt=$(printf "%s%s" "$hash_salt" "$salt" | sha256sum | cut -d' ' -f1)


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