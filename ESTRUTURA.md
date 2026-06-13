# Estrutura do Projeto - Product Store

## Estrutura de Pastas

```
lib/
├── main.dart                              # Ponto de entrada da aplicação
├── models/
│   ├── product.dart                       # Modelo Product com fromJson/toJson
│   └── authenticated_user.dart            # Modelo de usuário autenticado
├── services/
│   ├── api_headers.dart                   # Headers customizados para requisições
│   ├── auth_service.dart                  # Serviço de autenticação com POST /auth/login
│   ├── product_service.dart               # Serviço de produtos com GET /products e cache
│   ├── favorites_service.dart             # Serviço de favoritos com SharedPreferences
│   └── session_manager.dart               # Gerenciamento de sessão e persistência de token
├── screens/
│   ├── splash_screen.dart                 # Tela inicial que verifica autenticação
│   ├── login_screen.dart                  # Tela de login com validação
│   ├── product_list_screen.dart           # Lista de produtos em grid (2 colunas)
│   └── product_detail_screen.dart         # Detalhes do produto com favorito
└── widgets/
    └── product_card.dart                  # Card reutilizável para produtos na lista
```

---

## Componentes Principais

### 1. **Modelos de Dados** (`models/`)

#### Product (`product.dart`)
- **Propriedades**: id, title, price, image, description, category, rating, brand, stock, discountPercentage, thumbnail, images
- **fromJson()**: Desserializa resposta da DummyJSON
- **toJson()**: Serializa para envio à API
- **Ajustado**: Trata rating como num ou Map (compatível com DummyJSON)

#### AuthenticatedUser (`authenticated_user.dart`)
- **Propriedades**: id, email, firstName, lastName, fullName, image, accessToken, refreshToken
- **fromJson()**: Desserializa resposta de `/auth/login`
- **toJson()**: Serializa dados do usuário
- **copyWith()**: Cria cópia com campos atualizados

---

### 2. **Serviços** (`services/`)

#### ApiHeaders (`api_headers.dart`)
- `json()`: Retorna headers com Content-Type application/json
- `withToken(token)`: Retorna headers com Bearer token para requisições autenticadas

#### AuthService (`auth_service.dart`)
- **login(username, password)**: `POST /auth/login` da DummyJSON
  - Envia credenciais, retorna AuthenticatedUser
  - Throws `AuthException` se credenciais inválidas
  - Timeout: 10 segundos
- **getCurrentUser(accessToken)**: `GET /auth/me` para validar token
  - Usa para restaurar sessão
- **Tratamento de erro**: Retorna mensagens customizadas

#### ProductService (`services/product_service.dart`)
- **fetchProducts()**: `GET /products` da DummyJSON
  - Retorna List<Product>
  - Cache em memória como fallback
  - Timeout: 10 segundos
- **fetchProductById(id)**: `GET /products/{id}`
  - Busca específica de um produto
  - Atualiza cache local
- **getProductById(id)**: Acessa cache sem requisição
- **Cache Strategy**: Se requisição falhar, retorna dados cacheados

#### FavoritesService (`services/favorites_service.dart`)
- **addFavorite(productId)**: Salva ID em SharedPreferences
- **removeFavorite(productId)**: Remove ID de SharedPreferences
- **isFavorite(productId)**: Verifica se está nos favoritos
- **getFavorites()**: Retorna List<int> de IDs salvos
- **clearFavorites()**: Limpa todos os favoritos
- **Persistência**: Dados salvos localmente no dispositivo

#### SessionManager (`services/session_manager.dart`)
- **login(username, password)**: Autentica via AuthService e salva token
- **restoreSession()**: Recupera token salvo ao iniciar app
- **getCurrentUser()**: Retorna usuário autenticado
- **isAuthenticated**: Getter que verifica se há sessão ativa
- **accessToken**: Getter que retorna token
- **logout()**: Limpa sessão e token
- **clearSession()**: Remove dados de SharedPreferences
- **Extends ChangeNotifier**: Notifica listeners quando estado muda

---

### 3. **Telas (Screens)**

