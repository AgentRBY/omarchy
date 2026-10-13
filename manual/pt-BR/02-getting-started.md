# Primeiros passos

O Omarchy é instalado usando uma ISO. Você pode escolher entre uma instalação em disco inteiro, que toma conta da unidade inteira, ou uma instalação em espaço livre, que coloca o Omarchy no espaço não alocado de uma unidade — é assim que você faz dual boot ao lado do Windows ou de outro sistema operacional (veja [instalação com dual boot](50-dual-boot-install.md) — note que você precisará desativar o BitLocker no Windows primeiro). De qualquer forma, a instalação usa criptografia completa por padrão, e a opção de disco inteiro apagará a unidade selecionada, então faça um backup antes de usar uma unidade existente!

[Baixe a ISO do Omarchy](https://omarchy.org/) primeiro, coloque-a em um pendrive (use o [balenaEtcher](https://etcher.balena.io/) no Mac/Windows ou o [caligula](https://github.com/ifd3f/caligula) no Linux) e inicialize a partir do pendrive.

_Você precisa desativar o Secure Boot e/ou o TPM na BIOS. Você precisa desativar isso para conseguir instalar o Omarchy. São esquemas de segurança da Microsoft pensados para o Windows e para distribuições Linux afiliadas à Microsoft._

Depois responda às perguntas de configuração e confirme-as assim:

 ![install-config](images/install-config.webp)

Depois selecione uma unidade para a sua instalação, relaxe e assista ao show da instalação acontecer. Pode terminar em menos de um minuto nas máquinas modernas mais rápidas, mas não deve levar mais de 5 minutos nem em um computador mais antigo.

 ![install-done](images/install-done.webp)

Agora você está pronto para o Omarchy!

### Use um teclado com fio ou de 2,4 GHz!

A criptografia de disco inteiro não permitirá que você digite a senha a partir de um teclado Bluetooth na inicialização. Assim como você não pode usar um teclado Bluetooth para entrar na BIOS de um PC. Você precisará de um teclado que use um dongle de 2,4 GHz ou um cabo (o que é muito melhor para a latência, de qualquer forma!). Pessoalmente, eu adoro o [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Instalando para outro proprietário

Se você está configurando uma máquina para outra pessoa — um familiar, um novo funcionário, um comprador — você não deve responder às perguntas pessoais em nome dela. Pressione `Ctrl + C` na primeira tela do instalador (a seleção de teclado), e o Omarchy oferecerá preparar a máquina para outro proprietário. O sistema instala imediatamente, mas toda a configuração pessoal — layout do teclado, nome de usuário, senha — é adiada até a máquina inicializar pela primeira vez. A unidade continua criptografada por padrão, e a senha que o novo proprietário escolher nessa primeira inicialização também se torna a senha de criptografia. (Uma máquina que você já vinha usando também pode ser entregue sem reinstalar — veja [redefinindo o computador](48-security.md).)

### Instalações não assistidas

A ISO também pode instalar completamente sozinha — sem teclado, sem assistente — quando recebe sua configuração em uma segunda unidade. Essa é a maneira de tratar o Omarchy como uma imagem base para VMs e máquinas de uma frota. Veja [instalações não assistidas](51-unattended-installs.md).

### Instalações sem criptografia

O Omarchy é instalado com criptografia por padrão. É a escolha segura e responsável para qualquer computador que possa ser perdido ou roubado. Você não quer que qualquer pessoa com acesso ao seu hardware consiga obter seus dados!

Mas em circunstâncias especiais, como instalações remotas do Omarchy em computadores protegidos ou instalações descartáveis sem dados sensíveis, você pode querer instalar sem criptografia. Você pode pressionar `Ctrl + C` na confirmação de formatação do disco para mudar para uma instalação sem criptografia.

### Idioma

O Omarchy fala 50 idiomas — o mesmo conjunto do omarchy.org — e o inglês é o padrão. Para mudar, abra o menu do Omarchy e vá em _Configuração > Idioma_, ou execute `omarchy language <code>` em um terminal (`omarchy language list` mostra os códigos). O menu, o desktop e as notificações do próprio Omarchy mudam de idioma imediatamente, e o locale do sistema é definido para acompanhar, então seus outros aplicativos seguirão na próxima vez que você fizer login.

### Ajuda se você ficar travado

Se você ficar travado, geralmente é possível encontrar alguém disposto a ajudar no canal _#omarchy-help_ no [Discord da comunidade](https://omarchy.org/discord).
