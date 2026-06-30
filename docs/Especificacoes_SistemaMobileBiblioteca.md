# Especificação do Projeto - Biblioteca Digital (Refinamento de Interface)

## 1. Visão Geral
Sistema mobile para gestão de acervo bibliotecário, focado em acessibilidade, controle hierárquico e excelência na experiência do usuário (UX).

## 2. Padrões de Interface e Design System
- **Design System**: Baseado em Material Design 3.
- **Cores**: Semente `deepPurple`. Contraste mínimo de 4.5:1 (WCAG AA).
- **Espaçamento**: Grid de 8dp. Padding padrão de telas: 16dp ou 24dp para formulários.
- **Tipografia**: Uso de estilos nativos do `Theme.of(context).textTheme` para garantir escalabilidade de fonte.
- **Componentes Reutilizáveis**:
    - `ElevatedButton`: Altura mínima de 48dp.
    - `TextFormField`: Com ícones de prefixo e mensagens de erro descritivas ("Intervenção").
    - `Card`: Para itens de lista com elevação sutil.

## 3. Estados de Tela e Feedbacks
- **Carregamento (Loading)**: Uso de `CircularProgressIndicator` centralizado ou Skeletons durante chamadas assíncronas.
- **Estado Vazio (Empty State)**: Mensagens centralizadas com ícones quando não houver dados (ex: "Nenhum livro encontrado").
- **Erro (Error State)**: Snackbars flutuantes com cores semânticas (Vermelho para erro, Laranja para avisos, Verde para sucesso).
- **Validação de Formulários**: Validação visual imediata ao perder o foco ou ao submeter, impedindo o envio de dados inválidos.

## 4. Acessibilidade (Obrigatório)
- **Semântica**: Atribuição de `Semantics` em todos os elementos interativos e imagens decorativas (excluir do leitor).
- **Toque**: Áreas clicáveis com no mínimo 48x48dp.
- **Navegação**: Ordem de foco lógica (topo para baixo, esquerda para direita).

## 5. Fluxos de Navegação e Regras de Renderização
- **Autenticação**: Redirecionamento condicional pós-login baseado no perfil.
- **Dashboard Dinâmico**: 
    - Renderização condicional de menus baseada em permissões:
        - `ADMIN_INICIAL`: Acesso total + Cadastro de Admin.
        - `ADMIN`: Gestão de usuários e acervo (exceto criar Admins).
        - `BIBLIOTECARIO`: Gestão técnica de acervo e solicitações.
        - `LEITOR`: Consulta e empréstimo.
- **Catálogo**: Busca em tempo real com debounce (opcional) e feedback de "nenhum resultado".

## 6. Arquitetura de Apresentação
- **Separação de Camadas**:
    - `Features/UI`: Widgets de apresentação.
    - `Domain/UseCases`: Lógica de transição de estados e regras.
    - `App/Routes`: Desacoplamento da navegação.
