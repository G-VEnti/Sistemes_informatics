SERVER_IP="10.0.2.15"
PORT=60000

# Enviament de capçalera
echo "HELLO" | nc -q 0 $SERVER_IP $PORT

# Espera un missatge del servidor
echo "Esperant capcalera"
msg=$(nc -l -p $PORT)

# Divisio del missatge rebut en capçalera i salt
serverSalt=$(echo $msg | cut -d " " -f 2)
msg=$(echo $msg | cut -d " " -f 1)


# Validacio de la capçalera
if [[ "$msg" != "OK_HEADER" ]]; then
  echo "KO_HEADER" | nc -q 0 $SERVER_IP $PORT 
  echo "[ERROR] Capcalera rebuda incorrecte."
  exit 1
fi


# Imprimeix per pantalla el missatge i escolta l'input de l'usuari
read -p "Introdueix un nom d'usuari:" userName
read -p "Introdueix una contrasenya:" password


# Encripta la contrasenya introduida amb el salt que ha proporcionat el servidor
hash_password=$(printf "%s" "$password" | sha256sum | cut -d' ' -f1)
hash_salt=$(printf "%s%s" "$hash_password" "$serverSalt" | sha256sum | cut -d' ' -f1)

echo "AUTH $userName:$hash_salt" | nc -q 0 $SERVER_IP $PORT

# Esperant rebuda de capçalera
msg=$(nc -l -p $PORT)


# Comprobació de la capçalera
if [[ "$msg" == "OK_AUTH" ]]; then 
  echo "Inici de sessio completat."
  exit 0
elif [[ "$msg" == "KO_AUTH" ]]; then
  echo "Credencials incorrectes"
  exit 1
elif [[ "$msg" == "KO_FORMAT" ]]; then
  echo "[ERROR]"
  exit 1
fi

