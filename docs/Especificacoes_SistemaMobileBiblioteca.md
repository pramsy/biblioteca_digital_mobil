# Especificação do projeto

## /lib/app/app.dart
- ação: criar
- descrição
  - Inicializar a aplicação Flutter com tema global, configuração de rotas e ponto único de entrada da interface.
- pseudocódigo
```text
ao iniciar a aplicação
  carregar configurações globais
  aplicar tema visual padrão
  registrar rotas principais
  renderizar a tela inicial
fim
```

## /lib/main.dart
- ação: criar
- descrição
  - Executar a aplicação e delegar a inicialização para a camada de app.
- pseudocódigo
```text
iniciar framework Flutter
garantir inicialização de bindings
invocar App principal
fim
```

## /lib/app/routes/
- ação: criar
- descrição
  - Centralizar a definição das rotas nomeadas e o mapeamento entre telas.
- pseudocódigo
```text
definir constante de cada rota
associar rota à respectiva tela
validar existência da rota antes da navegação
```

## /lib/app/theme/
- ação: criar
- descrição
  - Definir cores, tipografia, espaçamentos e padrões visuais com contraste adequado.
- pseudocódigo
```text
definir paleta principal
definir tipografia acessível
definir estilos de botões, campos e cards
aplicar padrões responsivos
```

## /lib/app/config/
- ação: criar
- descrição
  - Armazenar configurações gerais do aplicativo, como ambiente, versão e parâmetros iniciais.
- pseudocódigo
```text
ler variáveis de configuração
validar presença dos valores obrigatórios
disponibilizar configurações para o restante do sistema
```

## /lib/core/constants/
- ação: criar
- descrição
  - Declarar valores fixos do sistema, como nomes de perfis, estados e mensagens padrão.
- pseudocódigo
```text
definir constantes imutáveis
centralizar textos e códigos reutilizáveis
evitar valores literais repetidos
```

## /lib/core/errors/
- ação: criar
- descrição
  - Padronizar erros da aplicação para validação, acesso a dados e regras de negócio.
- pseudocódigo
```text
criar tipos de erro por categoria
armazenar mensagem técnica e mensagem amigável
lançar erro específico conforme a falha
```

## /lib/core/utils/
- ação: criar
- descrição
  - Disponibilizar utilitários comuns, como formatação de datas, validação genérica e normalização de texto.
- pseudocódigo
```text
implementar funções puras reutilizáveis
manter utilitários sem dependência de interface
usar em vários módulos conforme necessário
```

## /lib/core/accessibility/
- ação: criar
- descrição
  - Consolidar recursos de acessibilidade como rótulos, semântica, foco visível e tamanhos mínimos de toque.
- pseudocódigo
```text
definir padrões acessíveis reutilizáveis
aplicar semântica em componentes interativos
validar contraste, foco e leitura por tela
```

## /lib/core/services/
- ação: criar
- descrição
  - Agrupar serviços transversais do sistema, como autenticação, banco e suporte à navegação.
- pseudocódigo
```text
definir contrato de cada serviço
implementar comportamento centralizado
fornecer acesso às funcionalidades comuns
```

## /lib/core/services/DatabaseService.dart
- ação: criar
- descrição
  - Inicializar e gerenciar o acesso ao SQLite local.
- pseudocódigo
```text
abrir banco SQLite
verificar versão do esquema
criar tabelas se não existirem
disponibilizar conexão para repositórios
```

## /lib/core/services/SeedService.dart
- ação: criar
- descrição
  - Garantir a criação do administrador inicial e dados obrigatórios da primeira execução.
- pseudocódigo
```text
verificar se existe administrador inicial
se não existir
  criar usuário administrador padrão
  marcar como obrigatório para primeiro acesso
fim
```

## /lib/core/services/AuthService.dart
- ação: criar
- descrição
  - Controlar autenticação, sessão atual e encerramento de acesso.
- pseudocódigo
```text
receber credenciais
validar usuário e senha
criar sessão autenticada
encerrar sessão ao sair
```

## /lib/core/services/NavigationService.dart
- ação: criar
- descrição
  - Permitir navegação desacoplada entre telas quando necessário.
- pseudocódigo
```text
registrar chave global de navegação
executar navegação por rota nomeada
permitir retorno para tela anterior
```

## /lib/core/services/AccessibilityService.dart
- ação: criar
- descrição
  - Padronizar recursos de acessibilidade aplicados à interface.
- pseudocódigo
```text
definir propriedades semânticas
validar tamanhos mínimos de toque
apoiar ajuste de fonte e contraste
```

## /lib/data/database/
- ação: criar
- descrição
  - Concentrar a configuração física do banco SQLite, migrações e criação de tabelas.
