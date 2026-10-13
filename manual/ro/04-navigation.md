# Navigarea

Totul în Omarchy se întâmplă prin tastatură — _TOTUL!_ Când sistemul pornește prima dată, literalmente nu poți face nimic doar cu mouse-ul. Dar poți apăsa `Super + Space` ca să afișezi meniul Omarchy și de aici poți face aproape orice.

Dar meniul Omarchy nici măcar nu este gândit să fie modul principal de operare a sistemului în cea mai mare parte a timpului. Putem fi mai rapizi decât atât! Toate aplicațiile cele mai importante sunt legate direct de scurtături individuale. Pornești terminalul cu `Super + Return` și un browser cu `Super + Shift + Return`. Încearcă să le faci una după alta și vei vedea magia mozaicului Hyprland în acțiune:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Poți apoi apăsa `Super + J` ca să le stivuiești una peste alta în loc de alăturate:

 ![navigation-stacked](images/navigation-stacked.webp)

Apasă din nou `Super + J` ca să le readuci în pozițiile alăturate. Apoi încearcă `Super + Shift + Arrow Right` cât ești pe browser, ca să schimbi ferestrele între ele.

Acum încearcă `Super + Ctrl + T` ca să pornești monitorul de activitate. Acesta va apărea ca o fereastră plutitoare. O poți pune în mozaic folosind `Super + T` (și apeși din nou ca să o faci iar plutitoare). Acum apasă `Super + Shift + F` ca să deschizi managerul de fișiere. Vei avea un aranjament frumos în patru:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Navighezi între fereastra pe care vrei să o faci activă cu `Super + Arrow`. Aceasta va schimba focalizarea și va muta cursorul în centrul aplicației noi.

Dacă apeși `Super + Shift + 2`, vei muta aplicația focalizată acum pe al doilea spațiu de lucru. `Super + Shift + 1` o mută înapoi. (Iar `Super + Shift + Alt + 2` va muta aplicația focalizată acum pe al doilea spațiu de lucru fără să treci la el).

Dacă ții apăsat `Super` și folosești mouse-ul ca să faci clic pe o fereastră, vei putea rearanja unde stă. Dacă ții apăsat `Super` și folosești butonul drept al mouse-ului, poți redimensiona liber fereastra.

Închizi o fereastră cu `Super + W` sau `Super + Q` (și închizi toate ferestrele cu `Ctrl + Alt + Delete`).

Poți trece și la ecran complet cu `Super + F` sau chiar doar la lățime completă (păstrând bara de sus) cu `Super + Alt + F` sau la ecran complet în interiorul unei ferestre cu `Super + Ctrl + F` (bun pentru YouTube!).

### Aranjarea mozaic vs defilantă

Aranjarea implicită a Omarchy se numește dwindle. Păstrează vizibile tot timpul toate ferestrele pe care le deschizi pe un singur spațiu de lucru, chiar dacă trebuie să le micșoreze.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Dar poți alege și să transformi un spațiu de lucru în aranjarea defilantă, în care ferestrele sunt înșirate una lângă alta, dincolo de marginea vizibilă a ecranului. Transformi un singur spațiu de lucru în această aranjare prin `Super + L`.

Apăsarea din nou a `Super + L` face spațiul de lucru plutitor, în care ferestrele se suprapun liber și le așezi tu, iar o a treia apăsare îl readuce la dwindle. `Super + Alt + L` trece prin ele în sens invers. O fereastră care plutește oricum — una pe care ai scos-o cu `Super + T` sau o aplicație care se deschide întotdeauna plutitoare — continuă să plutească atunci când spațiul de lucru revine la mozaic. Bara de sus marchează spațiul de lucru pe care te afli cu aranjarea lui: un pătrat pentru dwindle, un cerc pentru defilant și un triunghi pentru plutitor. Clicul pe acel semn parcurge și el aranjările.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Alegerea este per spațiu de lucru și se păstrează. Astfel, poți păstra spațiul de lucru 1 pe dwindle pentru navigare și spațiul de lucru 2 pe defilant pentru cod, și vor reveni așa după o repornire.

