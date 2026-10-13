# Autenticação por hardware

### Autenticação por impressão digital

Muitos portáteis vêm com um sensor de impressões digitais para autenticação. Pode usá-lo com o Omarchy executando _Configurar > Segurança > Impressão digital_ no menu Omarchy (`Super + Space`).

Isso instala o pacote de impressões digitais, recolhe a sua impressão, verifica-a, e fica pronto para usar a sua impressão digital para desbloquear a partir do ecrã de bloqueio (que pode acionar com `Super + Ctrl + L`), entrar no modo sudo e autorizar pedidos do sistema.

Quando a tampa do seu portátil está fechada, o pedido de impressão digital é automaticamente ignorado, por isso vai diretamente ao pedido de palavra-passe em vez de esperar por um sensor ao qual não consegue chegar. Se, de outra forma, precisar de trabalhar num teclado externo que não tenha sensor, basta premir `CTRL + C` quando lhe for pedida a impressão digital durante o `sudo`.

Pode remover a autenticação por impressão digital em _Remover > Segurança > Impressão digital_ no menu Omarchy.

### Autenticação Fido2

Se estiver a usar um dispositivo Fido2, pode configurá-lo para autenticação `sudo` usando _Configurar > Segurança > Fido2_ no menu Omarchy (`Super + Space`). No entanto, abrange o `sudo` e os pedidos de autorização do sistema, e não o desbloqueio do seu computador.

Pode remover a autenticação fido2 em _Remover > Segurança > Fido2_ no menu Omarchy.
