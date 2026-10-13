# Primii pași

Omarchy se instalează folosind un ISO. Poți alege între o instalare pe tot discul, care preia întreaga unitate, sau o instalare în spațiul liber, care pune Omarchy în spațiul nealocat de pe o unitate — așa faci dual boot alături de Windows sau de alt sistem de operare (vezi [instalarea dual-boot](50-dual-boot-install.md) — reține că mai întâi va trebui să dezactivezi BitLocker în Windows). În orice caz, instalarea folosește implicit criptare completă, iar opțiunea pentru tot discul va șterge unitatea selectată, așa că asigură-te că faci o copie de rezervă înainte să folosești una existentă!

[Descarcă mai întâi ISO-ul Omarchy](https://omarchy.org/), pune-l pe un stick USB (folosește [balenaEtcher](https://etcher.balena.io/) pe Mac/Windows sau [caligula](https://github.com/ifd3f/caligula) pe Linux) și pornește de pe stick.

_Trebuie să dezactivezi Secure Boot și/sau TPM în BIOS. Trebuie să le dezactivezi ca să poți instala Omarchy. Sunt scheme de securitate Microsoft destinate Windows și distribuțiilor Linux afiliate Microsoft._

Apoi răspunde la întrebările de configurare și confirmă-le așa:

 ![install-config](images/install-config.webp)

Apoi selectează o unitate pentru instalare, așază-te comod și urmărește spectacolul instalării. Se poate termina în mai puțin de un minut pe cele mai rapide mașini moderne, dar n-ar trebui să dureze mai mult de 5 minute nici măcar pe un calculator mai vechi.

 ![install-done](images/install-done.webp)

Acum ești gata de Omarchy!

### Folosește o tastatură cu fir sau de 2,4 ghz!

Criptarea completă a discului nu-ți va permite să introduci parola de pe o tastatură Bluetooth la pornire. La fel cum nu poți folosi o tastatură Bluetooth ca să intri în BIOS pe un PC. Vei avea nevoie de o tastatură care folosește fie un dongle de 2,4 ghz, fie un cablu (care oricum e mult mai plăcut pentru latență!). Personal, ador [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Instalarea pentru alt proprietar

Dacă pregătești o mașină pentru altcineva — un membru al familiei, un angajat nou, un cumpărător — n-ar trebui să răspunzi la întrebările personale în locul aceluia. Apasă `Ctrl + C` chiar pe primul ecran al programului de instalare (selectarea tastaturii) și Omarchy va oferi să pregătească mașina pentru alt proprietar. Sistemul se instalează imediat, dar toată configurarea personală — aranjarea tastaturii, numele de utilizator, parola — este amânată până la prima pornire a mașinii. Unitatea rămâne criptată implicit, iar parola pe care noul proprietar o alege la acea primă pornire devine și parola de criptare. (O mașină pe care ai folosit-o deja poate fi predată și fără reinstalare — vezi [resetarea calculatorului](48-security.md).)

### Instalări nesupravegheate

ISO-ul se poate instala și complet singur — fără tastatură, fără asistent — atunci când primește configurația pe o a doua unitate. Așa tratezi Omarchy ca imagine de bază pentru mașini virtuale și flote de mașini. Vezi [instalările nesupravegheate](51-unattended-installs.md).

### Instalări fără criptare

Omarchy se instalează implicit cu criptare. Este alegerea sigură și responsabilă pentru orice calculator care poate fi pierdut sau furat. Nu vrei ca oricine are acces la hardware-ul tău să-ți poată obține datele!

Dar, în circumstanțe speciale, cum ar fi instalările Omarchy la distanță pe calculatoare protejate sau instalările de unică folosință, fără date sensibile, poate vrei să instalezi fără criptare. Poți apăsa `Ctrl + C` la confirmarea formatării discului ca să treci la o instalare fără criptare.

### Limba

Omarchy vorbește 50 de limbi — același set ca omarchy.org — iar engleza este limba implicită. Ca să o schimbi, deschide meniul Omarchy și mergi la _Configurare > Limbă_ sau rulează `omarchy language <code>` într-un terminal (`omarchy language list` arată codurile). Meniul, desktopul și notificările proprii ale Omarchy își schimbă limba imediat, iar setarea regională a sistemului este setată corespunzător, astfel încât celelalte aplicații urmează la următoarea autentificare.

### Ajutor dacă te-ai blocat

Dacă te-ai blocat, de obicei găsești pe cineva dispus să te ajute pe canalul _#omarchy-help_ de pe [Discordul comunității](https://omarchy.org/discord).
