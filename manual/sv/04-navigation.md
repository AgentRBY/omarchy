# Navigering

Allt i Omarchy sker via tangentbordet — _ALLTING!_ När systemet först startar kan du bokstavligen inte göra någonting med enbart musen. Men du kan trycka på `Super + Space` för att visa Omarchy-menyn och härifrån kan du göra i stort sett allt.

Men Omarchy-menyn är inte ens avsedd att vara det huvudsakliga sättet att använda systemet för det mesta. Vi kan bli snabbare än så! Alla de viktigaste applikationerna är bundna direkt till individuella snabbtangenter. Du startar terminalen med `Super + Return` och en webbläsare med `Super + Shift + Return`. Prova att göra det ena efter det andra, så ser du magin i Hyprlands kakling i aktion:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Du kan sedan trycka på `Super + J` för att stapla dem ovanpå varandra i stället för sida vid sida:

 ![navigation-stacked](images/navigation-stacked.webp)

Tryck på `Super + J` igen för att återställa dem till sina positioner sida vid sida. Prova sedan `Super + Shift + Arrow Right` medan du är i webbläsaren för att växla fönstren.

Prova nu `Super + Ctrl + T` för att starta aktivitetsmonitorn. Den visas som ett flytande fönster. Du kan kakla det med `Super + T` (och trycka på det igen för att göra det flytande igen). Tryck nu på `Super + Shift + F` för att öppna filhanteraren. Du får en snygg fyrvägskonfiguration:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Du navigerar mellan fönstret du vill ska vara aktivt med `Super + Arrow`. Det växlar fokus och flyttar markören till mitten av den nya applikationen.

Om du trycker på `Super + Shift + 2` flyttar du den för närvarande fokuserade applikationen till den andra arbetsytan. `Super + Shift + 1` flyttar den tillbaka. (Och `Super + Shift + Alt + 2` flyttar den för närvarande fokuserade applikationen till den andra arbetsytan utan att växla till den).

Om du håller ned `Super` och använder musen för att klicka på ett fönster kan du arrangera om var det sitter. Om du håller ned `Super` och använder höger musknapp kan du fritt ändra storlek på fönstret.

Du stänger ett fönster med `Super + W` eller `Super + Q` (och stänger alla fönster med `Ctrl + Alt + Delete`).

Du kan också gå helskärm med `Super + F` eller till och med bara helbredd (med menyfältet kvar) med `Super + Alt + F` eller helskärm inuti ett fönster med `Super + Ctrl + F` (bra för YouTube!).

### Dwindle kontra rullande layout

Omarchys standardlayout kallas dwindle. Den håller alla fönster du öppnar på en enda arbetsyta synliga hela tiden, även om den måste krympa ner dem.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Men du kan också välja att förvandla en arbetsyta till den rullande layouten där fönster ställs upp sida vid sida, bortom skärmens synliga kant. Du förvandlar en enskild arbetsyta till den här layouten via `Super + L`.

Att trycka på `Super + L` igen gör arbetsytan flytande, där fönster överlappar fritt och du placerar dem själv, och ett tredje tryck återställer den till dwindle. `Super + Alt + L` går igenom dem åt andra hållet. Ett fönster som ändå flyter — ett du poppade ut med `Super + T`, eller en app som alltid öppnas flytande — fortsätter att flyta när arbetsytan går tillbaka till kakling. Menyfältet markerar arbetsytan du är på med dess layout: en kvadrat för dwindle, en cirkel för rullning och en triangel för flytande. Att klicka på det märket cykelkör också layouten.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

Valet gäller per arbetsyta, och det fastnar. Så du kan hålla arbetsyta 1 på dwindle för surfning och arbetsyta 2 på rullning för kod, och de kommer tillbaka så efter en omstart.

