# Estrutura do Projeto - Product Store

## Estrutura de Pastas

```
lib/
├── main.dart                              # Ponto de entrada da aplicação
├── core/
│   └── errors/
│       └── failure.dart                   # Classes para tratamento de erros
├── models/
│   ├── product.dart                       # Modelo Product com fromJson/toJson
│   └── authenticated_user.dart            # Modelo de usuário autenticado
├── services/
│   ├── api_headers.dart                   # Headers customizados para requisições
│   ├── auth_service.dart                  # Serviço de autenticação e login
│   ├── product_service.dart               # Serviço de API (encapsula http)
│   ├── favorites_service.dart             # Serviço de favoritos
│   └── session_manager.dart               # Gerenciamento de sessão de usuário
├── data/
│   ├── datasources/                       # Fontes de dados (placeholder)
│   ├── models/                            # Models específicos de dados
│   └── repositories/                      # Implementações de repositórios
├── domain/
│   ├── entities/                          # Entidades do domínio
│   └── repositories/                      # Interfaces de repositórios
├── presentation/
│   ├── pages/                             # Páginas da aplicação
│   └── viewmodels/                        # ViewModels para gerenciamento de estado
├── screens/
│   ├── splash_screen.dart                 # Tela de carregamento inicial
│   ├── login_screen.dart                  # Tela de autenticação
│   ├── home_screen.dart                   # Tela inicial
│   ├── product_list_screen.dart           # Listagem de produtos (FutureBuilder)
│   ├── product_detail_screen.dart         # Detalhes + ações (Edit/Delete)
│   └── product_form_screen.dart           # Formulário para Create/Edit
└── widgets/
    ├── product_card.dart                  # Card reutilizável para produtos
    └── form_widgets.dart                  # Componentes de formulário
```

---

## Componentes Principais

### 1. **Modelos de Dados** (`models/`)

