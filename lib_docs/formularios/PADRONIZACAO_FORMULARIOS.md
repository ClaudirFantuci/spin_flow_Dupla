# Padronização de Formulários

Este documento define os padrões e boas práticas para a implementação de formulários no projeto.

---

## 1. Estrutura dos Formulários
- Cada formulário deve ser um `StatefulWidget` com seu respectivo `State`.
- Os métodos devem ser privados e bem nomeados, em português.
- Atributos, métodos override (`initState`, `dispose`, `build`) e métodos utilitários devem seguir esta ordem na classe:
  1. Atributos/variáveis de instância
  2. Métodos override
  3. Métodos privados/utilitários

---

## 2. Nomes de Métodos e Variáveis
- Sempre em português, claros e descritivos.
- Exemplos: `_carregarDadosEdicao`, `_preencherCampos`, `_limparCampos`, `_criarDTO`, `_mostrarMensagem`, `_redirecionarAposSalvar`, `_salvar`.

---

## 3. Controle de Carregamento/Edição
- Usar a variável `_dadosCarregados` para controlar o carregamento dos dados ao editar.
- Exibir um `CircularProgressIndicator` enquanto carrega.
- Exibir mensagem de erro se falhar ao carregar (`_erroCarregamento`).
- O método `_preencherCampos` deve ser usado para popular os campos na edição.

---

## 4. Limpeza e Preenchimento de Campos
- Sempre criar métodos privados para limpar (`_limparCampos`) e preencher (`_preencherCampos`) os campos.
- `_limparCampos` deve:
  - Chamar `.clear()` nos controllers.
  - Setar variáveis de seleção, datas, switches, listas para `null` ou valor padrão.
  - Chamar `_formKey.currentState?.reset()` se necessário.
- `_preencherCampos` deve:
  - Preencher todos os campos/variáveis a partir do DTO recebido.

---

## 5. Espaçamento e Layout
- Usar um único `Padding` externo para o formulário.
- Usar `const SizedBox(height: X)` entre os campos para espaçamento vertical.
- Não usar métodos utilitários para adicionar widgets com espaçamento, para manter a clareza e legibilidade.
- `ListView.separated` pode ser usado apenas para listas homogêneas.

---

## 6. Não uso de Interfaces para Métodos de Formulário
- Não criar interfaces (abstract classes) para métodos dos formulários.
- Cada formulário pode ter campos e lógicas diferentes, então interfaces só adicionariam complexidade desnecessária.
- Métodos devem ser privados e autoexplicativos dentro do próprio `State`.

---

## 7. Boas Práticas Gerais
- Remover comentários desnecessários e manter o código autoexplicativo.
- Usar `mounted` para evitar atualizações em widgets já removidos da tela após operações assíncronas.
- Priorizar clareza, legibilidade e padrão da comunidade Flutter.

---

## 8. Exemplo de Estrutura
```dart
class FormX extends StatefulWidget { ... }

class _FormXState extends State<FormX> {
  // Atributos
  final _formKey = GlobalKey<FormState>();
  // ... outros atributos

  // Métodos override
  @override
  void initState() { ... }
  @override
  void dispose() { ... }
  @override
  Widget build(BuildContext context) { ... }

  // Métodos privados/utilitários
  void _carregarDadosEdicao() { ... }
  void _preencherCampos(DTO dto) { ... }
  void _limparCampos() { ... }
  DTOX _criarDTO() { ... }
  void _mostrarMensagem(String mensagem, {bool erro = false}) { ... }
  void _redirecionarAposSalvar() { ... }
  Future<void> _salvar() async { ... }
}
```

---

## Padronização do Uso dos Métodos

Além de declarar os métodos padronizados, é obrigatório utilizá-los de forma centralizada e clara no fluxo do formulário. Ou seja, cada método (_carregarDadosEdicao, _preencherCampos, _limparCampos, _criarDTO, _mostrarMensagem, _redirecionarAposSalvar, _salvar_) deve ser chamado nos pontos apropriados do ciclo de vida do formulário, conforme exemplos:

- `_carregarDadosEdicao`: chamado no `initState` para carregar dados de edição.
- `_preencherCampos`: chamado dentro de `_carregarDadosEdicao` para preencher os campos a partir do DTO.
- `_limparCampos`: chamado após salvar um novo registro para limpar o formulário.
- `_criarDTO`: chamado dentro de `_salvar` para criar o DTO a partir dos campos.
- `_mostrarMensagem`: chamado em `_salvar` para feedback de sucesso ou erro.
- `_redirecionarAposSalvar`: chamado em `_salvar` para navegação após salvar.
- `_salvar`: chamado pelo botão de ação e AppBar.

A integração desses métodos deve ser explícita, evitando lógica duplicada ou dispersa. O objetivo é garantir clareza, manutenção e aderência ao padrão em todos os formulários.

**Mantenha este padrão para garantir código limpo, legível e fácil de manter!**

## Carregamento de Dependências em Formulários

Sempre que um formulário possuir componentes que dependem de dados externos (ex: dropdowns, multi-selects, autocompletes), deve ser implementado o método universal `_carregarDependencias`.

- O método `_carregarDependencias` deve ser chamado no `initState`, antes de `_carregarDadosEdicao`.
- O método pode ser `async` e usar `Future.wait` para múltiplas dependências.
- Em caso de erro, definir `_erroCarregamentoDependencias` e exibir mensagem clara ao usuário, orientando sobre o que fazer.
- O `build` deve tratar os estados: carregando dependências, erro de dependências, carregando dados do DTO, erro de DTO, formulário pronto.
- Para componentes multi-select, padronizar método de salvamento de associações, se necessário.
- Sempre seguir a sequência:
  1. `_carregarDependencias`
  2. `_carregarDadosEdicao`
  3. `_preencherCampos`
  4. `_limparCampos`
  5. `_criarDTO`
  6. `_mostrarMensagem`
  7. `_redirecionarAposSalvar`
  8. `_salvar`
- Mesmo que ainda não haja DAO implementado, manter a estrutura e sequência dos métodos para garantir clareza, manutenção e evolução futura.

### Diferença entre dependência única, múltipla e componentes multi-select
- **Dependência única:** `_carregarDependencias` faz await em um único carregamento.
- **Múltiplas dependências:** usar `Future.wait` para aguardar todas.
- **Componentes multi-select:** carregar opções no `_carregarDependencias` e, se necessário, padronizar método de salvamento de associações (ex: `_salvarAssociacoes`).

### Exemplo de uso no initState
```dart
@override
void initState() {
  super.initState();
  _carregarDependencias().then((_) {
    _carregarDadosEdicao();
  });
}
```

### Exemplo de tratamento no build
```dart
if (_carregandoDependencias) return CircularProgressIndicator();
if (_erroCarregamentoDependencias) return Text('Erro ao carregar dependências...');
``` 