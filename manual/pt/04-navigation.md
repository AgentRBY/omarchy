# Navegação

Tudo no Omarchy acontece através do teclado — _TUDO!_ Quando o sistema arranca pela primeira vez, literalmente não consegues fazer nada só com o rato. Mas podes premir `Super + Space` para revelar o menu do Omarchy e a partir daí fazeres praticamente tudo.

Mas o menu do Omarchy nem sequer se destina a ser a principal forma de operar o sistema, a maior parte do tempo. Conseguimos fazer mais depressa do que isso! Todas as aplicações mais importantes estão ligadas diretamente a atalhos individuais. Arrancas o terminal com `Super + Return` e um browser com `Super + Shift + Return`. Experimenta fazer uma coisa a seguir à outra e vais ver a magia do mosaico do Hyprland em ação:

 ![navigation-browser-terminal](images/navigation-browser-terminal.webp)

Depois podes premir `Super + J` para os empilhares um por cima do outro, em vez de lado a lado:

 ![navigation-stacked](images/navigation-stacked.webp)

Prime `Super + J` outra vez para os devolveres às posições lado a lado. Depois experimenta `Super + Shift + Arrow Right` estando no browser para trocares as janelas.

Agora experimenta `Super + Ctrl + T` para arrancar o monitor de Atividade. Isso vai aparecer como uma janela flutuante. Podes colocá-la em mosaico com `Super + T` (e premir outra vez para a tornares flutuante de novo). Agora prime `Super + Shift + F` para abrir o gestor de ficheiros. Vais ficar com um arranjo de quatro vias muito arrumadinho:

 ![navigation-fourway-tiling](images/navigation-fourway-tiling.webp)

Navegas entre as janelas para escolheres qual está ativa com `Super + Arrow`. Isso muda o foco e move o cursor para o centro da nova aplicação.

Se premires `Super + Shift + 2`, moves a aplicação atualmente em foco para o segundo espaço de trabalho. `Super + Shift + 1` traz-la de volta. (E `Super + Shift + Alt + 2` move a aplicação atualmente em foco para o segundo espaço de trabalho sem mudares para ele).

Se segurares `Super` e usares o rato para clicares numa janela, consegues reorganizar onde ela fica. Se segurares `Super` e usares o botão direito do rato, consegues redimensionar livremente a janela.

Fechas uma janela com `Super + W` ou `Super + Q` (e fechas todas as janelas com `Ctrl + Alt + Delete`).

Também podes ir para ecrã inteiro com `Super + F`, ou apenas para largura total (mantendo a barra superior) com `Super + Alt + F`, ou para ecrã inteiro dentro de uma janela com `Super + Ctrl + F` (ótimo para o YouTube!).

### Disposição dwindle vs. deslizante

A disposição predefinida do Omarchy chama-se dwindle. Mantém todas as janelas que abres num único espaço de trabalho visíveis em permanência, mesmo que tenha de as encolher.

 ![navigation-dwindle-layout](images/navigation-dwindle-layout.webp)

Mas também podes optar por transformar um espaço de trabalho na disposição deslizante, em que as janelas ficam alinhadas lado a lado, para além do bordo visível do ecrã. Transformas um único espaço de trabalho nesta disposição com `Super + L`.

Premir `Super + L` outra vez torna o espaço de trabalho flutuante, em que as janelas se sobrepõem livremente e és tu que as colocas, e um terceiro toque devolve-o ao dwindle. `Super + Alt + L` percorre-as na ordem inversa. Uma janela que flutue de qualquer maneira — uma que tenhas soltado com `Super + T`, ou uma aplicação que abra sempre flutuante — continua a flutuar quando o espaço de trabalho volta ao mosaico. A barra superior marca o espaço de trabalho em que estás com a sua disposição: um quadrado para dwindle, um círculo para deslizante e um triângulo para flutuante. Clicar nessa marca também percorre a disposição.

 ![navigation-scrolling-layout](images/navigation-scrolling-layout.webp)

A escolha é por espaço de trabalho e fica guardada. Por isso podes manter o espaço de trabalho 1 em dwindle para navegar e o espaço de trabalho 2 em deslizante para código, e eles voltam assim depois de um reinício.

Se quiseres usar a disposição deslizante como predefinição, podes defini-la em `~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  general = {
    layout = "scrolling",
  },
})
```

### Espaços de trabalho flutuantes

