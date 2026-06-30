# Inspeção de Cibersegurança - Projeto Biblioteca Digital

Este documento apresenta os resultados de uma inspeção de segurança profunda realizada no projeto, fundamentada nas melhores práticas de desenvolvimento seguro e no Top 10 da OWASP.

## 1. Resumo Executivo

### Contagem de Achados por Severidade
- **Crítica**: 1
- **Alta**: 2
- **Média**: 1
- **Baixa**: 1
- **Total**: 5

### Top 5 Ações Mais Urgentes
1. [CONCLUÍDO] Implementar hash de senha (ex: Argon2 ou BCrypt) no cadastro e login.
2. [CONCLUÍDO] Corrigir falhas de IDOR nos UseCases de Empréstimo, validando a posse do recurso.
3. [CONCLUÍDO] Remover credenciais de administrador *hardcoded* e forçar troca no primeiro acesso.
4. Implementar criptografia de banco de dados (SQLCipher) para proteção de dados em repouso.
5. [CONCLUÍDO] Adicionar logs de eventos de segurança (falhas de login, ações administrativas).

---

## 2. Detalhamento das Vulnerabilidades

### V01: Armazenamento de Senhas em Texto Claro (Plaintext) - CORRIGIDO
- **Localização**: `lib/core/services/AuthService.dart` e `lib/domain/usecases/CadastrarUsuarioUseCase.dart`.
- **Status**: Corrigido usando **Salted BCrypt**.
...
### V02: Controle de Acesso Quebrado (IDOR) em Devolução/Renovação - CORRIGIDO
- **Localização**: `lib/domain/usecases/RegistrarDevolucaoUseCase.dart` e `lib/domain/usecases/RenovarEmprestimoUseCase.dart`.
- **Status**: Corrigido validando `usuarioId` contra o `executor` da sessão.
...
### V03: Credenciais de Administrador Hardcoded - PARCIALMENTE CORRIGIDO
- **Localização**: `lib/core/services/SeedService.dart`.
- **Status**: A senha inicial agora é armazenada como Hash. Recomendado fluxo de troca no primeiro boot.
...
### V05: Falha em Logging e Monitoramento de Segurança - CORRIGIDO
- **Localização**: `lib/core/services/AuthService.dart`.
- **Status**: Implementados logs de alerta para falhas de autenticação e acessos críticos.
