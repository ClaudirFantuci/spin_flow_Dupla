import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_musicas.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaMusicas extends StatefulWidget {
  const ListaMusicas({super.key});

  @override
  State<ListaMusicas> createState() => _ListaMusicasState();
}

class _ListaMusicasState extends State<ListaMusicas> {
  List<DTOMusica> _musicas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarMusicas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Músicas'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _musicas.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _musicas.length,
                  itemBuilder: (context, index) => _itemListaMusica(_musicas[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOMusica musica) {
    return musica.nome;
  }

  String _definirDetalhesDescricao(DTOMusica musica) {
    final artista = 'Artista: ${musica.artista.nome}\n';
    final categorias = 'Categorias: ${musica.categorias.map((c) => c.nome).join(', ')}\n';
    final descricao = (musica.descricao != null && musica.descricao!.isNotEmpty)
        ? 'Descrição: ${musica.descricao}\n'
        : '';
    final videos = musica.linksVideoAula.isNotEmpty ? 'Vídeos: ${musica.linksVideoAula.length}\n' : '';
    final status = musica.ativo ? 'Ativa' : 'Inativa';
    return '$artista$categorias$descricao$videos$status';
  }

  Future<void> _carregarMusicas() async {
    setState(() {
      _carregando = true;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final musicas = mockMusicas;
      setState(() {
        _musicas = musicas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar músicas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirMusica(DTOMusica musica) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir a música "${musica.nome}"?'),
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
          _musicas.removeWhere((m) => m.id == musica.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Música "${musica.nome}" excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir música: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarMusica(DTOMusica musica) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroMusica,
      arguments: musica,
    ).then((_) => _carregarMusicas());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_note_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhuma música cadastrada', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaMusica(DTOMusica musica) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: musica.ativo ? Colors.green : Colors.grey,
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text(_definirDescricao(musica)),
        subtitle: Text(_definirDetalhesDescricao(musica)),
        trailing: _painelBotoesItem(musica),
      ),
    );
  }

  Widget _painelBotoesItem(DTOMusica musica) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarMusica(musica),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirMusica(musica),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroMusica)
          .then((_) => _carregarMusicas()),
      tooltip: 'Adicionar Música',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarMusicas,
      tooltip: 'Recarregar',
    );
  }
} 