#### SplashScreen (`splash_screen.dart`)
- **Função**: Tela inicial da app
- **Fluxo**:
  1. Carrega app
  2. Chama `sessionManager.restoreSession()`
  3. Se token válido → vai para ProductListScreen
  4. Se sem token → vai para LoginScreen
- **Segurança**: Bloqueia acesso sem autenticação

#### LoginScreen (`login_screen.dart`)
- **Validação**:
  - Username não vazio
  - Password não vazio
- **Campos**:
  - TextFormField para username
  - TextFormField para password (com toggle show/hide)
- **Ações**:
  - Botão "Entrar" faz login e navega para ProductListScreen
  - Mostra loading durante requisição
  - Exibe SnackBar com erro se credenciais inválidas
- **Error Handling**: Captura AuthException e mostra mensagem

#### ProductListScreen (`product_list_screen.dart`)
- **Carregamento**: FutureBuilder para `fetchProducts()`
- **Layout**: GridView com 2 colunas
- **Cards**: ProductCard reutilizável para cada produto
- **Favoritos**:
  - Carrega lista de favoritos ao iniciar
  - Exibe ícone preenchido/vazio em cada card
  - Toggle ao clicar no ícone
  - Sincroniza estado em tempo real
- **AppBar**:
  - Mostra "Produtos" como título
  - Exibe nome do usuário autenticado
  - Foto de perfil do usuário
  - Botão de refresh
  - Botão de logout (com confirmação)
- **Erros**: Mostra spinner se carregando, erro se falhar
- **Botão Floating**: Atualiza manual da lista

#### ProductDetailScreen (`product_detail_screen.dart`)
- **Exibição**:
  - Imagem grande do produto
  - Título, marca, categoria (chips)
  - Preço em verde
  - Rating com estrela
  - Estoque e desconto (se houver)
  - Descrição completa
- **Ações**:
  - Botão "Favoritar/Favoritado" (toggle)
  - Muda entre coração vazio/preenchido
- **Navegação**:
  - BackButton volta para lista
  - Passa `true` se favorito foi modificado
  - ProductListScreen recarrega favoritos se necessário
- **Estados**: FutureBuilder para carregar produto

---

### 4. **Widgets Reutilizáveis** (`widgets/`)

#### ProductCard (`product_card.dart`)
- **Exibição**:
  - Imagem do produto (com erro handler)
  - Título (máx 2 linhas)
  - Preço em verde (destaque)
  - Rating com ícone de estrela
- **Favorito**:
  - Ícone no canto superior direito
  - Coração cheio (vermelho) se favorito
  - Coração vazio (cinza) se não favorito
  - Sombra branca ao fundo
- **Interação**:
  - `onTap`: Navega para detalhes
  - `onFavoriteTap`: Toggle favorito
- **Props**: 
  - `product`: Dados do produto
  - `isFavorite`: Status de favorito
  - `onTap`: Callback ao clicar no card
  - `onFavoriteTap`: Callback ao clicar no ícone

---

## Fluxo de Dados e Navegação

```
main.dart
    ↓ (cria serviços)
    
SplashScreen
    ├─ restoreSession()
    ├─ [Token válido?] ✓ → ProductListScreen
    └─ [Token inválido?] ✗ → LoginScreen
    
LoginScreen
    ├─ sessionManager.login(username, password)
    ├─ [Login ok?] ✓ → ProductListScreen (NavigatorPushReplacement)
    └─ [Login falhou?] ✗ → Mostra erro + fica na tela
    
ProductListScreen
    ├─ Carrega products via productService.fetchProducts()
    ├─ Carrega favoritos via favoritesService.getFavorites()
    ├─ [Clica em produto]
    │   ├─ Navigator.push → ProductDetailScreen
    │   └─ Volta com then().loadFavorites() se modificou
    ├─ [Clica no coração]
    │   └─ Chama _toggleFavorite(productId)
    └─ [Botão logout]
        └─ sessionManager.logout() → LoginScreen
        
ProductDetailScreen
    ├─ Carrega product via productService.fetchProductById(id)
    ├─ Carrega isFavorite via favoritesService.isFavorite(id)
    ├─ [Clica no botão Favoritar]
    │   └─ _toggleFavorite() → adiciona/remove
    └─ [Volta (back button)]
        └─ Navigator.pop(_favoritesModified)
```

