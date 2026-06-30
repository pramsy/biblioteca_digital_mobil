# Plano de Testes Mobile - Sistema de Biblioteca Digital (Foco em Interface)

## 1. Testes de Frontend e Componentes

### 1.1 Estados de Renderização
- **T-UI-STA-001**: Verificar exibição do `CircularProgressIndicator` durante o carregamento do catálogo.
- **T-UI-STA-002**: Validar mensagem de "Nenhum livro encontrado" ao realizar uma busca sem resultados.
- **T-UI-STA-003**: Garantir que o botão de "Salvar" em formulários fique desabilitado ou exiba loading durante o processamento.

### 1.2 Responsividade e Layout
- **T-UI-RES-001**: Verificar se a tela de Login é rolável em dispositivos com tela pequena (SingleChildScrollView).
- **T-UI-RES-002**: Validar se o texto de títulos longos no Catálogo não quebra o layout (uso de `Expanded` ou `Flexible`).

### 1.3 Acessibilidade (WCAG)
- **T-UI-ACC-001**: Validar se todos os botões possuem `Semantics` com descrições de ação claras.
- **T-UI-ACC-002**: Verificar se os campos de texto possuem rótulos (labels) lidos corretamente pelo TalkBack/VoiceOver.
- **T-UI-ACC-003**: Validar se a altura dos botões e áreas de toque é >= 48dp.

### 1.4 Validações e Erros
- **T-UI-ERR-001**: Tentar submeter formulário vazio e verificar se as mensagens "Intervenção: ..." aparecem nos campos.
- **T-UI-ERR-002**: Validar exibição de `Snackbar` vermelho em caso de erro no banco de dados.

## 2. Testes de Integração e Regras de Negócio
- **T-INT-ATH-001**: Login -> Dashboard (Redirecionamento correto por perfil).
- **T-INT-BOK-001**: Cadastro de Livro -> Atualização automática da lista no Catálogo.

## 3. Instruções de Execução
```bash
# Rodar todos os testes
flutter test

# Analisar qualidade do código e acessibilidade
flutter analyze
```
