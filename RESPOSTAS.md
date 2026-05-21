# Respostas - Atividade de Evolução do Projeto Flutter

## 1. Quais eram as limitações da versão inicial do projeto?

A versão inicial apresentava as seguintes limitações:

- **Modelo simples**: O Product possuía apenas id, title, price e image
- **Exibição limitada**: A tela exibia apenas os dados básicos em uma simples ListView com ListTile
- **Sem navegação**: Não havia navegação entre múltiplas telas; toda a aplicação era baseada em uma única página
- **Sem fluxo de usuário**: Não havia tela inicial ou de detalhes
- **Sem preparação para CRUD**: O ViewModel apenas carregava produtos, sem suporte a criação, edição ou remoção
- **Interface básica**: A apresentação visual era minimalista e não aproveitava os dados disponíveis da API
- **Sem persistência estruturada**: O cache era apenas em memória, sem gerenciamento adequado

## 2. Quais mudanças estruturais você realizou na aplicação?

As seguintes mudanças estruturais foram introduzidas:

- **Expansão do modelo Product**: Adicionado description, category e rating aos atributos do produto
- **Criação de novas telas**: 
  - HomePage: Tela inicial com navegação
  - ProductDetailPage: Exibição completa de detalhes do produto
  - ProductPage refatorada: Lists em grid com melhor visual
- **Melhoria da arquitetura**:
  - ProductState agora inclui selectedProduct
  - ProductViewModel expandido com métodos CRUD
  - ProductRepository com interface CRUD
  - ProductCacheDatasource com operações de Write (além de Read)
- **Tratamento de erros melhorado**: ProductPage agora exibe mensagens de erro com opção de retry
- **Interface responsiva**: Grid layout e melhor apresentação de imagens

## 3. Como ficou a organização das telas e do fluxo de navegação?

O fluxo de navegação foi estruturado da seguinte forma:

```
HomePage (Tela Inicial)
    ↓ (ao clicar "View Products")
ProductPage (Listagem de Produtos em Grid)
    ↓ (ao clicar em um produto)
ProductDetailPage (Detalhes do Produto)
    ↓ (botão back ou navigation)
ProductPage
    ↓
HomePage
```

**Organização das telas:**
- `lib/presentation/pages/home_page.dart`: Tela inicial com apresentação
- `lib/presentation/pages/product_page.dart`: Listagem em grid com navegação
- `lib/presentation/pages/product_detail_page.dart`: Detalhes completos do produto

**Navigator utilizado:**
- Navigator.push() para transições entre telas
- Back button padrão do AppBar para retorno

## 4. Quais atributos do produto passaram a ser utilizados na nova versão?

Na nova versão, os seguintes atributos do produto são utilizados:

- **id**: Identificador único
- **title**: Título/nome do produto (exibido em listing e detalhes)
- **price**: Preço (formatado e exibido com símbolo $)
- **image**: URL da imagem (carregada via Image.network)
- **category**: Categoria do produto (exibida como Chip nos detalhes)
- **description**: Descrição completa (exibida apenas na tela de detalhes)
- **rating**: Avaliação do produto (exibida como estrelas em listing e detalhes)

**Comparação:**
- Versão inicial: 4 atributos (id, title, price, image)
- Versão atual: 7 atributos (todos os acima)

## 5. Como você organizou a camada de acesso a dados?

A camada de dados foi organizada em três níveis:

