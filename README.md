# Biblioteca Digital - Sistema Mobile

Sistema de gestão de biblioteca digital desenvolvido em Flutter, focado em acessibilidade e controle hierárquico, seguindo os princípios de Clean Architecture.

## 🚀 Objetivo do Projeto
O aplicativo fornece uma plataforma acessível para consulta de acervo, gestão de empréstimos e comunicação via solicitações, com um rigoroso controle de permissões por perfil.

## 👥 Perfis e Hierarquia
- **Administrador Inicial**: Único capaz de criar outros Administradores. Possui controle total do sistema.
- **Administrador**: Gerencia Bibliotecários e Leitores. Emite relatórios e acompanha perfis.
- **Bibliotecário**: Responsável pela gestão técnica do acervo (Livros) e atendimento de solicitações.
- **Leitor**: Realiza auto-cadastro, consulta o catálogo, faz empréstimos e envia solicitações.

## 🏗️ Arquitetura (Clean Architecture)
- **Camada de Domínio**: Entidades e Use Cases contendo as regras de negócio e hierarquia.
- **Camada de Dados**: Repositórios e Models utilizando SQLite para persistência local.
- **Camada de Apresentação**: Widgets Flutter com foco em Acessibilidade (Semantics, Focus, Contraste).

## 🔑 Acesso Inicial (Seed)
Na primeira execução, o sistema gera automaticamente:
- **E-mail:** `admin@biblioteca.com`
- **Senha:** `admin123`
- **Perfil:** `ADMIN_INICIAL`

## ♿ Acessibilidade
- Tamanho de toque mínimo de 48dp.
- Rótulos semânticos completos para leitores de tela.
- Contraste de texto validado (padrão WCAG).

## 🛠️ Como Executar
1. Instale as dependências: `flutter pub get`.
2. Configure o arquivo `.env` na raiz.
3. Execute o projeto: `flutter run`.

## 🧪 Testes Automatizados
O projeto utiliza uma pirâmide de testes para garantir a estabilidade:
- **Testes Unitários**: Validação de regras de negócio isoladas.
- **Testes de Integração**: Validação de persistência e transações no SQLite.
- **Testes de Widget**: Validação de interface e acessibilidade.

Execute com: `flutter test`

---
Documentação atualizada conforme a versão estável do sistema.
