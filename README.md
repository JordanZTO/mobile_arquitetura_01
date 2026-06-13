# Product App

Projeto mobile desenvolvido em Flutter para fins estudantis. A aplicacao esta sendo evoluida ao longo das aulas para praticar arquitetura, consumo de API, separacao de responsabilidades, tratamento de estado, cache simples e fluxo de autenticacao.

Atualmente o app consome a API DummyJSON para autenticar usuarios e listar produtos. Antes de acessar a listagem, o usuario precisa realizar login.

## O que o projeto contem

- Tela de login com usuario e senha.
- Validacao de campos obrigatorios.
- Autenticacao usando `POST /auth/login` da DummyJSON.
- Tratamento de erro para credenciais invalidas.
- Sessao do usuario autenticado em memoria.
- Persistencia do token com `shared_preferences`.
- Verificacao de sessao ativa ao iniciar o app.
- Listagem de produtos usando `GET /products`.
- Tela de detalhes usando `GET /products/{id}`.
- Nome e imagem do usuario autenticado no AppBar.
- Botao de logout.
- Botao para atualizar manualmente a lista de produtos.
- Separacao basica entre modelos, servicos, sessao e telas.

## Tecnologias usadas

- Flutter
- Dart
- HTTP package
- Shared Preferences
- DummyJSON API

## Estrutura principal

```text
lib/
  main.dart
  models/
    authenticated_user.dart
    product.dart
  screens/
    login_screen.dart
    splash_screen.dart
    product_list_screen.dart
    product_detail_screen.dart
  services/
    api_headers.dart
    auth_service.dart
    product_service.dart
    session_manager.dart
  widgets/
    product_card.dart
```

O projeto tambem contem uma estrutura de estudo em camadas, com pastas como `data`, `domain` e `presentation`, usada durante a evolucao das atividades.

## Credenciais para teste

Use um usuario de teste da DummyJSON:

```text
Usuario: emilys
Senha: emilyspass
```

## Recursos implementados

✅ Estrutura em camadas (data, domain, presentation)
✅ Autenticação com POST /auth/login
✅ Persistência de sessão com SharedPreferences
✅ Listagem de produtos com GET /products
✅ Detalhes do produto com GET /products/{id}
✅ Sistema de favoritos com persistência
✅ Validação de formulários
✅ Tratamento de erros
✅ Carregamento assíncrono com FutureBuilder

## Como rodar o projeto

1. Entre na pasta do projeto:

```bash
cd mobile_arquitetura_01
```

2. Instale as dependencias:

```bash
flutter pub get
```

3. Rode o app:

```bash
flutter run
```

Para rodar no navegador:

```bash
flutter run -d chrome
```

Ou usando um servidor web local:

```bash
flutter run -d web-server
```

