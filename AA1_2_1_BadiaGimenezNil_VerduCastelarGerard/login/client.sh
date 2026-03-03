SERVER_IP="10.0.2.15"
PORT=60000

#Enviament de capçalera
echo "HELLO" | nc -q 0 $SERVER_IP $PORT

read -p "Introdueix un nom d'usuari:" userName
read -p "Introdueix una contrasenya:" password

hash_password=$(printf "%s" "$password" | sha256sum | cut -d' ' -f1)
hash_salt=$(printf "%s%s" "$hash_password" "$salt" | sha256sum | cut -d' ' -f1)

echo "AUTH" | nc -q 0 $SERVER_IP $PORT
echo "$userName" | nc -q 0 $SERVER_IP $PORT
echo "$hash_salt" | nc -q 0 $SERVER_IP $PORT

#Esperant rebuda de capçalera
msg=$(nc -l -p $PORT)

if [[ "$msg" == "OK_AUTH" ]]; then 
  echo "Inici de sessio completat."
  exit 0
fi

if [[ "$msg" == "KO_AUTH" ]]; then
  echo "Credencials incorrectes"
  exit 0
fi

if [[ "$msg" == "KO_AUTH" ]]; then
  echo "[ERROR]"
  exit 1
fi

