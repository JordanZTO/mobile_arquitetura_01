# Estrutura do Projeto - Product Store

## Visão Geral

Projeto Flutter reestruturado para seguir Clean Architecture com separação clara entre camadas (Domain, Data, Presentation).

```
lib/
├── main.dart                           # Entrada da aplicação, inicializa HomePage
├── core/
│   └── errors/
│       └── failure.dart                # Classe para tratamento de erros
├── domain/
│   ├── entities/
│   │   └── product.dart                # Entidade Product (modelo de negócio)
│   └── repositories/
│       └── product_repository.dart     # Interface de repositório
├── data/
│   ├── datasources/
│   │   ├── product_remote_datasource.dart    # Comunicação com API
│   │   └── product_cache_datasource.dart     # Cache em memória
│   ├── models/
│   │   └── product_model.dart          # Model para serialização JSON
│   └── repositories/
│       └── product_repository_impl.dart # Implementação do repositório
└── presentation/
    ├── pages/
    │   ├── home_page.dart              # Tela inicial
    │   ├── product_page.dart           # Listagem de produtos em grid
    │   └── product_detail_page.dart    # Detalhes do produto
    └── viewmodels/
        ├── product_viewmodel.dart      # Gerenciamento de estado
        └── product_state.dart          # Estado dos produtos
```

## Componentes Principais

### 1. **Product Entity** (`domain/entities/product.dart`)
Representa o conceito de um produto no domínio da aplicação.

**Atributos:**
- `id`: int - Identificador único
- `title`: String - Nome/título do produto
- `price`: double - Preço
- `image`: String - URL da imagem
- `description`: String - Descrição completa
- `category`: String - Categoria
- `rating`: double? - Avaliação (opcional)

### 2. **ProductModel** (`data/models/product_model.dart`)
Responsável pela serialização/desserialização JSON da API.

**Métodos principais:**
- `fromJson()`: Converte JSON da API em ProductModel
- `toJson()`: Converte ProductModel para JSON

### 3. **Datasources**

#### ProductRemoteDatasource
- Comunica com API: `https://fakestoreapi.com/products`
- Método: `getProducts()` → `Future<List<ProductModel>>`

#### ProductCacheDatasource
- Armazena dados em memória como fallback
- Métodos:
  - `save()`: Salva lista completa
  - `get()`: Recupera cache
  - `addProduct()`: Adiciona novo
  - `updateProduct()`: Atualiza existente
  - `deleteProduct()`: Remove

### 4. **ProductRepository** (`domain` + `data`)
Interface que define contrato de acesso a dados:
```dart
abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(int productId);
}
```

Implementação (`ProductRepositoryImpl`):
- Orquestra remote + cache
- Fallback ao cache se API falhar
- Converte ProductModel → Product

### 5. **ProductViewModel** (`presentation/viewmodels/`)
Gerencia estado e lógica de apresentação.

**Métodos principais:**
- `loadProducts()`: Carrega lista da API
- `addProduct()`: Adiciona e atualiza estado
- `updateProduct()`: Atualiza na lista
- `deleteProduct()`: Remove da lista
- `getProductById()`: Busca produto específico

**Estado (ProductState):**
- `isLoading`: bool - Indicador de carregamento
- `products`: List<Product> - Lista de produtos
- `error`: String? - Mensagem de erro
- `selectedProduct`: Product? - Produto selecionado

### 6. **Telas**

#### HomePage
- Tela inicial com welcome message
- Botão para navegação à ProductPage
- Simples e direta

#### ProductPage
- Listagem em **GridView** (2 colunas)
- Cards com imagem, título, preço e rating
- Tap para navegar a ProductDetailPage
- Botão refresh para recarregar
- Tratamento de erro com retry

#### ProductDetailPage
- Exibição completa do produto
- Imagem grande em destaque
- Todos os atributos visíveis
- Botões "Add to Cart" e "Favorite"
- SingleChildScrollView para produtos com descrição longa

## Fluxo de Navegação

```
App Inicializa
    ↓
HomePage (Tela Inicial)
    ↓ [View Products]
ProductPage (Grid de Produtos)
    ↓ [Tap em Produto]
ProductDetailPage (Detalhes)
    ↓ [Back]
ProductPage
    ↓ [Back]
HomePage
```

## Dependências Utilizadas

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0              # Para requisições HTTP
  cupertino_icons: ^1.0.8   # Ícones padrão
```

## Tratamento de Erros

1. **API indisponível**: Utiliza cache como fallback
2. **Imagens não carregam**: Exibe ícone de placeholder
3. **Erro ao carregar produtos**: Mostra mensagem com botão "Retry"

## Preparação para Persistência

A arquitetura está pronta para evolução:

1. Substituir `ProductCacheDatasource` por banco local (SQLite, Hive)
2. Implementar sincronização entre local e remoto
3. Adicionar ProductCreatePage e ProductEditPage
4. Integrar POST/PUT/DELETE quando API real suportar

## Como Executar

```bash
# Instalar dependências
flutter pub get

# Analisar código
flutter analyze

# Rodar em debug
flutter run

# Build para produção
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
flutter build windows  # Windows
flutter build linux    # Linux
```

## Padrões Utilizados

- **Clean Architecture**: Separação clara entre camadas (domain, data, presentation)
- **MVVM**: Model-View-ViewModel para separação de responsabilidades
- **Repository Pattern**: Abstração do acesso a dados
- **State Management**: ValueNotifier para reatividade simples
- **Datasource Pattern**: Separação entre remote e local

## Notas Importantes

- A FakeStore API não persiste dados reais (POST/PUT/DELETE são simulados)
- Cache é apenas em memória - dados são perdidos ao restartar
- Não há autenticação implementada
- UI é responsiva em diferentes tamanhos de tela
- Suporta multiple plataformas (Android, iOS, Web, Windows, Linux, macOS)
