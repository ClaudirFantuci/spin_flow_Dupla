# Padronização da Ordem de Atributos e Métodos em Widgets/Componentes Flutter

Este documento define a ordem padronizada para declaração de atributos e métodos em widgets e componentes Flutter do projeto, visando facilitar a leitura, manutenção, extensão e padronização do código.

---

## Ordem Recomendada

### 1. **Atributos públicos (final)**
- Todos os atributos recebidos pelo construtor, na ordem de importância/uso (ex: controladores, valores, rótulo, obrigatoriedade, callbacks).

### 2. **Construtor**
- Sempre logo após os atributos, com parâmetros nomeados e obrigatórios primeiro.

### 3. **Métodos override**
- Todos os métodos override do ciclo de vida do widget, **nesta ordem**:
  - `initState`
  - `didChangeDependencies`
  - `didUpdateWidget`
  - `dispose`
  - `build`

### 4. **Métodos públicos mais significativos**
- Métodos que podem ser chamados de fora (raros em campos, mas se houver, vêm aqui).

### 5. **Métodos privados mais importantes/configuráveis**
- Métodos que afetam diretamente a configuração, validação, formatação, transformação de dados, etc.
- Exemplos: `_validar`, `_formatar`, `_parseValorInicial`, `_converterParaDTO`, etc.

### 6. **Métodos privados auxiliares/menos usados**
- Métodos de apoio, helpers, utilitários internos, navegação, etc.
- Exemplos: `_navegarParaCadastro`, helpers de UI, etc.

---

## Exemplo de Estrutura

```dart
class MeuCampo extends StatefulWidget {
  // 1. Atributos públicos
  final String rotulo;
  final bool obrigatorio;
  final TextEditingController? controle;
  final void Function(String)? onChanged;

  // 2. Construtor
  const MeuCampo({
    super.key,
    required this.rotulo,
    this.obrigatorio = true,
    this.controle,
    this.onChanged,
  });

  @override
  State<MeuCampo> createState() => _MeuCampoState();
}

class _MeuCampoState extends State<MeuCampo> {
  // 1. Atributos privados (se necessário)
  String? _valorInterno;

  // 3. Métodos override
  @override
  void initState() { ... }

  @override
  Widget build(BuildContext context) { ... }

  // 5. Métodos privados importantes
  String? _validar(String? valor) { ... }

  // 6. Métodos privados auxiliares
  void _navegarParaCadastro() { ... }
}
```

---

## Resumo Visual
1. **Atributos públicos**
2. **Construtor**
3. **Métodos override** (na ordem do ciclo de vida)
4. **Métodos públicos**
5. **Métodos privados importantes/configuráveis**
6. **Métodos privados auxiliares/menos usados**

---

## Observações
- Sempre use nomes de variáveis e métodos em português, claros e autoexplicativos.
- Evite comentários desnecessários: o código deve ser autoexplicativo.
- Modularize métodos privados para evitar métodos longos e facilitar manutenção.
- Siga esta ordem em todos os widgets e componentes do projeto.

---

**Este documento serve como referência para padronização e revisão de código.** 