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
- `app.dart`: Configuração global do MaterialApp (Tema, Rotas, NavigatorKey).
- `config/injection.dart`: Injeção de dependência centralizada (GetIt).
- `routes/app_routes.dart`: Mapeamento de rotas nomeadas.
- `theme/app_theme.dart`: Padrões visuais acessíveis (Contraste, Material 3).

### /lib/core/
- `constants/app_constants.dart`: Strings de perfil, status e mensagens padrão.
- `errors/`: Definições de Failures e Exceptions para tratamento de erros.
- `services/`:
    - `DatabaseService.dart`: Singleton para conexão SQLite.
    - `AuthService.dart`: Gestão de sessão e Rate Limiting.
    - `SeedService.dart`: Criação do ADMIN_INICIAL no primeiro boot.
    - `AccessibilityService.dart`: Utilitários para Semântica e Focus.

### /lib/domain/ (Regras de Negócio)
- `entities/`: Modelos puros (Usuario, Livro, Solicitacao, Emprestimo).
- `usecases/`:
    - `CadastrarUsuarioUseCase.dart`: Valida hierarquia, e-mail único e senha forte.
    - `AtualizarUsuarioUseCase.dart`: Permite edição conforme permissão hierárquica.
    - `InativarUsuarioUseCase.dart`: Inativação lógica (status = INATIVO).
    - `CadastrarLivroUseCase.dart`: Criação de exemplares (Admin/Biblio).
    - `RegistrarEmprestimoUseCase.dart`: Valida disponibilidade e cria vínculo.
    - `ResponderSolicitacaoUseCase.dart`: Atendimento de chamados (Admin/Biblio).

### /lib/data/ (Persistência)
- `models/`: Extensões das entidades com métodos toMap/fromMap.
- `repositories/`: Implementações concretas dos contratos do domínio via SQLite.

## 4. Fluxos Principais
1. **Inicialização**: `main.dart` -> Load Env -> Setup Injection -> Run Seed -> Run App.
2. **Autenticação**: Login -> Validação Rate Limit -> Busca Usuário -> Cria Sessão -> Direciona Dashboard.
3. **Gestão Hierárquica**: 
    - Se Perfil == ADMIN_INICIAL: Pode criar ADMIN.
    - Se Perfil == ADMIN: Pode criar BIBLIOTECARIO.
    - Se Perfil == null: Auto-cadastro como LEITOR.

## 5. Critérios de Acessibilidade
- Tamanho de toque mínimo: 48x48 pixels.
- Uso de `Semantics` em todos os campos de formulário e botões.
- Contraste de texto seguindo WCAG (mínimo 4.5:1).
