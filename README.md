# Biblioteca Digital - Sistema Mobile

Sistema de gestão de biblioteca digital desenvolvido em Flutter, focado em acessibilidade, seguindo os princípios de Clean Architecture e TDD (Test-Driven Development).

## 🚀 Objetivo do Projeto

O objetivo deste aplicativo é fornecer uma plataforma acessível para consulta de acervo, gestão de empréstimos e comunicação direta entre leitores e administradores (via solicitações). O sistema foi projetado para atender diferentes perfis de usuários: Leitor, Editor e Administrador.

## 🏗️ Arquitetura e Estrutura

O projeto segue os padrões de **Clean Architecture**, dividido nas seguintes camadas:

- **Core**: Serviços transversais (Banco de dados, Autenticação, Acessibilidade), constantes e utilitários.
- **Domain**: Entidades de negócio, contratos de repositórios e casos de uso (Regras de negócio).
- **Data**: Implementações de repositórios e modelos de dados para persistência local (SQLite).
- **App**: Configurações globais, injeção de dependência, rotas e tema visual.
- **Features**: Camada de interface dividida por funcionalidades (Auth, Dashboard, Usuários, Livros, etc.).

## 🛠️ Tecnologias Utilizadas

- **Flutter & Dart**
- **SQLite (sqflite)**: Banco de dados local para persistência.
- **GetIt**: Gerenciamento de injeção de dependência.
- **Flutter Dotenv**: Gerenciamento de variáveis de ambiente.
- **Mocktail & sqflite_common_ffi**: Para testes unitários e de integração.

## 🔑 Acesso Inicial (Seed)

Na primeira execução do aplicativo, um administrador inicial é criado automaticamente:

- **E-mail:** `admin@biblioteca.com`
- **Senha:** `admin123`
- **Perfil:** `ADMIN_INICIAL`

## ♿ Acessibilidade

O projeto prioriza a acessibilidade através de:
- Tamanhos mínimos de toque (48x48dp).
- Propriedades semânticas em todos os elementos interativos.
- Contraste adequado conforme padrões WCAG.
- Suporte a leitores de tela.

## ⚙️ Como Executar

1. **Pré-requisitos**: Ter o Flutter SDK instalado e um simulador ou dispositivo físico conectado.
2. **Dependências**:
   ```bash
   flutter pub get
   ```
3. **Variáveis de Ambiente**: Certifique-se de que o arquivo `.env` existe na raiz do projeto.
4. **Execução**:
   ```bash
   flutter run
   ```

## 🧪 Testes

Para garantir a qualidade e prevenir regressões, o projeto conta com uma pirâmide de testes:
- **Unitários**: Regras de negócio nos UseCases.
- **Integração**: Persistência no SQLite.
- **Widget**: Interface e Acessibilidade.

Execute os testes com:
```bash
flutter test
```

---
Desenvolvido como parte das especificações do Sistema Mobile de Biblioteca.
