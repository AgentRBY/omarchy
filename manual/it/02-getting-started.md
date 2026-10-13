# Per iniziare

Omarchy si installa usando una ISO. Puoi scegliere tra un'installazione su intero disco, che occupa l'intera unità, o un'installazione nello spazio libero, che mette Omarchy nello spazio non allocato di un'unità — è così che fai dual boot accanto a Windows o a un altro sistema operativo (vedi [installazione dual-boot](50-dual-boot-install.md) — nota che dovrai prima disattivare BitLocker in Windows). In ogni caso, l'installazione usa per impostazione predefinita la cifratura completa, e l'opzione su intero disco cancellerà l'unità selezionata, quindi assicurati di fare un backup prima di usarne una esistente!

Prima [scarica la ISO di Omarchy](https://omarchy.org/), mettila su una chiavetta USB (usa [balenaEtcher](https://etcher.balena.io/) su Mac/Windows o [caligula](https://github.com/ifd3f/caligula) su Linux) e avviala dalla chiavetta.

_Devi disattivare Secure Boot e/o TPM nel BIOS. Devi disattivarli per poter installare Omarchy. Sono schemi di sicurezza Microsoft pensati per Windows e per le distribuzioni Linux affiliate a Microsoft._

Poi rispondi alle domande di configurazione e confermale in questo modo:

 ![install-config](images/install-config.webp)

Poi seleziona un'unità per l'installazione, rilassati e guarda lo spettacolo dell'installazione. Sulle macchine moderne più veloci può concludersi in meno di un minuto, ma non dovrebbe richiedere più di 5 minuti nemmeno su un computer più vecchio.

 ![install-done](images/install-done.webp)

Ora sei pronto per Omarchy!

### Usa una tastiera cablata o a 2,4 GHz!

La cifratura completa del disco non ti permette di inserire la password da una tastiera Bluetooth all'avvio. Proprio come non puoi usare una tastiera Bluetooth per entrare nel BIOS di un PC. Ti servirà una tastiera che usi un dongle a 2,4 GHz oppure un cavo (che comunque è molto meglio per la latenza!). Io personalmente adoro la [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Installazione per un altro proprietario

Se stai preparando una macchina per qualcun altro — un familiare, un nuovo dipendente, un acquirente — non dovresti rispondere alle domande personali per conto suo. Premi `Ctrl + C` nella primissima schermata dell'installatore (la selezione della tastiera), e Omarchy si offrirà di preparare invece la macchina per un altro proprietario. Il sistema si installa subito, ma tutta la configurazione personale — layout tastiera, nome utente, password — viene rimandata al primo avvio della macchina. L'unità è comunque cifrata per impostazione predefinita, e la password che il nuovo proprietario sceglie al primo avvio diventa anche la password di cifratura. (Anche una macchina che stai già usando può essere consegnata senza reinstallare — vedi [ripristinare il computer](48-security.md).)

### Installazioni non presidiate

La ISO può anche installarsi completamente da sola — senza tastiera, senza procedura guidata — quando riceve la sua configurazione su una seconda unità. È il modo per trattare Omarchy come un'immagine di base per VM e macchine di flotta. Vedi [installazioni non presidiate](51-unattended-installs.md).

### Installazioni senza cifratura

Omarchy viene installato con cifratura per impostazione predefinita. È la scelta sicura e responsabile per qualsiasi computer che possa essere perso o rubato. Non vuoi che chiunque abbia accesso al tuo hardware possa ottenere i tuoi dati!

Ma in circostanze speciali, come installazioni remote di Omarchy su computer protetti o installazioni usa e getta senza dati sensibili, potresti voler installare senza cifratura. Puoi premere `Ctrl + C` alla conferma della formattazione del disco per passare a un'installazione senza cifratura.

### Lingua

Omarchy parla 50 lingue — lo stesso insieme di omarchy.org — e l'inglese è la predefinita. Per cambiare, apri il menu Omarchy e vai su _Impostazioni > Lingua_, oppure esegui `omarchy language <code>` in un terminale (`omarchy language list` mostra i codici). Il menu, il desktop e le notifiche di Omarchy cambiano lingua immediatamente, e la locale di sistema viene impostata di conseguenza, così le altre applicazioni seguono al prossimo accesso.

### Aiuto se ti blocchi

Se ti blocchi, di solito puoi trovare qualcuno disposto ad aiutarti nel canale _#omarchy-help_ sul [Discord della comunità](https://omarchy.org/discord).
