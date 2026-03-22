# **Exercicis presentació 6**

## **Exercici 3:** Utilitza dues màquines virtuals Linux i explora la comunicació amb elles.

* **Comprova l’adreça IP amb la comanda $ ip -c a i explica els següents elements (IP,
direcció MAC, dispositiu de xarxa i state UP/DOWN).**

    IP: Internet Protocol (IP) es el número únic que identifica a un dispositiu a internet o en una xarxa local. Amb la comanda "ip -c a" es el número descrit al paràmetre **"inet"**.

    Direcció MAC: Media Acces Control (MAC) es l'identificador únic que les empreses fabricants de hardware assignen a la targeta de xarxa de cadascun dels dispositius que produeixen per a poder-los identificar desde qualsevol dels seus accessos a qualsevol xarxa.

    Dispositius de xarxa: són els components físics que conecten ordinadors i altres dispositius informàtics que permeten la comunicació i l'intercanvi d'informació entre ordinadors, servidors, dispositius d'emmagatzematge, etc.

    State UP/DOWN: es un terme que s'utilitza per a indicar si un component esta operatiu o no. 
    **UP** vol dir que el component es funcional, està conectat i funcionant correctament.
    **DOWN** vol dir quee el component no està actiu, ha fallat o no té connectivitat.

* **Configura les dues màquines amb NAT i fes ping entre elles. Explica el resultat.**

    No s'aconsegueix fer el ping ja que NAT crea una xarxa aïllada per a cada màquina virtual, el que provoca que no es puguin comunicar entre elles.

    * **Configura les dues màquines amb Adaptador pont i fes ping entre elles. Explica el
    resultat.**

    En aquest cas si que s'aconsegueix fer el ping, ja que el mode adaptador pont fa que la màquina virtual es comporti com un equip físic més a la xarxa.

## **Exercici 4:** Utilitza dues màquines virtuals amb Linux i analitza la teva configuració de xarxa:

* **Per cada interfície, indica si està activa, si té una IP assignada i si és IPv4 o IPv6.**

    Les interficies si que estan actives, ho podem saber perquè a la línia "1: lo: <LOOPBACK,UP,LOWER_UP>" podem veure l'state UP que significa que està activa.

    Les dues interficies tenen IP assignades, tant IPv4 (descrita pel parametre "inet"), com IPv6 (descrita pel paràmetre "inet6")

* **Quina configuració de xarxa necessiten dues màquines perquè es puguin fer ping?**
    
    Una de les configuracions de xarxa amb la que es pot aconseguir fer ping entre dues màquines virtuals es mitjançant l'adaptador pont.
    
    **Quina relació hi ha amb les IP públiques o privades?**

    Amb les IP privades només es pot accedir a la màquina virtual desde xarxes locals, mentres que, amb les IP públiques es pot accedit a la màquina virtual desde qualsevol lloc mitjançant internet.

## **Exercici 5:** Investiga i respon amb les teves paraules.

* **Per què el disseny original d’Internet és tan eficient i robust? Explica tres pilars que permeten que la comunicació funcioni encara que hi hagi errors o caigudes de
connexions.**

    Internet va ser creat durant la Guerra Freda amb l'objectiu de crear una xarxa de comunicacions que pogués sobreviure a un atac nuclear.
    Això va donar lloc a una nova arquitectura que fa que en comptes de establir un circuit de dades continu entre l'origen i el destí, la informació es divideix en paquets individuals i aquests viatjen de manera independent per la xarxa.

    Internet es tant robust i eficient gràcies a la seva arquitectura, ja que aquesta permet que si un dels nodes de la xarxa cau, els paquets son reencaminats automàticament a una ruta alternativa que estigui operativa, aconseguint que no faci falta restablir la conexió des del principi. A més els recursos de la xarxa només s'utilitzen quan s'envien paquets.
* **Què és un port? Per a què serveix dins d’una comunicació?**

    Un port és un identificador numèric que s'assigna a una aplicació o servei específic dins d'un dispositiu connectat a una xarxa.

    Serveix per a que l'ordinador sàpiga on ha de "posar" els paquets que arriben d'internet.

* **Busca i explica breument què són els protocols següents i indica quin port utilitzen
per defecte:**

    * **HTTP**

        Hypertext Transfer Protocol: protocol fonamental de la web. Permet la transferència d'hipertext i altres tipus de dades entre un client i un servidor. El seu port per defecte es el 80 (TCP).
    * **HTTPS**

        Hypertext Transfer Protocol Secure: versió xifrada de HTTP. Consisteix a utilitzar HTTP sobre una connexió xifrada mitjançant els protocols SSL/TLS. El seu port per defecte es el 443 (TCP).
    * **FTP**

        File Transfer Protocol: s'utilitza per a la transferència de fitxers entre sistemes connectats a xarxes. El seu port per defecte es el 21 (TCP).
    * **SFTP**

        SSH File Transfer Protocol: serveix per a la transferència segura de fitxers, opera sobre el protocol SSH (Secure Shell). Xifra tant les comandes com les dades. El seu port per defecte es el 22 (TCP).
    * **MySQL**

        Sistema de gestió de bases de dades. El seu port per defecte es el 3306 (TCP).

* **Per què alguns protocols acaben amb TP?**

    TP significa transfer protocol, per tant podem interpretar que els protocols que continguin TP al final del nom tenen la funció principal de transferir dades.

* **Investiga quin és el protocol UDP i explica per què s’utilitza en molts de videojocs
online.**

User Datagram Protocol (UDP) es un protocol sense connexió que permet enviar paquets de dades sense necessitat d'establir una connexió prèvia ni verificar que arribin correctament.

S'utilitza en videojocs perquè UDP minimitza la latència ja que no perd temps en verificacions ni retransmissions. També permet que es perdin paquets, cosa important en els videojocs on-line ja que es millor no rebre un paquet antic que rebre'n un de retardat. A més, els videojocs necessiten enviar constantment informació (com la posició del jugador) i gràcies al UDP, si es perd un paquet, només s'espera a que arribi el següent, mentres que amb TCP, si es perdés un paquet, el joc es pararia esperant que arribés el paquet.

## **Exercici 7. Documenta en un fitxer markdown com accedeixes remotament a una altra màquina.**

**a) Identificació de la IP de la màquina remota.**

**b) Connexió des del client a la màquina remota.**

c) Crea una carpeta amb el teu nom i a dins executa:
    “cowsay "Sabies que puc ser un drac?" > acces_remot.txt”.

d) Comprova el contingut del fitxer acces_remot.txt des del propi servidor.

e) Atura el servei ssh amb “systemctl stop ssh”. Quin missatge es mostra en intentar accedir en remot?

f) Executa la comanda “last -a” i identifica la ip del client en qui t’acabes de connectar.

g) Investiga la comanda “ufw” per activar el tallafocs, acceptar les connexions al port 22 de tothom excepte les que provenen de la IP del client que t’has connectat.