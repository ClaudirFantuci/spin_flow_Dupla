import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_categoria_musica.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaCategoriasMusica extends StatefulWidget {
  const ListaCategoriasMusica({super.key});

  @override
  State<ListaCategoriasMusica> createState() => _ListaCategoriasMusicaState();
}

class _ListaCategoriasMusicaState extends State<ListaCategoriasMusica> {
  List<DTOCategoriaMusica> _categorias = [];
  bool _carregando = true;
  final DAOCategoriaMusica _daoCategoria = DAOCategoriaMusica();

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias de Música'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _categorias.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _categorias.length,
                  itemBuilder: (context, index) => _itemListaCategoria(_categorias[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOCategoriaMusica categoria) {
    return categoria.nome;
  }

  String _definirDetalhesDescricao(DTOCategoriaMusica categoria) {
    return categoria.ativa ? 'Ativa' : 'Inativa';
  }

  Future<void> _carregarCategorias() async {
    setState(() {
      _carregando = true;
    });
    try {
      final categorias = await _daoCategoria.buscarTodos();
      setState(() {
        _categorias = categorias;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar categorias: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirCategoria(DTOCategoriaMusica categoria) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir a categoria "${categoria.nome}"?'),
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
      try {
        await _daoCategoria.excluir(categoria.id!);
        await _carregarCategorias();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Categoria "${categoria.nome}" excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir categoria: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarCategoria(DTOCategoriaMusica categoria) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroCategoriaMusica,
      arguments: categoria,
    ).then((_) => _carregarCategorias());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.category_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhuma categoria cadastrada', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaCategoria(DTOCategoriaMusica categoria) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: categoria.ativa ? Colors.green : Colors.grey,
          child: const Icon(Icons.category, color: Colors.white),
        ),
        title: Text(_definirDescricao(categoria)),
        subtitle: Text(_definirDetalhesDescricao(categoria)),
        trailing: _painelBotoesItem(categoria),
      ),
    );
  }

  Widget _painelBotoesItem(DTOCategoriaMusica categoria) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarCategoria(categoria),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirCategoria(categoria),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroCategoriaMusica)
          .then((_) => _carregarCategorias()),
      tooltip: 'Adicionar Categoria',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarCategorias,
      tooltip: 'Recarregar',
    );
  }
} 