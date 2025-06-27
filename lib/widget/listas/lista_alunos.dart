import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaAlunos extends StatefulWidget {
  const ListaAlunos({super.key});

  @override
  State<ListaAlunos> createState() => _ListaAlunosState();
}

class _ListaAlunosState extends State<ListaAlunos> {
  List<DTOAluno> _alunos = [];
  bool _carregando = true;
  final DAOAluno _daoAluno = DAOAluno();

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _alunos.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _alunos.length,
                  itemBuilder: (context, index) => _itemListaAluno(_alunos[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOAluno aluno) {
    return aluno.nome;
  }

  String _definirDetalhesDescricao(DTOAluno aluno) {
    return 'Email: ${aluno.email}\nTelefone: ${aluno.telefone}\nNascimento: ${aluno.dataNascimento.toString().split(' ')[0]}';
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhum aluno cadastrado', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaAluno(DTOAluno aluno) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: aluno.ativo ? Colors.green : Colors.grey,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(_definirDescricao(aluno)),
        subtitle: Text(_definirDetalhesDescricao(aluno)),
        trailing: _painelBotoesItem(aluno),
      ),
    );
  }

  Widget _painelBotoesItem(DTOAluno aluno) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarAluno(aluno),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirAluno(aluno),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroAluno)
          .then((_) => _carregarAlunos()),
      tooltip: 'Adicionar Aluno',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarAlunos,
      tooltip: 'Recarregar',
    );
  }

  Future<void> _carregarAlunos() async {
    setState(() {
      _carregando = true;
    });

    try {
      final alunos = await _daoAluno.buscarTodos();
      setState(() {
        _alunos = alunos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar alunos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirAluno(DTOAluno aluno) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o aluno "${aluno.nome}"?'),
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
        await _daoAluno.excluir(aluno.id!);
        await _carregarAlunos();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Aluno "${aluno.nome}" excluído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir aluno: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarAluno(DTOAluno aluno) {
    Navigator.pushNamed(
      context, 
      Rotas.cadastroAluno,
      arguments: aluno,
    ).then((_) => _carregarAlunos());
  }
} 