### ProductRemoteDatasource
- Responsável por buscar dados da API (https://fakestoreapi.com/products)
- Método: `getProducts()` - retorna List<ProductModel>

### ProductCacheDatasource
- Armazena dados em memória para acesso rápido
- Métodos implementados:
  - `save()`: Salva lista completa
  - `get()`: Recupera lista cacheada
  - `addProduct()`: Adiciona novo produto
  - `updateProduct()`: Atualiza produto existente
  - `deleteProduct()`: Remove produto

### ProductRepositoryImpl
- Implementa a interface ProductRepository
- Orquestra comunicação entre remote e cache
- Oferece fallback ao cache em caso de erro
- Converte ProductModel → Product (entity)
- Métodos:
  - `getProducts()`: Carrega da API com fallback ao cache
  - `addProduct()`: Salva no cache
  - `updateProduct()`: Atualiza no cache
  - `deleteProduct()`: Remove do cache

## 6. Seu projeto foi preparado para operações além do GET? Explique.

Sim, o projeto foi preparado estruturalmente para operações CRUD completas:

### Preparação implementada:

**ProductRepository (Interface):**
```dart
Future<void> addProduct(Product product);
Future<void> updateProduct(Product product);
Future<void> deleteProduct(int productId);
```

**ProductViewModel:**
- `addProduct()`: Adiciona à lista em estado
- `updateProduct()`: Atualiza produto na lista
- `deleteProduct()`: Remove da lista
- `getProductById()`: Busca produto específico

**ProductCacheDatasource:**
- Métodos para CREATE, UPDATE, DELETE em memória

**Limitações atuais:**
- As operações CRUD funcionam apenas em cache (memória)
- Não há integração com API para POST, PUT, DELETE (FakeStore não suporta escrita persistente)
- Os dados são perdidos ao reiniciar o app

**Para evolução futura:**
- Adicionar métodos POST, PUT, DELETE no ProductRemoteDatasource
- Integrar banco de dados local (SQLite, Hive) para persistência real
- Expandir ProductRepositoryImpl para sincronizar cache ↔ banco local

## 7. Houve uso ou planejamento de persistência local? Justifique.

Houve um planejamento estrutural, mas implementação parcial:

### O que foi implementado:

**Cache em memória (ProductCacheDatasource):**
- Armazena dados temporariamente durante a sessão
- Suporta operações de write (add, update, delete)
- Serve como fallback quando API não está disponível

### O que foi planejado estruturalmente:

- A separação entre remote e cache já prepara o projeto para:
  - Substituir ProductCacheDatasource por um banco de dados real (SQLite, Hive)
  - Implementar sincronização de dados
  - Manter persistência entre seções do app

### Por que não foi implementado completamente:

1. **FakeStore não suporta persistência real**: A API não permite POST/PUT/DELETE permanentes
2. **Escopo da atividade**: O foco era em organização e navegação, não em banco de dados
3. **Simplicidade**: Conforme solicitado, apenas o necessário foi implementado

### Próximos passos para persistência real:

```
1. Adicionar dependência: sqflite ou hive
2. Criar LocalDatasource com banco de dados
3. Modificar repositório para sincronizar local ↔ cache
4. Implementar sync ao carregar/salvar produtos
```

## 8. Quais foram as principais dificuldades encontradas durante a evolução do projeto?

As principais dificuldades foram:

### 1. Modelagem com dados incompletos
- **Dificuldade**: A API retorna rating como objeto {rate, count}, não apenas um valor
- **Solução**: Extrair apenas rate e tornar rating opcional

### 2. Navegação e contexto de estado
- **Dificuldade**: ProductPage precisa ser StatefulWidget para chamar loadProducts() no initState
- **Solução**: Refatorar de StatelessWidget para StatefulWidget

### 3. Responsabilidade do ViewModel
- **Dificuldade**: Decidir se ViewModel deve gerenciar CRUD localmente até persistência real
- **Solução**: Implementar CRUD no ViewModel que reflete no estado (preparação para persistência)

### 4. Imagens da API
- **Dificuldade**: Algumas imagens da FakeStore podem falhar ou não carregar corretamente
- **Solução**: Implementar errorBuilder em Image.network com ícone de fallback

### 5. Sem API de escrita real
- **Dificuldade**: FakeStore não persiste POST/PUT/DELETE, apenas simula
- **Solução**: Implementar tudo em cache, deixando estrutura pronta para banco local

### 6. Balanceamento entre simplicidade e completude
- **Dificuldade**: Adicionar funcionalidades sem criar complexidade desnecessária
- **Solução**: Seguir o princípio YAGNI (You Aren't Gonna Need It) - implementar apenas o necessário

---

## Resumo da Evolução

| Aspecto | Versão Inicial | Versão Atual |
|---------|---|---|
| Atributos do Produto | 4 | 7 |
| Telas | 1 | 3 |
| Navegação | Não | Sim (3 fluxos) |
| Operações de Dados | GET | GET, CREATE, UPDATE, DELETE (em cache) |
| Modelo de Estado | Simples | Expandido com selectedProduct |
| Persistência | Apenas API | Cache + preparação para BD local |
| Interface | Simples ListView | Grid responsivo + Detalhes ricos |

