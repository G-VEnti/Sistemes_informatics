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
hash_salt=$(printf "%s%s" "$hash_clientPassword" "$salt" | sha256sum | cut -d' ' -f1)


# Esperant missatge del client
msg=$(nc -l -p $PORT)


# Divisio del missatge rebut en capçalera, username i password
clientUsername=$(echo $msg | cut -d " " -f 2)
clientPassword=$(echo $clientUsername | cut -d ":" -f 2)
clientUsername=$(echo $clientUsername | cut -d ":" -f 1)
msg=$(echo $msg | cut -d " " -f 1)


# Comproba la capçalera
if [[ "$msg" != "AUTH" ]]; then
  echo "KO_FORMAT" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
# Comproba el nom d'usuari i la contraseña rebuda
elif [[ "$clientUsername" != "GVC" || "$clientPassword" != "$hash_salt" ]]; then
  echo "KO_AUTH" | nc -q 0 $CLIENT_IP $PORT
  echo "[ERROR] Credencials incorrectes."
  exit 1
else
  echo "OK_AUTH" | nc -q 0 $CLIENT_IP $PORT
fi

echo "Login completat."

exit 0