Um espaço de trabalho flutuante funciona como um ambiente de trabalho tradicional: as janelas sobrepõem-se e és tu que as moves e dimensionas. Cada janela ganha uma barra de título nas cores do teu tema, com botões para minimizar, maximizar e fechar. `Super + M` também minimiza a janela em foco. Uma janela minimizada espera no dock; clica na sua aplicação para a trazeres de volta. Clica numa janela para a trazeres para a frente. Redimensiona-a a partir de qualquer bordo ou canto. Faz duplo clique numa barra de título para maximizares a janela mantendo a barra superior à vista, e outra vez para recuperares o tamanho antigo.

Um espaço de trabalho flutuante também mostra um dock, com as tuas aplicações fixadas, tudo o que está a correr, e uma grelha de todas as aplicações atrás do botão de aplicações, que `Super + Alt + Space` e _Aplicações_ no menu do Omarchy também abrem. Clica com o botão direito numa aplicação da grelha, ou prime `Delete`, para a desinstalares. Clica numa aplicação para a abrires, ou para trazeres a sua janela para a frente; clica outra vez para percorreres as suas janelas. O botão do meio abre uma nova janela. Arrasta um ícone ao longo do dock para o moveres; arrastar uma aplicação em execução para entre as outras mantém-na ali. Clica com o botão direito para manteres uma aplicação no dock, retirá-la ou terminá-la. O dock sai do caminho de uma janela em ecrã inteiro. Clica com o botão direito no botão de aplicações para moveres o dock para outro bordo ou para ficares com ele oculto até o ponteiro chegar ao seu bordo. A posição também está em _Acionar > Aspeto > Dock > Posição do dock_, e `omarchy dock position left` e `omarchy dock autohide on` definem as duas coisas a partir de um terminal. As aplicações que manténs no dock ficam esbatidas enquanto não estão a correr.

Os novos espaços de trabalho, e quaisquer outros a que não tenhas dado uma disposição própria com `Super + L`, usam a disposição predefinida. Mudar a predefinição repõe nela todos os espaços de trabalho sem janelas, enquanto um com janelas mantém a disposição que tem. Escolhe-a em _Acionar > Aspeto > Disposição_: Mosaico, Deslizante ou Flutuante. `omarchy-hyprland-workspace-layout-default scrolling` define-a a partir de um terminal.

### Agrupar janelas

As janelas podem ser agrupadas com `Super + G`. Quando estiveres num grupo, todas as janelas que arrancares enquanto ele estiver ativo pertencem ao grupo. Podes mover-te entre essas janelas agrupadas com `Super + Ctrl + Arrow Left/Right` ou com `Super + Alt + 1/2/3/4` para ires diretamente para uma janela agrupada por ordem.

Podes mover uma janela para fora do grupo com `Super + Alt + G` ou desfazer o grupo inteiro premindo `Super + G` outra vez. Por fim, podes mover janelas de fora do grupo para dentro dele com `Super + Alt + Arrows`.

### Soltar janelas

Podes soltar uma janela da sua afetação ao espaço de trabalho com `Super + O`. Isso fixa-a como uma janela flutuante que te segue para qualquer espaço de trabalho a que vás. Ótimo para leitores de vídeo e afins.

 ![navigation-popped-window](images/navigation-popped-window.webp)

### Espaço de trabalho scratchpad

Por fim, há um espaço de trabalho especial do tipo scratchpad que desce sobre qualquer espaço de trabalho em que estejas, muito ao estilo de uma consola do Quake. Alterna-o com `Super + Grave` ou `Super + S`, e coloca lá uma janela com `Super + Shift + Grave` ou `Super + Alt + S`.

Funciona especialmente bem para um terminal a correr um agente, ou para controlos com que queres interagir rapidamente sem saíres do espaço de trabalho atual. Para moveres uma janela para fora do scratchpad, envia-a diretamente para outro espaço de trabalho com algo como `Super + Shift + 1`.

Enquanto o scratchpad tiver uma única janela, desce como um painel centrado em vez de abranger o ecrã. Coloca-lhe uma segunda aplicação e ele volta à largura total, de forma que as duas tenham espaço para ficar lado a lado.

### Requer algum hábito!

Requer algum tempo até te habituares a navegar assim no teu ambiente de trabalho, mas quando te habituares, vai custar voltar a uma experiência tradicional orientada pelo rato!