---

## Padrões e Princípios Utilizados

✅ **Separação de Responsabilidades**
   - Models: Apenas estrutura de dados
   - Services: Lógica de negócio e API
   - Screens: Interface e navegação
   - Widgets: Componentes visuais reutilizáveis

✅ **Dependency Injection**
   - Serviços passados via construtor
   - Facilita testes e reutilização

✅ **FutureBuilder**
   - Gerencia estados assíncrono (loading, erro, sucesso)
   - Padrão Flutter nativo

✅ **StateManagement com setState()**
   - Simples e eficiente para estado local
   - Suficiente para complexidade do projeto
   - ChangeNotifier em SessionManager para persistência global

✅ **Cache Strategy**
   - Fallback local se API falhar
   - Melhora UX em conexão lenta

✅ **Error Handling**
   - Try/catch em services
   - CustomException para autenticação
   - Snackbar para feedback ao usuário

✅ **Persistência**
   - SharedPreferences para token e favoritos
   - Sessão restaurada ao iniciar

---

## Tecnologias e Dependências

| Tecnologia | Uso |
|------------|-----|
| **Flutter** | Framework UI |
| **Dart** | Linguagem |
| **http** ^1.2.0 | Requisições HTTP |
| **shared_preferences** ^2.5.3 | Persistência local (token, favoritos) |
| **cupertino_icons** | Ícones iOS |

---

## Como o Projeto Atende os Requisitos

| Requisito | Como Foi Atendido |
|-----------|-------------------|
| **Repositório mobile_arquitetura_01** | Pasta criada com nome |
| **Projeto executável** | main.dart com runApp() |
| **Organização em camadas** | models/, services/, screens/, widgets/ |
| **API DummyJSON** | AuthService e ProductService usam https://dummyjson.com |
| **Tela de login** | login_screen.dart com validação |
| **POST /auth/login** | AuthService.login() |
| **Tela principal** | product_list_screen.dart com grid |
| **GET /products** | ProductService.fetchProducts() |
| **GET /products/{id}** | ProductService.fetchProductById(id) |
| **Nome do usuário** | AppBar mostra currentUser.fullName |
| **Botão logout** | IconButton que chama sessionManager.logout() |
| **Tela de detalhes** | product_detail_screen.dart |
| **Navegação** | Navigator.push e Navigator.pop |
| **Favoritos** | FavoritesService com addFavorite/removeFavorite |
| **Ícone favorito** | ProductCard com coração preenchido/vazio |
| **Sincronização** | ProductListScreen recarrega ao voltar |
| **Persistência** | SharedPreferences para token e favoritos |
| **Tratamento de loading** | CircularProgressIndicator em FutureBuilder |
| **Tratamento de erro** | Exibe mensagem de erro e botão retry |
```

### 4. Deleção
```dart
ProductDetailScreen
  → [Delete] → Confirmação
    → productService.deleteProduct()
    → Volta à lista
```

---

## Diferenciais Técnicos

✅ **Sem Libraries Externas Desnecessárias**: Apenas `http`  
✅ **Simples e Direto**: Fácil de entender e manter  
✅ **Escalável**: Widgets e serviços reutilizáveis  
✅ **Tratamento de Erros**: Fallback ao cache  
✅ **Validação**: Formulário com validation  
✅ **UX**: Confirmações, snackbars, retry  

---

## Como Executar

```bash
flutter pub get
flutter run

# Escolha plataforma:
# [1] Windows (desktop) - Sem problemas CORS ✅
# [2] Chrome (web) - Com problema CORS ⚠️
# [3] Edge (web) - Com problema CORS ⚠️
```

---

## Próximas Evoluções (Fora do Escopo Atual)

- Integrar banco de dados local (SQLite/Hive)
- Adicionar autenticação
- Implementar sincronização remota → local
- Adicionar carrinho de compras persistente
- Upload de imagens
- Busca e filtros avançados
- Testes unitários e de integração