Om du vill använda den rullande layouten som standard kan du ställa in det i `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Flytande arbetsytor

En flytande arbetsyta fungerar som ett traditionellt skrivbord: fönster överlappar, och du flyttar och dimensionerar dem själv. Varje fönster får en titelrad i ditt temas färger, med knappar för att minimera, maximera och stänga. `Super + M` minimerar också det fokuserade fönstret. Ett minimerat fönster väntar i dockan; klicka på dess app för att ta tillbaka det. Klicka på ett fönster för att föra det framåt. Ändra storlek på det från vilken kant eller vilket hörn som helst. Dubbelklicka på en titelrad för att maximera fönstret samtidigt som menyfältet hålls i sikte, och igen för att få tillbaka dess gamla storlek.

En flytande arbetsyta visar också en docka, med dina fästa appar, allt som körs och ett rutnät över varje app bakom appknappen, vilket `Super + Alt + Space` och _Apps_ i Omarchy-menyn också öppnar. Högerklicka på en app i rutnätet, eller tryck på `Delete`, för att avinstallera den. Klicka på en app för att öppna den, eller för att föra dess fönster framåt; klicka igen för att cykla genom dess fönster. Mittenklick öppnar ett nytt fönster. Dra en ikon längs dockan för att flytta den; att dra en körande app bland de andra håller kvar den där. Högerklicka för att hålla kvar en app i dockan, ta bort den eller avsluta den. Dockan flyttar sig ur vägen för ett helskärmsfönster. Högerklicka på appknappen för att flytta dockan till en annan kant eller låta den döljas tills pekaren når dess kant. Positionen finns också under _Trigger > Appearance > Dock > Dock Position_, och `omarchy dock position left` och `omarchy dock autohide on` ställer in båda från en terminal. Appar du håller kvar i dockan är bleknade medan de inte körs.

Nya arbetsytor, och alla du inte har gett en egen layout med `Super + L`, använder standardlayouten. Att ändra standard återställer varje arbetsyta utan fönster till den, medan en med fönster på behåller layouten den har. Välj den under _Trigger > Appearance > Workspace Layout_: Tiling, Scrolling eller Floating. `omarchy-hyprland-workspace-layout-default scrolling` ställer in den från en terminal.

### Gruppera fönster

Fönster kan grupperas med `Super + G`. När du väl är i en grupp kommer varje fönster du startar medan den är aktiv att tillhöra gruppen. Du kan flytta mellan dessa grupperade fönster med `Super + Ctrl + Arrow Left/Right` eller `Super + Alt + 1/2/3/4` för att gå direkt till grupperat fönster i ordning.

Du kan flytta ett fönster ut ur grupperingen med `Super + Alt + G` eller demontera hela gruppen genom att trycka på `Super + G` igen. Slutligen kan du flytta fönster utanför gruppen in i den med `Super + Alt + Arrows`.

### Poppa fönster

Du kan poppa ett fönster ut ur dess arbetsyteallokering med `Super + O`. Det fäster det som ett flytande fönster som följer dig på vilken arbetsyta du än går till. Perfekt för videospelare och liknande.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Scratchpad-arbetsyta

Slutligen finns det en speciell scratchpad-arbetsyta som faller ner över vilken arbetsyta du än befinner dig på, ungefär som en Quake-konsol. Växla den med `Super + Grave` eller `Super + S`, och placera ett fönster där med `Super + Shift + Grave` eller `Super + Alt + S`.

Den fungerar särskilt bra för en terminal som kör en agent, eller för kontroller du vill interagera med snabbt utan att lämna den aktuella arbetsytan. För att flytta ett fönster från scratchpaden, skicka det direkt till en annan arbetsyta med något som `Super + Shift + 1`.

Medan scratchpaden innehåller ett enda fönster faller den ner som en centrerad panel snarare än att spänna över skärmen. Lägg en andra app på den och den går tillbaka till full bredd, så att de två har plats att sitta sida vid sida.

### Det tar lite tid att vänja sig!

Det tar ett tag att vänja sig vid att navigera på skrivbordet så här, men när du väl gör det blir det svårt att gå tillbaka till en traditionell musdriven skrivbordsupplevelse!
