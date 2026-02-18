Per **comprendere l’esercizio** e riscrivere la soluzione utilizzando Terraform, ho scelto un approccio descrittivo, che riassumo in poche righe.
Non ho voluto iniziare a scrivere velocemente il "codice" necessario a costruire l’architettura; ho preferito pormi alcune domande, 
con l’intento di essere innanzitutto il più critico possibile sulle scelte strutturali adottate e, successivamente, 
capire come riprodurre la stessa architettura utilizzando Terraform.


***Qual è il problema?***

Quando carico delle immagini in S3 e poi le servo tramite CloudFront, di base sto ditribuendo dei file statici: 
se esiste il file x.jpg viene consegnato a chiunde lo chieda. CloudFront lo consegna velocemente, ma non cambia il contenuto 
dell'immagine stessa: non la ottimizza.
Nella pratica, la stessa immagine non va bene per tutti i tipi scenari.
Esempio: se ho una foto da 4000×3000 e la usi in una card da 300×200 sul sito, il browser scarica comunque il file enorme. È uno spreco: scarichi molti più byte 
di quelli che servono solo per poi ridimensionare “lato client” (che non riduce il peso trasferito).
In sintesi: CloudFront ti rende veloce la distribuzione, ma se l’immagine di partenza è troppo grande o in un formato non ottimale, 
la stai distribuendo velocemente… ma sempre troppo pesante.


***Come è stato risolto?***

La soluzione dell’esercizio è trasformare la distribuzione di immagini da “file statici uguali per tutti” 
a un sistema che genera e serve la variante giusta dell’immagine in base a ciò che chiede il client, e poi inserirla in cache così da non rifare lavoro inutilmente.
Il risultato è che l’ottimizzazione avviene solo quando serve e solo per le varianti effettivamente richieste, mentre il grosso del traffico viene servito come 
contenuto statico tramite CloudFront. 
È un compromesso molto efficiente: ottieni immagini leggere e adatte al contesto, senza dover pre-generare migliaia di versioni a priori, e con performance globali 
perché la consegna è sempre gestita dal CDN.

*In altre parole*: CloudFront continua a fare il suo lavoro (cache e distribuzione globale), ma 
Lambda aggiunge l’intelligenza per “scegliere o creare” la variante ottimizzata, e S3 fa da storage sia per gli originali sia per le versioni generate.
