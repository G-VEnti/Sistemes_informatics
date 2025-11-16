# Exercici 2

## Apartat a)

### Creació del directori docs_bash:

```
cd "carpeta_personal"

mkdir docs_bash
```


### Creació subdirectoris scripts i info:
```
cd docs_bash

mkdir scripts info
```
### Creació arxiu README.md:
```
touch README.md
```
### Mostrar per pantalla whoami i date:
```
echo "$(whoami) - $(date)"
```
### Fitxer usuaris.log amb la informació anterior:
```
echo "$(whoami) - $(date)" > usuaris.log
```
## Apartat  b)
```
cd scripts

touch sys_check.sh

cd ..

ls *
```
## Edició del fitxer per a que imprimeixi data actual i actualitzi la llibreria de paquets:
```
cd scripts

nano sys_check.sh

date

apt update

apt upgrade

^X

y
```
### Execució del fitxer resultant:
```
bash sys_check.sh

//No es pot executar el programa per falta de permisos

//Es pot solucionar aplicant sudo al inici de la comanda.

sudo bash sys_check.sh
```
## Apartat c)

### Script per a obtenir la descripció de la comanda tail:
```
touch tail_descripcio.sh

nano tail_descripcio.sh

man tail 

^X

y

bash tail_descripcio.sh

//Per a mostrar la última línia d'uun fitxer cal executar: tail -n
```
## Apartat d)

### Afegir contingut de sys_check.sh a README.md
```
cd ..

mv README.md scripts

cd scripts

cat sys_check.sh > README.md
```
### Explicació motiu utilització usuari normal
```
//Em utilitzat l'usuari normal (o un usuari que no sigui "root") perquè al utilitzar l'usuari "root" les comandes s'executen amb els poders d'administrador i podria causar una corrupció del sistema operatiu si s'executessin certes comandes.
Pel mateix motiu es molt perillós executar comandes amb el "prefix" sudo su.
```
