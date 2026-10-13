# Primeiros passos

O Omarchy instala-se a partir de uma imagem ISO. Podes escolher entre uma instalação no disco inteiro, que ocupa todo o disco, ou uma instalação no espaço livre, que coloca o Omarchy no espaço não alocado de um disco — é assim que fazes dual boot com o Windows ou outro sistema operativo (vê [instalação em dual boot](50-dual-boot-install.md) — repara que primeiro tens de desativar o BitLocker no Windows). Em qualquer dos casos, a instalação usa por predefinição encriptação completa, e a opção de disco inteiro vai apagar o disco selecionado, por isso faz uma cópia de segurança antes de reutilizares um disco existente!

[Transfere a imagem ISO do Omarchy](https://omarchy.org/) primeiro, coloca-a numa pen USB (usa o [balenaEtcher](https://etcher.balena.io/) no Mac/Windows ou o [caligula](https://github.com/ifd3f/caligula) no Linux) e arranca a partir da pen.

_Tens de desativar o Secure Boot e/ou o TPM na BIOS. Tens de os desativar para conseguires instalar o Omarchy. São esquemas de segurança da Microsoft pensados para o Windows e para distribuições Linux afiliadas à Microsoft._

Depois responde às perguntas de configuração e confirma-as assim:

 ![install-config](images/install-config.webp)

Depois seleciona um disco para a instalação, recosta-te e vê o espetáculo da instalação. Nas máquinas modernas mais rápidas pode ficar pronta em menos de um minuto, mas nem num computador mais antigo deve demorar mais de 5 minutos.

 ![install-done](images/install-done.webp)

Agora estás pronto para o Omarchy!

### Usa um teclado com fios ou de 2,4 GHz!

A encriptação completa do disco não te deixa introduzir a palavra-passe a partir de um teclado Bluetooth no arranque. Tal como não consegues usar um teclado Bluetooth para entrar na BIOS num PC. Vais precisar de um teclado que use um recetor de 2,4 GHz ou um cabo (o que é muito melhor para a latência, de qualquer forma!). Pessoalmente adoro o [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Instalar para outro dono

Se estás a preparar uma máquina para outra pessoa — um familiar, um novo funcionário, um comprador — não deves responder por ela às perguntas pessoais. Prime `Ctrl + C` logo no primeiro ecrã do instalador (a seleção do teclado) e o Omarchy oferece-se para preparar a máquina para outro dono. O sistema instala-se de imediato, mas toda a configuração pessoal — disposição do teclado, nome de utilizador, palavra-passe — fica adiada até à primeira vez que a máquina arrancar. O disco continua encriptado por predefinição, e a palavra-passe que o novo dono escolher nesse primeiro arranque passa a ser também a palavra-passe de encriptação. (Uma máquina que já tenhas estado a utilizar também pode ser entregue sem reinstalação — vê [repor o computador](48-security.md).)

### Instalações autónomas

A imagem ISO também consegue instalar-se completamente sozinha — sem teclado, sem assistente — quando recebe a sua configuração num segundo disco. É essa a forma de tratar o Omarchy como uma imagem de base para máquinas virtuais e parques de máquinas. Vê [instalações autónomas](51-unattended-installs.md).

### Instalações sem encriptação

O Omarchy instala-se com encriptação por predefinição. É a escolha segura e responsável para qualquer computador que possa possivelmente perder-se ou ser roubado. Não queres que qualquer pessoa com acesso ao teu hardware consiga aceder aos teus dados!

Mas em circunstâncias especiais, como instalações remotas do Omarchy em computadores protegidos ou instalações descartáveis sem dados sensíveis, podes querer instalar sem encriptação. Podes premir `Ctrl + C` na confirmação da formatação do disco para passar para uma instalação sem encriptação.

### Idioma

O Omarchy fala 50 línguas — o mesmo conjunto do omarchy.org — e o inglês é a predefinição. Para mudar, abre o menu do Omarchy e vai a _Configurar > Idioma_, ou executa `omarchy language <código>` num terminal (`omarchy language list` mostra os códigos). O menu, o ambiente de trabalho e as notificações do próprio Omarchy mudam de língua de imediato, e a localização do sistema é ajustada para corresponder, de forma que as tuas outras aplicações acompanhem na próxima vez que iniciares sessão.

### Ajuda se ficares preso

Se ficares preso, costuma haver sempre alguém disposto a ajudar no canal _#omarchy-help_ no [Discord da comunidade](https://omarchy.org/discord).
