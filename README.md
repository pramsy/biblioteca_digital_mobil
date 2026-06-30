# Biblioteca Digital - Sistema Mobile

Sistema de gestão de biblioteca digital desenvolvido em Flutter, focado em **acessibilidade (WCAG)**, controle hierárquico e alto desempenho via **Clean Architecture**.

## 🚀 Objetivo do Projeto
Fornecer uma experiência fluida para leitores consultarem acervos e gerenciarem empréstimos, garantindo segurança e ferramentas de gestão robustas para administradores.

## 👥 Perfis e Hierarquia
- **Administrador Inicial**: Controle total, incluindo criação de outros Administradores.
- **Administrador**: Gestão de Bibliotecários, Leitores e acervo. Emite relatórios gerenciais.
- **Bibliotecário**: Gestão técnica de livros, atendimento de solicitações e validação de empréstimos.
- **Leitor**: Auto-cadastro, consulta, reserva de livros e suporte.

## 🏗️ Arquitetura e Otimizações
- **Domínio**: Use Cases isolados para cada regra de negócio (Cadastro, Empréstimo, Inativação).
- **Dados**: Persistência SQLite local com **Atomicidade** em transações.
- **Performance**: 
    - **CacheService**: Redução de IO em disco para catálogos e sessões.
    - **JobQueueService**: Processamento assíncrono de notificações e logs.
- **UI/UX**: 
    - Estados explícitos de **Loading**, **Empty** e **Error**.
    - Mensagens de validação orientadas à ação ("Intervenção").
    - Design System baseado em **Material 3**.

## ♿ Acessibilidade
- Tamanho de toque padrão de 48dp.
- Suporte total a leitores de tela via `Semantics`.
- Contraste de cor validado (padrão WCAG AA).

## 🛠️ Como Executar
1. Instale as dependências: `flutter pub get`.
2. Configure o arquivo `.env` na raiz.
3. Execute o projeto: `flutter run`.

## 🧪 Testes Automatizados
```bash
# Rodar todos os testes unitários, integração e UI
flutter test
```

---
Documentação alinhada com as versões de Interface e Performance.
