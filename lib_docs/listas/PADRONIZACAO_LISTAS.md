# Padronização de Listas Flutter

Este documento define o padrão para implementação de listas no projeto, visando clareza, manutenção, experiência do usuário e facilidade de extensão.

---

## 1. Estrutura Básica

- Widget principal: `StatefulWidget`.
- Métodos obrigatórios:
  - `_carregarDados()` — Carrega os dados da lista.
  - `_excluirItem()` — Exclui um item, com confirmação.
  - `_editarItem()` — Navega para tela de edição/cadastro.
- Variáveis e métodos com nomes em português, claros e autoexplicativos.
- Evitar comentários desnecessários: o código deve ser autoexplicativo.

---

## 2. Layout Padrão

- `Scaffold` com:
  - `AppBar` (título, botão de recarregar/refresh)
  - Corpo:
    - Loading: `CircularProgressIndicator`
    - Vazio: ícone, mensagem amigável, botão de adicionar
    - Lista: `ListView.builder` com `Card` e `ListTile`
  - `FloatingActionButton` para adicionar novo item

---

## 3. Tratamento de Carregamento, Erro e Vazio

- Loading: mostrar indicador central.
- Erro: mostrar `SnackBar` com mensagem clara.
- Lista vazia: mostrar ícone, mensagem e botão de adicionar.

---

## 4. Recarregamento

- Botão de refresh sempre presente no `AppBar`.
- Após adicionar/editar/excluir, recarregar a lista automaticamente.

---

## 5. Exclusão com Confirmação

- Sempre usar `showDialog` para confirmar exclusão.
- Exemplo:

```dart
final confirmacao = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Confirmar Exclusão'),
    content: Text('Deseja realmente excluir o item?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Cancelar'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: TextButton.styleFrom(foregroundColor: Colors.red),
        child: const Text('Excluir'),
      ),
    ],
  ),
);
```

---

## 6. Componentização

- Criar widget reutilizável para estado vazio (ícone, texto, botão).
- Se muitos cards/list tiles forem parecidos, criar widget customizado para eles.

---

## 7. Sequência de Funcionalidades

1. Carregamento inicial no `initState`.
2. Exibição de loading, erro ou lista.
3. Ações de editar/excluir/navegar.
4. Atualização automática após operações.

---

## 8. Exemplo de Estrutura

```dart
class ListaExemplo extends StatefulWidget {
  const ListaExemplo({super.key});

  @override
  State<ListaExemplo> createState() => _ListaExemploState();
}

class _ListaExemploState extends State<ListaExemplo> {
  List<DTOExemplo> _itens = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      // Buscar dados
      setState(() {
        _itens = await dao.buscarTodos();
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _excluirItem(DTOExemplo item) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmacao == true) {
      // Excluir do DAO
      await dao.excluir(item.id);
      _carregarDados();
    }
  }

  void _editarItem(DTOExemplo item) {
    Navigator.pushNamed(context, '/editar', arguments: item)
      .then((_) => _carregarDados());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _itens.isEmpty
              ? EstadoVazioWidget(
                  mensagem: 'Nenhum item cadastrado',
                  onAdicionar: () => Navigator.pushNamed(context, '/novo')
                      .then((_) => _carregarDados()),
                )
              : ListView.builder(
                  itemCount: _itens.length,
                  itemBuilder: (context, index) {
                    final item = _itens[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.nome),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editarItem(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _excluirItem(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/novo')
            .then((_) => _carregarDados()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## 9. Observações

- Para listas com dependências, garantir que o DTO já traga os dados prontos para exibição.
- Se necessário buscar múltiplas dependências, usar `Future.wait` no carregamento.
- Sempre priorizar clareza, nomes sugestivos e modularização local. 