- pseudocódigo
```text
definir esquema do banco
registrar migrações
executar criação inicial das tabelas
```

## /lib/data/datasources/
- ação: criar
- descrição
  - Implementar acesso local aos dados persistidos no SQLite por entidade.
- pseudocódigo
```text
consultar banco
inserir registros
atualizar registros
remover logicamente quando aplicável
```

## /lib/data/models/
- ação: criar
- descrição
  - Declarar modelos de dados para usuários, livros, solicitações e empréstimos.
- pseudocódigo
```text
mapear entidade para estrutura de dados
converter de objeto para banco
converter de banco para objeto
```

## /lib/data/repositories/
- ação: criar
- descrição
  - Implementar repositórios concretos responsáveis pelo acesso aos dados.
- pseudocódigo
```text
receber solicitação da camada de domínio
delegar para datasource adequado
retornar resultado tratado
```

## /lib/domain/entities/
- ação: criar
- descrição
  - Definir entidades centrais do domínio, sem dependência de interface ou banco.
- pseudocódigo
```text
criar entidade para usuário
criar entidade para livro
criar entidade para solicitação
criar entidade para empréstimo
```

## /lib/domain/repositories/
- ação: criar
- descrição
  - Definir contratos de repositório para uso pelos casos de uso.
- pseudocódigo
```text
declarar operações obrigatórias
expor apenas assinaturas
não acoplar à implementação de dados
```

## /lib/domain/usecases/
- ação: criar
- descrição
  - Concentrar as regras de negócio em ações determinísticas do sistema.
- pseudocódigo
```text
validar entrada
aplicar regra de negócio
chamar repositório
retornar resultado ou erro
```

## /lib/domain/usecases/EnviarSolicitacaoUseCase.dart
- ação: criar
- descrição
  - Registrar uma solicitação feita por leitor autenticado.
- pseudocódigo
```text
receber tipo, assunto, descrição e prioridade
validar campos obrigatórios
verificar autenticidade do leitor
salvar solicitação com status inicial aberta
retornar protocolo
```

## /lib/domain/usecases/ResponderSolicitacaoUseCase.dart
- ação: criar
- descrição
  - Registrar resposta de editor ou administrador em uma solicitação.
- pseudocódigo
```text
receber id da solicitação e resposta
validar permissão do usuário
atualizar conteúdo e status
registrar data e autor da resposta
```

## /lib/domain/usecases/CadastrarEditorUseCase.dart
- ação: criar
- descrição
  - Criar editor somente quando executado por administrador autenticado.
- pseudocódigo
```text
receber dados do editor
validar perfil do executor
validar campos obrigatórios
salvar editor com perfil apropriado
```

## /lib/domain/usecases/CadastrarUsuarioUseCase.dart
- ação: criar
- descrição
  - Criar usuário conforme regras de perfil, incluindo autocadastro de leitor.
- pseudocódigo
```text
receber dados do usuário
identificar perfil solicitado
aplicar regra específica do perfil
salvar usuário se válido
```

## /lib/domain/usecases/AtualizarUsuarioUseCase.dart
- ação: criar
- descrição
  - Atualizar dados cadastrais de usuário conforme permissões.
- pseudocódigo
```text
receber id e novos dados
validar permissão
validar existência do usuário
persistir alterações permitidas
```

## /lib/domain/usecases/InativarUsuarioUseCase.dart
- ação: criar
- descrição
  - Inativar usuário sem exclusão física do registro.
- pseudocódigo
```text
receber id do usuário
validar permissão administrativa
alterar status para inativo
manter histórico do registro
```

## /lib/domain/usecases/CadastrarLivroUseCase.dart
- ação: criar
- descrição
  - Inserir novo livro no acervo com validação dos campos essenciais.
- pseudocódigo
```text
receber dados do livro
validar título, autor e categoria
salvar livro
definir quantidade e status inicial
```

## /lib/domain/usecases/AtualizarLivroUseCase.dart
- ação: criar
- descrição
  - Alterar dados de livro existente no acervo.
- pseudocódigo
```text
receber id do livro e novos dados
validar existência
aplicar alterações permitidas
salvar atualização
```

## /lib/domain/usecases/InativarLivroUseCase.dart
- ação: criar
- descrição
  - Marcar livro como inativo sem excluir o histórico operacional.
- pseudocódigo
```text
receber id do livro
validar permissão
marcar registro como inativo
preservar histórico de empréstimos
```

## /lib/domain/usecases/RegistrarEmprestimoUseCase.dart
- ação: criar
- descrição
  - Registrar locação ou empréstimo de exemplar disponível para leitor autenticado.
- pseudocódigo
```text
receber leitor e livro
verificar disponibilidade do exemplar
validar elegibilidade do leitor
registrar empréstimo e datas
atualizar status para emprestado
```

