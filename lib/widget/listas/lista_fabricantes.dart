import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_fabricante.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaFabricantes extends StatefulWidget {
  const ListaFabricantes({super.key});

  @override
  State<ListaFabricantes> createState() => _ListaFabricantesState();
}

class _ListaFabricantesState extends State<ListaFabricantes> {
  List<DTOFabricante> _fabricantes = [];
  bool _carregando = true;
  final DAOFabricante _daoFabricante = DAOFabricante();

  @override
  void initState() {
    super.initState();
    _carregarFabricantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fabricantes'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _fabricantes.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _fabricantes.length,
                  itemBuilder: (context, index) => _itemListaFabricante(_fabricantes[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOFabricante fabricante) {
    return fabricante.nome;
  }

  String _definirDetalhesDescricao(DTOFabricante fabricante) {
    final descricao = (fabricante.descricao != null && fabricante.descricao!.isNotEmpty)
        ? '${fabricante.descricao!}\n'
        : '';
    final status = fabricante.ativo ? 'Ativo' : 'Inativo';
    return '$descricao$status';
  }

  Future<void> _carregarFabricantes() async {
    setState(() {
      _carregando = true;
    });
    try {
      final fabricantes = await _daoFabricante.buscarTodos();
      setState(() {
        _fabricantes = fabricantes;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar fabricantes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirFabricante(DTOFabricante fabricante) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o fabricante "${fabricante.nome}"?'),
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
        await _daoFabricante.excluir(fabricante.id!);
        await _carregarFabricantes();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fabricante "${fabricante.nome}" excluído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir fabricante: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarFabricante(DTOFabricante fabricante) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroFabricante,
      arguments: fabricante,
    ).then((_) => _carregarFabricantes());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.factory_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhum fabricante cadastrado', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaFabricante(DTOFabricante fabricante) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: fabricante.ativo ? Colors.green : Colors.grey,
          child: const Icon(Icons.factory, color: Colors.white),
        ),
        title: Text(_definirDescricao(fabricante)),
        subtitle: Text(_definirDetalhesDescricao(fabricante)),
        trailing: _painelBotoesItem(fabricante),
      ),
    );
  }

  Widget _painelBotoesItem(DTOFabricante fabricante) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarFabricante(fabricante),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirFabricante(fabricante),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroFabricante)
          .then((_) => _carregarFabricantes()),
      tooltip: 'Adicionar Fabricante',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarFabricantes,
      tooltip: 'Recarregar',
    );
  }
} 