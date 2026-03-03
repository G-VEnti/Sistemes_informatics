#!/bin/bash

# 0.1 Constants i variables de configuració global
CLIENT_IP="10.0.2.15"
PORT=60000
BOARD=(1 2 3 4 5 6 7 8 9)



# 0.2 Afegeix configuració continguda al fitxer utils.sh
#   'source $file' executa el contingut de $file en el mateix entorn de shell,
#     és a dir, defineix codi (funcions, variables...) que passa a estar disponible
#     a la sessió de shell actual (a la nostra terminal).
#     Afegint 'source $file' tant al client com al servidor, podem reutilitzar
#     tot el codi de $file sense duplicar-lo.
LOG_FILE="server.log"
source utils.sh


# 0.3 Definició de la funció que printa el tauler
print_board() {
  echo " ${BOARD[0]} | ${BOARD[1]} | ${BOARD[2]} "
  echo "---+---+---"
  echo " ${BOARD[3]} | ${BOARD[4]} | ${BOARD[5]} "
  echo "---+---+---"
  echo " ${BOARD[6]} | ${BOARD[7]} | ${BOARD[8]} "
}



# 0.4 Envia a stdout si s'ha guanyat la partida (echo "WIN" o echo "NONE")
check_win() {
  # = Comprovació de files =
  # Fila 1: posicions 0,1,2
  if [[ "${BOARD[0]}" == "${BOARD[1]}" && "${BOARD[1]}" == "${BOARD[2]}" ]]; then
    echo "WIN"
    return
  fi

  # Fila 2: posicions 3,4,5
  if [[ "${BOARD[3]}" == "${BOARD[4]}" && "${BOARD[4]}" == "${BOARD[5]}" ]]; then
    echo "WIN"
    return
  fi

  # Fila 3: posicions 6,7,8
  if [[ "${BOARD[6]}" == "${BOARD[7]}" && "${BOARD[7]}" == "${BOARD[8]}" ]]; then
    echo "WIN"
    return
  fi

  # = Comprovació de columnes =
  # Columna 1: posicions 0,3,6
  if [[ "${BOARD[0]}" == "${BOARD[3]}" && "${BOARD[3]}" == "${BOARD[6]}" ]]; then
    echo "WIN"
    return
  fi

  # Columna 2: posicions 1,4,7
  if [[ "${BOARD[1]}" == "${BOARD[4]}" && "${BOARD[4]}" == "${BOARD[7]}" ]]; then
    echo "WIN"
    return
  fi

  # Columna 3: posicions 2,5,8
  if [[ "${BOARD[2]}" == "${BOARD[5]}" && "${BOARD[5]}" == "${BOARD[8]}" ]]; then
    echo "WIN"
    return
  fi

  # = Comprovació de diagonals =
  # Diagonal principal: 0,4,8
  if [[ "${BOARD[0]}" == "${BOARD[4]}" && "${BOARD[4]}" == "${BOARD[8]}" ]]; then
    echo "WIN"
    return
  fi

  # Diagonal inversa: 2,4,6
  if [[ "${BOARD[2]}" == "${BOARD[4]}" && "${BOARD[4]}" == "${BOARD[6]}" ]]; then
    echo "WIN"
    return
  fi

  # Si no s'ha detectat cap "WIN", retorna un "NONE"
  echo "NONE"
}

# 0.5 Envia a stdout si el moviment és vàlid (echo "VALID" o echo "NOT_VALID")
# TODO: Per si utilitzeu aquesta versió, la manera de fer crida a la funció:
#   valid_pos=$(check_valid_pos "$pos")
check_valid_pos() {
	local aux_pos="$1"

	# 0.5.1 Comprova que aux_pos conté només dígits
	if ! echo "$aux_pos" | grep -Eq '^[0-9]+$'; then 
		echo "NOT_VALID"
		return
	fi

	# 0.5.2 Comprova que aux_pos conté un nombre dins del tauler
	if [ "$aux_pos" -lt 1 -o "$aux_pos" -gt 9 ]; then
		echo "NOT_VALID"
		return
	fi

	# 0.5.3 Comprova que aux_pos conté el nombre d'una casella no ocupada
	local array_pos=$((aux_pos - 1))
	local board_char="${BOARD[${array_pos}]}"
	if [ "$board_char" = "$SERVER_CHAR" -o "$board_char" = "$CLIENT_CHAR" ]; then
		echo "NOT_VALID"
		return
	fi

	echo "VALID"
}