## /lib/domain/usecases/RegistrarDevolucaoUseCase.dart
- ação: criar
- descrição
  - Registrar devolução de empréstimo e restabelecer disponibilidade do exemplar.
- pseudocódigo
```text
receber id do empréstimo
validar empréstimo ativo
registrar data de devolução
alterar status do exemplar para disponível
```

## /lib/domain/usecases/RenovarEmprestimoUseCase.dart
- ação: criar
- descrição
  - Renovar empréstimo quando a regra permitir.
- pseudocódigo
```text
receber id do empréstimo
validar elegibilidade para renovação
atualizar nova data prevista de devolução
salvar alteração
```

## /lib/domain/usecases/GerarRelatoriosUseCase.dart
- ação: criar
- descrição
  - Consolidar dados gerenciais para uso administrativo.
- pseudocódigo
```text
receber filtros de relatório
validar perfil administrativo
consultar dados no banco
agrupar informações e retornar resultado
```

## /lib/features/auth/
- ação: criar
- descrição
  - Concentrar as telas e fluxos de autenticação.
- pseudocódigo
```text
exibir login
validar credenciais
abrir sessão
redirecionar conforme perfil
```

## /lib/features/usuarios/
- ação: criar
- descrição
  - Concentrar o gerenciamento de usuários, incluindo cadastro, consulta, edição e inativação.
- pseudocódigo
```text
listar usuários
abrir formulário de cadastro
salvar alterações
inativar quando solicitado
```

## /lib/features/solicitacoes/
- ação: criar
- descrição
  - Concentrar o envio, consulta e resposta de solicitações.
- pseudocódigo
```text
exibir lista de solicitações
abrir formulário de nova solicitação
registrar resposta
atualizar status
```

## /lib/features/catalogo/
- ação: criar
- descrição
  - Exibir e permitir a consulta do catálogo de livros.
- pseudocódigo
```text
carregar lista de livros
aplicar filtros de busca
exibir detalhes do livro
mostrar disponibilidade
```

## /lib/features/emprestimos/
- ação: criar
- descrição
  - Gerenciar solicitação, registro, devolução, renovação e histórico de empréstimos.
- pseudocódigo
```text
listar empréstimos do usuário
registrar novo empréstimo
executar devolução
permitir renovação quando válida
```

## /lib/features/relatorios/
- ação: criar
- descrição
  - Exibir relatórios gerenciais filtráveis para administradores.
- pseudocódigo
```text
selecionar filtro
consultar dados consolidados
apresentar indicadores em tela
```

## /lib/features/dashboard/
- ação: criar
- descrição
  - Apresentar visão inicial com atalhos e indicadores principais por perfil.
- pseudocódigo
```text
identificar perfil do usuário
carregar indicadores permitidos
exibir atalhos relevantes
```

## /assets/images/
- ação: criar
- descrição
  - Armazenar imagens do aplicativo, como ícones ilustrativos e elementos visuais.
- pseudocódigo
```text
salvar arquivos de imagem
referenciar imagens nas telas
carregar conforme necessidade da interface
```

## /assets/icons/
- ação: criar
- descrição
  - Armazenar ícones utilizados na navegação e nas ações da aplicação.
- pseudocódigo
```text
salvar ícones padronizados
associar ícones aos botões e menus
manter consistência visual
```

## /assets/fonts/
- ação: criar
- descrição
  - Armazenar fontes customizadas, se adotadas no projeto.
- pseudocódigo
```text
registrar arquivos de fonte
configurar uso no tema
aplicar em toda a interface
```

## /docs/
- ação: criar
- descrição
  - Guardar documentação complementar, diagramas e registros do projeto.
- pseudocódigo
```text
salvar documentação técnica
organizar requisitos e diagramas
manter histórico do projeto
```

## /pubspec.yaml
- ação: modificar
- descrição
  - Declarar dependências, assets, fontes e configuração do pacote Flutter.
- pseudocódigo
```text
listar dependências do projeto
registrar caminhos de assets
registrar fontes e metadados
```

## /.gitignore
- ação: modificar
- descrição
  - Excluir arquivos temporários, de build e dados não versionáveis.
- pseudocódigo
```text
definir padrões ignorados
incluir artefatos de build
excluir arquivos locais sensíveis
```

## /.env
- ação: criar
- descrição
  - Armazenar parâmetros de ambiente do aplicativo local, sem dados sensíveis reais.
- pseudocódigo
```text
definir valores de ambiente
separar configurações por contexto
carregar variáveis na inicialização
```

## /README.md
- ação: criar
- descrição
  - Documentar execução, estrutura, dependências e regras principais do projeto.
- pseudocódigo
```text
descrever objetivo do sistema
informar como executar o projeto
listar tecnologias e convenções
```