Dacă vrei să folosești aranjarea defilantă ca implicită, poți seta asta în `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Spații de lucru plutitoare

Un spațiu de lucru plutitor funcționează ca un desktop tradițional: ferestrele se suprapun, iar tu le muți și le dimensionezi singur. Fiecare fereastră primește o bară de titlu în culorile temei tale, cu butoane pentru minimizare, maximizare și închidere. `Super + M` minimizează și fereastra focalizată. O fereastră minimizată așteaptă în dock; fă clic pe aplicația ei ca să o readuci. Fă clic pe o fereastră ca să o aduci în față. Redimensioneaz-o din orice margine sau colț. Fă dublu clic pe o bară de titlu ca să maximizezi fereastra păstrând bara de sus în vedere și din nou ca să-i recapeti vechea dimensiune.

Un spațiu de lucru plutitor afișează și un dock, cu aplicațiile tale fixate, tot ce rulează și o grilă cu toate aplicațiile în spatele butonului de aplicații, pe care îl deschid și `Super + Alt + Space` și _Apps_ în meniul Omarchy. Fă clic dreapta pe o aplicație din grilă sau apasă `Delete` ca să o dezinstalezi. Fă clic pe o aplicație ca să o deschizi sau ca să-i aduci fereastra în față; fă clic din nou ca să parcurgi ferestrele ei. Clicul mijlociu deschide o fereastră nouă. Trage o pictogramă de-a lungul dockului ca să o muți; tragerea unei aplicații care rulează printre celelalte o păstrează acolo. Fă clic dreapta ca să păstrezi o aplicație în dock, să o scoți sau să o închizi. Dockul se dă din calea unei ferestre pe tot ecranul. Fă clic dreapta pe butonul de aplicații ca să muți dockul pe altă margine sau ca să-l faci să se ascundă până când indicatorul ajunge la marginea lui. Poziția se află și sub _Declanșator > Aspect > Dock > Poziție dock_, iar `omarchy dock position left` și `omarchy dock autohide on` le setează pe ambele dintr-un terminal. Aplicațiile pe care le păstrezi în dock sunt estompate cât timp nu rulează.

Spațiile de lucru noi și orice spațiu căruia nu i-ai dat o aranjare proprie cu `Super + L` folosesc aranjarea implicită. Schimbarea valorii implicite resetează la ea fiecare spațiu de lucru fără ferestre, în timp ce unul cu ferestre pe el păstrează aranjarea pe care o are. Alege-o sub _Declanșator > Aspect > Aranjare spații_: Mozaic, Defilant sau Plutitor. `omarchy-hyprland-workspace-layout-default scrolling` o setează dintr-un terminal.

### Gruparea ferestrelor

Ferestrele pot fi grupate folosind `Super + G`. Odată ce ești într-un grup, fiecare fereastră pe care o pornești cât timp acesta este activ va aparține grupului. Te poți deplasa între aceste ferestre grupate folosind `Super + Ctrl + Arrow Left/Right` sau `Super + Alt + 1/2/3/4` ca să mergi direct la fereastra grupată în ordine.

Poți muta o fereastră afară din grupare cu `Super + Alt + G` sau poți desființa întregul grup apăsând din nou `Super + G`. În final, poți muta ferestre din afara grupului în el cu `Super + Alt + Arrows`.

### Ferestre desprinse

Poți desprinde o fereastră din alocarea spațiului ei de lucru cu `Super + O`. Asta o va fixa ca fereastră plutitoare care te urmărește pe orice spațiu de lucru mergi. Excelent pentru playere video și altele similare.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Spațiul de lucru scratchpad

În final, există un spațiu de lucru scratchpad special care coboară peste orice spațiu de lucru pe care te afli, cam ca o consolă Quake. Comută-l cu `Super + Grave` sau `Super + S` și pune o fereastră acolo folosind `Super + Shift + Grave` sau `Super + Alt + S`.

Funcționează deosebit de bine pentru un terminal care rulează un agent sau pentru comenzi cu care vrei să interacționezi rapid fără să părăsești spațiul de lucru curent. Ca să muți o fereastră de pe scratchpad, trimite-o direct pe alt spațiu de lucru cu ceva de genul `Super + Shift + 1`.

Cât timp scratchpadul ține o singură fereastră, coboară ca un panou centrat, în loc să acopere ecranul. Pune o a doua aplicație pe el și revine la lățimea completă, astfel încât cele două să aibă loc să stea alăturate.

### Durează puțin până te obișnuiești!

Durează puțin până te obișnuiești să navighezi pe desktop așa, dar, odată ce o faci, va fi greu să te întorci la o experiență desktop tradițională, condusă de mouse!