#### Product (`models/product.dart`)
```dart
class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final double? rating;
  
  factory Product.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

#### AuthenticatedUser (`models/authenticated_user.dart`)
```dart
class AuthenticatedUser {
  final String id;
  final String email;
  final String name;
  final String? token;
  
  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

---

### 2. **Serviços** (`services/`)

#### ApiHeaders (`services/api_headers.dart`)
- Headers customizados para requisições HTTP
- Gerencia tokens de autenticação
- Método: `getHeaders()` → `Map<String, String>`

#### AuthService (`services/auth_service.dart`)
- Gerencia autenticação e login de usuário
- Métodos principais:
  - `login(email, password)`: Autentica usuário
  - `logout()`: Encerra sessão
  - `isAuthenticated()`: Verifica se usuário está logado
  - `getCurrentUser()`: Obtém usuário atual

#### ProductService (`services/product_service.dart`)
- Encapsula todas as chamadas HTTP para produtos
- Métodos principais:
  - `fetchProducts()`: GET (lista completa)
  - `addProduct(Product)`: POST (criar novo)
  - `updateProduct(Product)`: PUT (editar)
  - `deleteProduct(int id)`: DELETE (remover)
  - `getProductById(int id)`: Busca específica
  - `getCachedProducts()`: Retorna cache local

#### FavoritesService (`services/favorites_service.dart`)
- Gerencia favoritos do usuário
- Métodos:
  - `addFavorite(int productId)`: Adiciona aos favoritos
  - `removeFavorite(int productId)`: Remove dos favoritos
  - `getFavorites()`: Lista de IDs de favoritos
  - `isFavorite(int productId)`: Verifica se é favorito

#### SessionManager (`services/session_manager.dart`)
- Gerencia estado de sessão do usuário
- Métodos:
  - `saveSession(AuthenticatedUser)`: Salva sessão
  - `getSession()`: Recupera sessão ativa
  - `clearSession()`: Limpa sessão
  - `isSessionValid()`: Valida sessão

**Recursos Comuns:**
- Cache em memória como fallback
- Timeout de 10 segundos
- Logs para debug
- Tratamento de erros

---

### 3. **Telas (Screens)**

#### SplashScreen
- Tela de carregamento inicial
- Exibe logo/brand da aplicação
- Verifica sessão do usuário
- Navega para LoginScreen ou HomeScreen

#### LoginScreen
- Tela de autenticação
- Campos: Email e Senha
- Validação de credenciais
- Botão "Entrar" → Valida e navega para HomeScreen
- Link "Cadastro" (placeholder)

#### HomeScreen
- Tela inicial com apresentação
- Exibe informações do usuário logado
- Botão "View Products" → ProductListScreen
- Menu com opções (Favoritos, Logout, etc.)

#### ProductListScreen
- **FutureBuilder** para carregar produtos
- **GridView** com 2 colunas
- Cards reutilizáveis (ProductCard)
- Tap em produto → ProductDetailScreen
- Botão Retry em caso de erro
- Ícone de favorito em cada card

#### ProductDetailScreen
- Exibição completa do produto
- Botões de ação:
  - **Add to Cart** (simulado com Snackbar)
  - **Favorite** (toggle favorito)
  - **Edit** → ProductFormScreen
  - **Delete** (com diálogo de confirmação)
- Exibe avaliação e categoria

#### ProductFormScreen
- Formulário para CREATE e EDIT
- **Validação** de campos obrigatórios
- Mesma tela para ambas operações (diferencia por ID)
- Campos: Título, Preço, Descrição, Categoria, Imagem
- Botões: Save/Update e Cancel

---

### 4. **Widgets Reutilizáveis** (`widgets/`)

#### ProductCard
- Card com imagem, título, preço, rating
- Ícone de favorito (toggle)
- Padrão para exibição em grid
- Reutilizável em qualquer contexto

#### FormTextField
- Campo de texto reutilizável
- Suporta validação e erro messages
- Label, maxLines, keyboardType personalizáveis
- Máscara de entrada (opcional)

#### ActionButton
- Botão reutilizável com ícone
- Pode ser primary ou outlined
- Consistência visual em toda app
- Suporta loading state

---

### 5. **Estrutura de Camadas** (`core/`, `domain/`, `data/`, `presentation/`)

#### core/ - Camada de Núcleo
- **errors/failure.dart**: Classes base para tratamento de erros
- Utilitários compartilhados

#### domain/ - Lógica de Negócio
- **entities/**: Modelos puros de domínio
- **repositories/**: Interfaces/contratos de acesso a dados

#### data/ - Acesso a Dados
- **datasources/**: Definição de fontes de dados (local, remote)
- **models/**: Modelos específicos de serialização
- **repositories/**: Implementações dos contratos

#### presentation/ - Apresentação
- **pages/**: Páginas da aplicação
- **viewmodels/**: Gerenciamento de estado avançado (MVVM)

---

## Fluxo de Navegação

```
main.dart
    ↓
SplashScreen (Verificação de sessão)
    ├── [Sessão válida?] → HomeScreen
    └── [Sessão inválida?] → LoginScreen
    ↓
LoginScreen (Autenticação)
    ├── [Login bem-sucedido] → HomeScreen
    └── [Tentar novamente] → LoginScreen
    ↓
HomeScreen (Bem-vindo)
    ├── [View Products]
    ├── [Favorites]
    └── [Logout] → LoginScreen
    ↓
ProductListScreen (Grid de produtos)
    ├── [Tap em produto]
    ├── [Favorite icon] → Toggle favorito
    ↓
ProductDetailScreen (Detalhes)
    ├── [Add to Cart] → Snackbar
    ├── [Favorite] → Toggle + atualiza
    ├── [Edit] → ProductFormScreen
    │           ├── [Save] → Atualiza + volta para Detail
    │           └── [Cancel] → Volta sem salvar
    ├── [Delete] → Diálogo de confirmação
    │           └── [Confirmar] → Volta à lista
    └── [Back] → ProductListScreen
```

---

## Padrões Utilizados

✅ **Arquitetura em Camadas**: Core, Domain, Data, Presentation  
✅ **Service Pattern**: ProductService, AuthService, FavoritesService centralizam acesso a dados  
✅ **Model-Service-Screen (MSS)**: Estrutura simplificada MVC/MVVM  
✅ **FutureBuilder**: Gerenciamento de estado assíncrono  
✅ **Componentes Reutilizáveis**: Widgets genéricos (ProductCard, FormTextField, ActionButton)  
✅ **Validação de Formulário**: Validação em tempo real com erro messages  
✅ **Cache Strategy**: Fallback local se API falhar  
✅ **Session Management**: Rastreamento de autenticação e estado de usuário  
✅ **Dependency Injection**: Serviços passados por construtor  
✅ **Error Handling**: Tratamento centralizado de falhas via core/errors/

---

## Requisitos Implementados

| Requisito | Localização | Status |
|-----------|-------------|--------|
| **Models com fromJson/toJson** | `models/product.dart`, `models/authenticated_user.dart` | ✅ |
| **Autenticação** | `services/auth_service.dart`, `screens/login_screen.dart` | ✅ |
| **CRUD de Produtos** | `services/product_service.dart` | ✅ |
| **Favoritos** | `services/favorites_service.dart` | ✅ |
| **Tela Splash** | `screens/splash_screen.dart` | ✅ |
| **Tela Login** | `screens/login_screen.dart` | ✅ |
| **Tela Home** | `screens/home_screen.dart` | ✅ |
| **Listagem (Grid)** | `screens/product_list_screen.dart` | ✅ |
| **Detalhes** | `screens/product_detail_screen.dart` | ✅ |
| **Formulário CRUD** | `screens/product_form_screen.dart` | ✅ |
| **Widgets Reutilizáveis** | `widgets/product_card.dart`, `widgets/form_widgets.dart` | ✅ |
| **Navegação Entre Telas** | Implementada via Router/Navigator | ✅ |
| **Cache Local** | Implementado em services | ✅ |
| **Headers Customizados** | `services/api_headers.dart` | ✅ |
| **Session Manager** | `services/session_manager.dart` | ✅ |

---

## Resumo das Responsabilidades

| Camada | Responsabilidade |
|--------|-----------------|
| **Screens** | Interface com usuário, navegação |
| **Widgets** | Componentes reutilizáveis |
| **Services** | Lógica de negócio, API calls, cache |
| **Models** | Serialização/desserialização de dados |
| **Core** | Tratamento centralizado de erros |
| **Data/Domain** | Preparada para crescimento Clean Architecture |
    → Volta e atualiza tela
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

