# Flutter Chat Application

Um aplicativo de troca de mensagens simples (texto, imagem e áudio), tendo como backend o Firebase!

<img src="https://i.imgur.com/oFO1w9D.jpg" width="35%" height="35%"> <img src="https://i.imgur.com/TSdJKgz.jpg" width="35%" height="35%">

##### Funcionalidades já existentes

- É possível criar uma conta e logar-se com ela.
- Enviar pedido de amizade para usuários cadastrados (utilizando email como id único).
- Acessar a galeria para trocar sua imagem de perfil fazendo upload para o Firebase Storage.
- Enviar mensagem para seus amigos previamente adicionados (Texto, Imagem e Áudio).
- As mensagens enviadas podem ser, apagadas, editadas (textos) e futuramente respondidas.
- Quando as mensagens são abertas são marcadas como lidas para o usuário que as enviou.
- Na tela inicial mostra a ultima mensagen recebida, com um contador para as novas mensagens.
- Também na tela inicial, quando a mensagem enviada é vista, atualiza a cor do check para verde.
- Os usuários recebem notificações de pedidos de amizade, solicitação aceita e novas mensagens.
- Adicionado um ícone launcher e para as notificações! Créditos 
- Opções de login com email e senha, futuramente com Google e Facebook.
- Tela de login e de cadastro com uma imagem e uma simples animação de movimento.

##### Próximas funcionalidades a serem implementadas

- [ ] Envio de mensagem de áudio (com confirmação de escuta)!
- [ ] Conversas em grupos.

##### Serviços Firebase utilizados

* [firebase_auth](https://pub.dev/packages/firebase_auth) - para cadastro de usuários, por email e senha, Google e Facebook.
* [firebase_database](https://pub.dev/packages/firebase_database) - para guardar dados de usuário, mensagens e solicitações de amizade.
* [firebase_storage](https://pub.dev/packages/firebase_storage) - para salvar imagem de usuário, imagens ou áudios enviados nas conversas.
* [firebase_messaging](https://pub.dev/packages/firebase_messaging) - para o envio de notificações para os usuários.
* Firebase Cloud Functions - para criar gatilhos no banco de dados para disparar novas notificações.

##### O projeto também conta com

* [image_picker](https://pub.dev/packages/image_picker) - para capturar imagens da galeria ou camera.
* [image_crop](https://pub.dev/packages/image_crop) - para recortar imagens enviadas no chat e de perfil.
* [google_fonts](https://pub.dev/packages/google_fonts) - para importar fontes Google para o projeto.
* [flutter_speed_dial](https://pub.dev/packages/flutter_speed_dial) - para o menu da tela inicial estilo FloatingActionButtons.
* [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) - para estilizar as notificações recebidas pelo Firebase Messaging.
* [intl](https://pub.dev/packages/intl) - para formatação das datas de envio de mensagens no app.
* [shared_preferences](https://pub.dev/packages/shared_preferences) - para salvar dados do usuário logado localmente.
* [flutter_modular](https://pub.dev/packages/flutter_modular) - para organização do projeto e controle de estado com [Mobx](https://pub.dev/packages/mobx)! 

##### Imagens utilizadas no projeto

* Imagem da tela de login por [Freepik](https://www.flaticon.com/packs/friendship-2).
* Imagem da tela de cadastro por [Linector](https://www.flaticon.com/packs/online-insurance-1).
* Imagem utilizada no icone do app e nas notificações por [Freepik](https://www.flaticon.com/packs/online-marketplace-15).

