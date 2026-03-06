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

# Generacio del hash_salt
hash_clientPassword=$(printf "%s" "awer" | sha256sum | cut -d' ' -f1)
hash_salt=$(printf "%s%s" "$hash_clientPassword" "$salt")


# Esperant missatge del client
msg=$(nc -l -p $PORT)



if [[ (echo $msg | cut -d " " -f 1) != "AUTH" ]]; then
  echo "KO_FORMAT" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
elif [[ (echo $msg | cut -d ":" -f 1) != "GVC" -o (echo $msg | cut -d ":" -f 2) !=  ]]
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