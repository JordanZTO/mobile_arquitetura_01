# Questionário de Reflexão — Atividade 2

## 1. Em qual camada foi implementado o mecanismo de cache?

O mecanismo de cache foi implementado na **camada de Data**, na classe `ProductCacheDatasource`. Essa decisão é adequada porque a camada de Data é responsável por gerenciar as fontes de dados da aplicação, como API, cache ou banco de dados. Assim, a lógica de armazenamento temporário fica separada da interface e da lógica de negócio, mantendo o projeto organizado.

## 2. Por que o ViewModel não deve realizar chamadas HTTP diretamente?

O ViewModel pertence à camada de **Presentation**, cuja responsabilidade é apenas controlar o estado da interface. As chamadas HTTP devem ser feitas na camada de **Data**, através do repositório. Isso mantém o código desacoplado, facilita testes e permite trocar a fonte de dados sem alterar a interface.

## 3. O que poderia acontecer se a interface acessasse diretamente o DataSource?

Se a interface acessasse diretamente o DataSource, haveria um forte **acoplamento entre a interface e a camada de dados**. Isso tornaria o código mais difícil de manter, testar e modificar. Além disso, qualquer mudança na forma de obtenção dos dados poderia exigir alterações na interface.

## 4. Como essa arquitetura facilitaria a substituição da API por um banco de dados local?

Essa arquitetura facilita a substituição porque o ViewModel depende apenas da **interface `ProductRepository`**, e não de uma implementação específica. Assim, seria possível criar uma nova implementação do repositório usando um banco de dados local, sem precisar alterar a interface ou o ViewModel.
