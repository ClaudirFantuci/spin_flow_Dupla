import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_mixes.dart';
import 'package:spin_flow/dto/dto_mix.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaMixes extends StatefulWidget {
  const ListaMixes({super.key});

  @override
  State<ListaMixes> createState() => _ListaMixesState();
}

class _ListaMixesState extends State<ListaMixes> {
  List<DTOMix> _mixes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarMixes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mixes'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _mixes.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _mixes.length,
                  itemBuilder: (context, index) => _itemListaMix(_mixes[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOMix mix) {
    return mix.nome;
  }

  String _definirDetalhesDescricao(DTOMix mix) {
    final descricao = (mix.descricao != null && mix.descricao!.isNotEmpty)
        ? 'Descrição: ${mix.descricao}\n'
        : '';
    final musicas = 'Músicas: ${mix.musicas.length}\n';
    final inicio = 'Início: ${mix.dataInicio.toString().split(' ')[0]}\n';
    final fim = mix.dataFim != null ? 'Fim: ${mix.dataFim!.toString().split(' ')[0]}\n' : '';
    final status = mix.ativo ? 'Ativo' : 'Inativo';
    return '$descricao$musicas$inicio$fim$status';
  }

  Future<void> _carregarMixes() async {
    setState(() {
      _carregando = true;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final mixes = mockMixes;
      setState(() {
        _mixes = mixes;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar mixes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirMix(DTOMix mix) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o mix "${mix.nome}"?'),
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
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          _mixes.removeWhere((m) => m.id == mix.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mix "${mix.nome}" excluído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir mix: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarMix(DTOMix mix) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroMix,
      arguments: mix,
    ).then((_) => _carregarMixes());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.queue_music_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhum mix cadastrado', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaMix(DTOMix mix) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: mix.ativo ? Colors.green : Colors.grey,
          child: const Icon(Icons.queue_music, color: Colors.white),
        ),
        title: Text(_definirDescricao(mix)),
        subtitle: Text(_definirDetalhesDescricao(mix)),
        trailing: _painelBotoesItem(mix),
      ),
    );
  }

  Widget _painelBotoesItem(DTOMix mix) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarMix(mix),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirMix(mix),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroMix)
          .then((_) => _carregarMixes()),
      tooltip: 'Adicionar Mix',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarMixes,
      tooltip: 'Recarregar',
    );
  }
} 