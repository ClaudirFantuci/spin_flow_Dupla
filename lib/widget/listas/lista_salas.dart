import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_sala.dart';
import 'package:spin_flow/dto/dto_sala.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaSalas extends StatefulWidget {
  const ListaSalas({super.key});

  @override
  State<ListaSalas> createState() => _ListaSalasState();
}

class _ListaSalasState extends State<ListaSalas> {
  List<DTOSala> _salas = [];
  bool _carregando = true;
  final DAOSala _daoSala = DAOSala();

  @override
  void initState() {
    super.initState();
    _carregarSalas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salas'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _salas.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _salas.length,
                  itemBuilder: (context, index) =>
                      _itemListaSala(_salas[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOSala sala) {
    return sala.nome;
  }

  String _definirDetalhesDescricao(DTOSala sala) {
    return 'Bikes: ${sala.numeroBikes}\nFilas: ${sala.numeroFilas}\nLimite por fila: ${sala.limiteBikesPorFila}\n'
        '${sala.ativa ? 'Ativa' : 'Inativa'}';
  }

  Future<void> _carregarSalas() async {
    setState(() {
      _carregando = true;
    });
    try {
      final salas = await _daoSala.buscarTodos();
      setState(() {
        _salas = salas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar salas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirSala(DTOSala sala) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir a sala "${sala.nome}"?'),
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
        await _daoSala.excluir(sala.id!);
        await _carregarSalas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sala "${sala.nome}" excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir sala: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarSala(DTOSala sala) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroSala,
      arguments: sala,
    ).then((_) => _carregarSalas());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.room_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhuma sala cadastrada',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaSala(DTOSala sala) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: sala.ativa ? Colors.green : Colors.grey,
          child: const Icon(Icons.room, color: Colors.white),
        ),
        title: Text(_definirDescricao(sala)),
        subtitle: Text(_definirDetalhesDescricao(sala)),
        trailing: _painelBotoesItem(sala),
      ),
    );
  }

  Widget _painelBotoesItem(DTOSala sala) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarSala(sala),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirSala(sala),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroSala)
          .then((_) => _carregarSalas()),
      tooltip: 'Adicionar Sala',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarSalas,
      tooltip: 'Recarregar',
    );
  }
}
