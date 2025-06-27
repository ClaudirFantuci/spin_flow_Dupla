import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_turmas.dart';
import 'package:spin_flow/dto/dto_turma.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaTurmas extends StatefulWidget {
  const ListaTurmas({super.key});

  @override
  State<ListaTurmas> createState() => _ListaTurmasState();
}

class _ListaTurmasState extends State<ListaTurmas> {
  List<DTOTurma> _turmas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTurmas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _turmas.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _turmas.length,
                  itemBuilder: (context, index) => _itemListaTurma(_turmas[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOTurma turma) {
    return turma.nome;
  }

  String _definirDetalhesDescricao(DTOTurma turma) {
    final descricao = (turma.descricao != null && turma.descricao!.isNotEmpty)
        ? 'Descrição: ${turma.descricao}\n'
        : '';
    final sala = 'Sala: ${turma.sala.nome}\n';
    final horario = 'Horário: ${turma.horarioInicio} (${turma.duracaoMinutos} min)\n';
    final dias = turma.diasSemana.isNotEmpty ? 'Dias: ${turma.diasSemana.join(', ')}\n' : '';
    final status = turma.ativo ? 'Ativa' : 'Inativa';
    return '$descricao$sala$horario$dias$status';
  }

  Future<void> _carregarTurmas() async {
    setState(() {
      _carregando = true;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final turmas = mockTurmas;
      setState(() {
        _turmas = turmas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar turmas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirTurma(DTOTurma turma) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir a turma "${turma.nome}"?'),
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
          _turmas.removeWhere((t) => t.id == turma.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Turma "${turma.nome}" excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir turma: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarTurma(DTOTurma turma) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroTurma,
      arguments: turma,
    ).then((_) => _carregarTurmas());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.groups_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhuma turma cadastrada', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaTurma(DTOTurma turma) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: turma.ativo ? Colors.green : Colors.grey,
          child: const Icon(Icons.groups, color: Colors.white),
        ),
        title: Text(_definirDescricao(turma)),
        subtitle: Text(_definirDetalhesDescricao(turma)),
        trailing: _painelBotoesItem(turma),
      ),
    );
  }

  Widget _painelBotoesItem(DTOTurma turma) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarTurma(turma),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirTurma(turma),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroTurma)
          .then((_) => _carregarTurmas()),
      tooltip: 'Adicionar Turma',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarTurmas,
      tooltip: 'Recarregar',
    );
  }
} 