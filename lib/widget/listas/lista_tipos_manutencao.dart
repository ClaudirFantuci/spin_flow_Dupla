import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_tipo_manutencao.dart';
import 'package:spin_flow/dto/dto_tipo_manutencao.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaTiposManutencao extends StatefulWidget {
  const ListaTiposManutencao({super.key});

  @override
  State<ListaTiposManutencao> createState() => _ListaTiposManutencaoState();
}

class _ListaTiposManutencaoState extends State<ListaTiposManutencao> {
  List<DTOTipoManutencao> _tipos = [];
  bool _carregando = true;
  final DAOTipoManutencao _daoTipo = DAOTipoManutencao();

  @override
  void initState() {
    super.initState();
    _carregarTipos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Manutenção'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _tipos.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _tipos.length,
                  itemBuilder: (context, index) => _itemListaTipo(_tipos[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOTipoManutencao tipo) {
    return tipo.nome;
  }

  String _definirDetalhesDescricao(DTOTipoManutencao tipo) {
    final descricao = (tipo.descricao != null && tipo.descricao!.isNotEmpty)
        ? '${tipo.descricao!}\n'
        : '';
    final status = tipo.ativa ? 'Ativo' : 'Inativo';
    return '$descricao$status';
  }

  Future<void> _carregarTipos() async {
    setState(() {
      _carregando = true;
    });
    try {
      final tipos = await _daoTipo.buscarTodos();
      setState(() {
        _tipos = tipos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar tipos de manutenção: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirTipo(DTOTipoManutencao tipo) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o tipo "${tipo.nome}"?'),
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
        await _daoTipo.excluir(tipo.id!);
        await _carregarTipos();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tipo "${tipo.nome}" excluído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir tipo: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarTipo(DTOTipoManutencao tipo) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroTipoManutencao,
      arguments: tipo,
    ).then((_) => _carregarTipos());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.build_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhum tipo de manutenção cadastrado', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaTipo(DTOTipoManutencao tipo) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tipo.ativa ? Colors.green : Colors.grey,
          child: const Icon(Icons.build, color: Colors.white),
        ),
        title: Text(_definirDescricao(tipo)),
        subtitle: Text(_definirDetalhesDescricao(tipo)),
        trailing: _painelBotoesItem(tipo),
      ),
    );
  }

  Widget _painelBotoesItem(DTOTipoManutencao tipo) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarTipo(tipo),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirTipo(tipo),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroTipoManutencao)
          .then((_) => _carregarTipos()),
      tooltip: 'Adicionar Tipo',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarTipos,
      tooltip: 'Recarregar',
    );
  }
} 