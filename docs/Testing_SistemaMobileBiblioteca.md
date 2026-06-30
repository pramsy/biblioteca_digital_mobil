# Plano de Testes Mobile - Sistema de Biblioteca Digital (Otimizado)

## 1. Mapeamento de Testes Unitários

### 1.1 Gestão de Usuários e Hierarquia
- **T-UNIT-USR-001**: Admin Inicial cadastra outro Admin.
- **T-UNIT-USR-002**: Admin comum tenta cadastrar Admin (Bloqueio).
- **T-UNIT-USR-003**: Validação de senha e e-mail único.

### 1.2 Performance e Otimização (Novos)
- **T-UNIT-OPT-001**: Verificação de Cache: A segunda consulta ao catálogo deve retornar dados da memória (CacheService).
- **T-UNIT-OPT-002**: Fila de Tarefas: Garantir que um job adicionado à JobQueueService seja executado de forma assíncrona.
- **T-UNIT-OPT-003**: Invalidação de Cache: Após cadastrar um livro, o cache do catálogo deve ser limpo.

### 1.3 Autenticação
- **T-UNIT-AUTH-001**: Login com sucesso e persistência em cache da sessão.
- **T-UNIT-AUTH-002**: Bloqueio por Rate Limiting.

## 2. Testes de Integração (SQLite)
- **T-INT-DB-001**: Criação de tabelas.
- **T-INT-DB-002**: Transações atômicas com Rollback.

## 3. Testes de Interface (Widget)
- **T-WID-UI-001**: Semântica de Acessibilidade.
- **T-WID-UI-002**: Menus contextuais por perfil.

## 4. Instruções
```bash
flutter test
```
