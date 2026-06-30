# Especificação do Projeto - Biblioteca Digital

## 1. Visão Geral
Sistema mobile para gestão de acervo bibliotecário, focado em acessibilidade e controle hierárquico de permissões.

## 2. Perfis de Usuário e Hierarquia
- **Administrador Inicial (ADMIN_INICIAL)**: Criado via Seed. Possui permissão total, incluindo a criação de outros Administradores.
- **Administrador (ADMIN)**: Pode gerenciar Bibliotecários e Leitores. Não pode criar ou gerenciar outros Administradores.
- **Bibliotecário (BIBLIOTECARIO)**: Focado na gestão do acervo (livros), empréstimos e atendimento de solicitações.
- **Leitor (LEITOR)**: Usuário final que consome o acervo, realiza empréstimos e envia solicitações.

## 3. Arquitetura de Arquivos e Responsabilidades

### /lib/app/
- `app.dart`: Configuração global do MaterialApp.
- `config/injection.dart`: Injeção de dependência centralizada.
- `routes/app_routes.dart`: Mapeamento de rotas.
- `theme/app_theme.dart`: Padrões visuais acessíveis.

### /lib/core/
- `constants/`: Strings de perfil, status e mensagens padrão.
- `errors/`: Definições de Failures e Exceptions.
- `services/`:
    - `DatabaseService.dart`: Singleton SQLite.
    - `AuthService.dart`: Gestão de sessão e Rate Limiting.
    - `CacheService.dart`: Cache em memória para otimização de consultas frequentes.
    - `JobQueueService.dart`: Fila de tarefas para processamento assíncrono em background.
    - `AccessibilityService.dart`: Utilitários para Semântica.

### /lib/domain/
- `entities/`: Modelos puros.
- `usecases/`: Regras de negócio atomizadas e testáveis.

### /lib/data/
- `models/`: Mapeamento de dados (toMap/fromMap).
- `repositories/`: Implementações concretas com suporte a cache.

## 4. Otimizações de Desempenho
- **Cache de Dados**: Consultas ao catálogo e perfil do usuário são cacheadas em memória para reduzir acesso ao disco (SQLite).
- **Processamento Assíncrono (Jobs)**: Operações que não requerem resposta imediata da UI (como logs e sincronizações internas) são enviadas para uma `JobQueue`.
- **Boilerplate Reduction**: Uso de Mixins e classes base nos Repositórios para simplificar operações CRUD.

## 5. Fluxos Principais
1. **Inicialização**: `main.dart` -> Load Env -> Setup Injection -> Warm-up Cache -> Run App.
2. **Autenticação**: Login -> Validação -> Cache de Sessão -> Direciona Dashboard.

## 6. Critérios de Acessibilidade
- Tamanho de toque mínimo: 48x48 pixels.
- Uso de `Semantics` em todos os campos interativos.
- Contraste WCAG (mínimo 4.5:1).