# Missatge de benvinguda
echo "Programa iniciat, benvingut" | tee -a $LOG_FILE

# 1 Espera connexió
echo "Esperant connexió..." | tee -a $LOG_FILE

#Esperant rebuda de capçalera
msg=$(nc -l -p $PORT)

# 2.1 Si la connexió no és un "HELLO", s'envia un "KO" i es tanca el programa
if [[ "$msg" != "HELLO" ]]; then
  echo "KO" | nc -q 0 $CLIENT_IP $PORT 
  echo "[ERROR] Capcalera rebuda incorrecte." | tee -a $LOG_FILE
  exit 1
else
  # 2.2 Si la connexió és "HELLO", s'envia un "OK" i es continua el programa
  read -p "Escriu OK si vols permetre la connexio (escriu qualsevol altre cosa per denegarla): " connexionCheck
  echo "$connexionCheck" | tee -a $LOG_FILE | nc -q 0 $CLIENT_IP $PORT  
fi

if [[ "$connexionCheck" = "OK" ]]; then
  echo "Connexio establerta" | tee -a $LOG_FILE
else
  echo "Connexio denegada, finalitzacio del programa." | tee -a $LOG_FILE
  exit 0
fi


# 3 Missatge de benvinguda a la partida
echo "Benvinguts al tres en ratlla"

# S'envia aquest missatge al log
echo "Partida iniciada" >> $LOG_FILE

# Contador per a la condicio d'empat
movementCounter=1


# 4 GameLoop
while [[ "$movementCounter" -le 9 ]]; do  

  echo "Moviment: $movementCounter" | tee -a $LOG_FILE

  # 3.1 Es printa el tauler buit
  print_board

  # == TORN SERVIDOR ==

  # 4.1 Es demana una posició al jugador servidor
  # pos - guarda linput de lusuari
  read -p "Posició del servidor (1-9): " pos
  echo "Posició del servidor (1-9): $pos" >> $LOG_FILE

  # Crida de la funcio per a comprobar que la posicio introduida es valida
  valid_pos=$(check_valid_pos "$pos")

  # board_index - guarda el resultat de $(( ... ))
  board_index=$((pos - 1))
  
  # assigna "O" a la casella BOARD[...]
  BOARD[$board_index]="O"

  # 4.2 Es comprova si s'ha guanyat (result="WIN" o result="NONE")
  result=$(check_win)

  if [[ "$result" == "WIN" ]]; then
    # S'envia un "SERVER_WIN" al client i es mostra per pantalla
    echo "SERVER_WIN" | tee >(nc -q 0 $CLIENT_IP $PORT)
    print_board
    # Es mostra per pantalla el missatge i s'envia al fitxer log
    break
  fi

  if [[ "$movementCounter" -lt 9 ]]; then

    # 4.3 Es printa el tauler
    ((++movementCounter))
    echo "Moviment: $movementCounter" | tee -a $LOG_FILE
    print_board
    echo "Torn del client..." | tee -a $LOG_FILE

    # == TORN CLIENT ==
    # 4.4 S'envia al client que comença el seu torn
    echo "Et toca: " | tee -a $LOG_FILE | nc -q 0 $CLIENT_IP $PORT 

    # 4.5 Es llegeix el moviment del client
    response=$(nc -l -p $PORT)

    # Crida de la funcio per a comprobar que la posicio introduida es valida
    valid_pos=$(check_valid_pos "$response")
  
    # Mostra el missatge i l'envia al log
    echo "Posició del client (1-9): $response" | tee -a $LOG_FILE

    # 4.6 S'actualitza el moviment al tauler
    response=$(($response - 1))
    BOARD[$response]="X"

    # 4.7 Es comprova si s'ha guanyat (result="WIN" o result="NONE")
    result=$(check_win)
    if [[ "$result" == "WIN" ]]; then
    # S'envia un "CLIENT_WIN" al client, al arxiu log y es mostra per pantalla
    echo "CLIENT_WIN" | tee -a $LOG_FILE | nc -q 0 $CLIENT_IP $PORT
    echo "CLIENT_WIN"
    fi
  fi
  # 4.8 Es printa el tauler
  print_board 

  ((++movementCounter))
  

done

if [[ "$result" != "WIN" ]]; then
  echo "Empat" | tee -a $LOG_FILE | nc -q 0 $CLIENT_IP $PORT
  echo "Empat"
fi

# Es mostra per pantall i s'envia al log el missatge
echo "Partida finalitzada, fins la proxima :)" | tee -a $LOG_FILE

exit 0