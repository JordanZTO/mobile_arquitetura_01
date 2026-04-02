# Estrutura do Projeto - Product Store

## Estrutura de Pastas

```
lib/
├── main.dart                    # Ponto de entrada da aplicação
├── models/
│   └── product.dart             # Modelo Product com fromJson/toJson
├── services/
│   └── product_service.dart     # Serviço de API (encapsula http)
├── screens/
│   ├── home_screen.dart         # Tela inicial
│   ├── product_list_screen.dart # Listagem de produtos (FutureBuilder)
│   ├── product_detail_screen.   # Detalhes + ações (Edit/Delete)
│   └── product_form_screen.dart # Formulário para Create/Edit
└── widgets/
    ├── product_card.dart        # Card reutilizável para produtos
    └── form_widgets.dart        # Componentes de formulário
```

---

## Componentes Principais

### 1. **Modelo de Produto** (`models/product.dart`)

```dart
class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final double? rating;
  
  // ✅ fromJson() para desserialização
  factory Product.fromJson(Map<String, dynamic> json) { ... }
  
  // ✅ toJson() para serialização
  Map<String, dynamic> toJson() { ... }
}
```

**Atributos:**
- id, title, price, image, description, category, rating

---

### 2. **Serviço de API** (`services/product_service.dart`)

Encapsula todas as chamadas HTTP:

```dart
class ProductService {
  // ✅ fetchProducts()  - GET (lista completa)
  Future<List<Product>> fetchProducts()
  
  // ✅ addProduct()     - POST (criar novo)
  Future<void> addProduct(Product product)
  
  // ✅ updateProduct()  - PUT (editar existente)
  Future<void> updateProduct(Product product)
  
  // ✅ deleteProduct()  - DELETE (remover)
  Future<void> deleteProduct(int productId)
}
```

**Recursos:**
- Cache em memória como fallback
- Timeout de 10 segundos
- Logs para debug
- Métodos auxiliares (getProductById, getCachedProducts)

---

### 3. **Telas (Screens)**

#### HomeScreen
- Tela inicial com apresentação
- Botão "View Products" → ProductListScreen

#### ProductListScreen
- **FutureBuilder** para carregar produtos
- **GridView** com 2 colunas
- Cards reutilizáveis (ProductCard)
- Tap → ProductDetailScreen
- Botão Retry em caso de erro

#### ProductDetailScreen
- Exibição completa do produto
- Botões de ação:
  - **Add to Cart** (simulado)
  - **Edit** → ProductFormScreen
  - **Delete** (com confirmação)

#### ProductFormScreen
- Formulário para CREATE e EDIT
- **Validação** de campos
- Mesma tela para ambos (diferencia por ID)
- Botões: Save/Update e Cancel

---

### 4. **Widgets Reutilizáveis**

#### ProductCard
- Card com imagem, título, preço, rating
- Padrão para exibição em lista
- Reutilizável em qualquer grid/list

#### FormTextField
- Campo de texto reutilizável
- Suporta validação
- Label, maxLines, keyboardType personalizáveis

#### ActionButton
- Botão reutilizável com ícone
- Pode ser primary ou outlined
- Consistência visual

---

## Fluxo de Navegação

```
main.dart
    ↓
HomeScreen (Bem-vindo)
    ├── [View Products]
    ↓
ProductListScreen (Grid de produtos)
    ├── [Tap em produto]
    ↓
ProductDetailScreen (Detalhes)
    ├── [Add to Cart] → Snackbar
    ├── [Edit] → ProductFormScreen
    │           ├── [Save] → Atualiza + volta
    │           └── [Cancel] → Volta
    ├── [Delete] → Confirmação
    │           └── [Delete] → Volta à lista
    └── [Back] → ProductListScreen
```

---

## Padrões Utilizados

✅ **MVC Simplificado**: Models, Services (Controller), Screens (View)  
✅ **Service Pattern**: ProductService centraliza acesso a dados  
✅ **FutureBuilder**: Gerenciamento de estado assíncrono  
✅ **Componentes Reutilizáveis**: Widgets genéricos para múltiplos contextos  
✅ **Validação**: Formulário com validação de campos  
✅ **Fallback**: Cache em memória se API falhar  

---

## Estrutura vs Requisitos PDF

| Requisito | Implementação |
|-----------|---|
| **models/** | ✅ `models/product.dart` |
| **services/** | ✅ `services/product_service.dart` |
| **screens/** | ✅ `home_screen.dart`, `product_list_screen.dart`, `product_detail_screen.dart`, `product_form_screen.dart` |
| **widgets/** | ✅ `product_card.dart`, `form_widgets.dart` |
| **fromJson/toJson** | ✅ Implementado em Product |
| **Métodos CRUD** | ✅ fetch, add, update, delete |
| **3 Telas principais** | ✅ Home, List, Detail |
| **Tela de formulário** | ✅ ProductFormScreen (Create + Edit) |
| **Navegação entre telas** | ✅ Home → List → Detail → Form |
| **Widgets reutilizáveis** | ✅ ProductCard, FormTextField, ActionButton |

---

## Como Funciona

### 1. Inicialização
```dart
ProductService(http.Client()) // Criado no main.dart
HomeScreen(productService) // Passado para todas as telas
```

### 2. Carregamento de Dados
```dart
ProductListScreen
  → FutureBuilder
    → productService.fetchProducts()
      → Fetch da API ou cache
        → GridView com ProductCard
```

### 3. Edição de Produto
```dart
ProductDetailScreen
  → [Edit] → ProductFormScreen
    → Preenche formulário com dados atuais
    → Valida ao enviar
    → productService.updateProduct()
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

