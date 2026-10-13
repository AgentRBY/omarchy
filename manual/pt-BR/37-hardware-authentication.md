# Autenticação por hardware

### Autenticação por impressão digital

Muitos notebooks vêm com um sensor de impressão digital para autenticação. Você pode usá-lo com o Omarchy executando _Configuração > Segurança > Impressão digital_ no menu do Omarchy (`Super + Space`).

Isso vai instalar o pacote de impressão digital, coletar sua digital, verificá-la, e você estará pronto para usar sua impressão digital para desbloquear na tela de bloqueio (que você pode acionar com `Super + Ctrl + L`), entrar no modo sudo e autorizar solicitações do sistema.

Quando a tampa do seu notebook está fechada, a solicitação de impressão digital é pulada automaticamente, então você vai direto para a solicitação de senha em vez de esperar por um sensor que você não consegue alcançar. Se, por outro lado, você precisar trabalhar em um teclado externo que não tem sensor, é só pressionar `CTRL + C` quando sua impressão digital for solicitada durante o `sudo`.

Você pode remover a autenticação por impressão digital em _Remover > Segurança > Impressão digital_ no menu do Omarchy.

### Autenticação Fido2

Se você usa um dispositivo Fido2, pode configurá-lo para autenticação do `sudo` em _Configuração > Segurança > Fido2_ no menu do Omarchy (`Super + Space`). Ele cobre o `sudo` e as solicitações de autorização do sistema, mas não o desbloqueio do computador.

Você pode remover a autenticação fido2 em _Remover > Segurança > Fido2_ no menu do Omarchy.
