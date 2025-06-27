import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_grupos_alunos.dart';
import 'package:spin_flow/dto/dto_grupo_alunos.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaGruposAlunos extends StatefulWidget {
  const ListaGruposAlunos({super.key});

  @override
  State<ListaGruposAlunos> createState() => _ListaGruposAlunosState();
}

class _ListaGruposAlunosState extends State<ListaGruposAlunos> {
  List<DTOGrupoAlunos> _grupos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarGrupos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos de Alunos'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _grupos.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _grupos.length,
                  itemBuilder: (context, index) => _itemListaGrupo(_grupos[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOGrupoAlunos grupo) {
    return grupo.nome;
  }

  String _definirDetalhesDescricao(DTOGrupoAlunos grupo) {
    final descricao = (grupo.descricao != null && grupo.descricao!.isNotEmpty)
        ? 'Descrição: ${grupo.descricao}\n'
        : '';
    final alunos = 'Alunos: ${grupo.alunos.length}\n';
    final status = grupo.ativo ? 'Ativo' : 'Inativo';
    return '$descricao$alunos$status';
  }

  Future<void> _carregarGrupos() async {
    setState(() {
      _carregando = true;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final grupos = mockGruposAlunos;
      setState(() {
        _grupos = grupos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar grupos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirGrupo(DTOGrupoAlunos grupo) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o grupo "${grupo.nome}"?'),
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
          _grupos.removeWhere((g) => g.id == grupo.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Grupo "${grupo.nome}" excluído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir grupo: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarGrupo(DTOGrupoAlunos grupo) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroGrupoAlunos,
      arguments: grupo,
    ).then((_) => _carregarGrupos());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group_work_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhum grupo cadastrado', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaGrupo(DTOGrupoAlunos grupo) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: grupo.ativo ? Colors.green : Colors.grey,
          child: const Icon(Icons.group_work, color: Colors.white),
        ),
        title: Text(_definirDescricao(grupo)),
        subtitle: Text(_definirDetalhesDescricao(grupo)),
        trailing: _painelBotoesItem(grupo),
      ),
    );
  }

  Widget _painelBotoesItem(DTOGrupoAlunos grupo) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarGrupo(grupo),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirGrupo(grupo),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroGrupoAlunos)
          .then((_) => _carregarGrupos()),
      tooltip: 'Adicionar Grupo',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarGrupos,
      tooltip: 'Recarregar',
    );
  }
} 