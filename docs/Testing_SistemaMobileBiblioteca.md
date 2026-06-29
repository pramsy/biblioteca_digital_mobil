# Plano de Testes Mobile - Sistema de Biblioteca Digital

## 1. Mapeamento de Testes Unitários (UseCases)

### 1.1 Gestão de Usuários e Hierarquia
- **T-UNIT-USR-001**: Administrador Inicial consegue cadastrar um perfil ADMIN. (Sucesso)
- **T-UNIT-USR-002**: Administrador comum (ADMIN) tenta cadastrar um perfil ADMIN. (Falha: UnauthorizedException)
- **T-UNIT-USR-003**: Cadastro de usuário com e-mail já existente. (Falha: UserConflictException)
- **T-UNIT-USR-004**: Cadastro com senha fraca (menos de 8 caracteres ou sem números). (Falha: WeakPasswordException)
- **T-UNIT-USR-005**: Inativação de um Administrador por outro Administrador comum. (Falha: UnauthorizedException)

### 1.2 Autenticação
- **T-UNIT-AUTH-001**: Login com credenciais válidas e status ATIVO. (Sucesso)
- **T-UNIT-AUTH-002**: Login com usuário de status INATIVO. (Falha: AuthException)
- **T-UNIT-AUTH-003**: Bloqueio por Rate Limiting após 5 tentativas falhas. (Sucesso: RateLimitException)

### 1.3 Gestão de Acervo e Empréstimos
- **T-UNIT-BOK-001**: Cadastro de livro por Bibliotecário. (Sucesso)
- **T-UNIT-LON-001**: Registro de empréstimo de livro com status DISPONIVEL. (Sucesso)
- **T-UNIT-LON-002**: Registro de empréstimo de livro já EMPRESTADO. (Falha: BookUnavailableException)

## 2. Testes de Integração (SQLite)
- **T-INT-DB-001**: Verificação da criação de tabelas na inicialização do banco.
- **T-INT-DB-002**: Validação de Atomicidade: Falha na atualização do status do livro deve reverter a criação do registro de empréstimo (Rollback).

## 3. Testes de Interface e Acessibilidade (Widget Tests)
- **T-WID-UI-001**: Verificação de Semântica e Rótulos na tela de Login.
- **T-WID-UI-002**: Visibilidade de Menus: Botão "Cadastrar Administrador" deve estar oculto para o perfil ADMIN.
- **T-WID-UI-003**: Feedback Visual: Exibição de Snackbar após erro de login.

## 4. Instruções de Execução
Para rodar todos os testes automatizados:
```bash
flutter test
```
