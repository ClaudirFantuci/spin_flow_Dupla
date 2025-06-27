import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_artista_banda.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaArtistasBandas extends StatefulWidget {
  const ListaArtistasBandas({super.key});

  @override
  State<ListaArtistasBandas> createState() => _ListaArtistasBandasState();
}

class _ListaArtistasBandasState extends State<ListaArtistasBandas> {
  List<DTOArtistaBanda> _artistas = [];
  bool _carregando = true;
  final DAOArtistaBanda _daoArtista = DAOArtistaBanda();

  @override
  void initState() {
    super.initState();
    _carregarArtistas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artistas/Bandas'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _artistas.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _artistas.length,
                  itemBuilder: (context, index) => _itemListaArtista(_artistas[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOArtistaBanda artista) {
    return artista.nome;
  }

  String _definirDetalhesDescricao(DTOArtistaBanda artista) {
    final descricao = (artista.descricao != null && artista.descricao!.isNotEmpty)
        ? '${artista.descricao!}\n'
        : '';
    final link = (artista.link != null && artista.link!.isNotEmpty)
        ? 'Link: ${artista.link}\n'
        : '';
    final status = artista.ativo ? 'Ativo' : 'Inativo';
    return '$descricao$link$status';
  }

  Future<void> _carregarArtistas() async {
    setState(() {
      _carregando = true;
    });
    try {
      final artistas = await _daoArtista.buscarTodos();
      setState(() {
        _artistas = artistas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar artistas/bandas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirArtista(DTOArtistaBanda artista) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o artista/banda "${artista.nome}"?'),
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
        await _daoArtista.excluir(artista.id!);
        await _carregarArtistas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Artista/Banda "${artista.nome}" excluído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir artista/banda: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarArtista(DTOArtistaBanda artista) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroArtistaBanda,
      arguments: artista,
    ).then((_) => _carregarArtistas());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_video_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhum artista/banda cadastrado', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaArtista(DTOArtistaBanda artista) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: artista.ativo ? Colors.green : Colors.grey,
          child: const Icon(Icons.music_video, color: Colors.white),
        ),
        title: Text(_definirDescricao(artista)),
        subtitle: Text(_definirDetalhesDescricao(artista)),
        trailing: _painelBotoesItem(artista),
      ),
    );
  }

  Widget _painelBotoesItem(DTOArtistaBanda artista) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarArtista(artista),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirArtista(artista),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroArtistaBanda)
          .then((_) => _carregarArtistas()),
      tooltip: 'Adicionar Artista/Banda',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarArtistas,
      tooltip: 'Recarregar',
    );
  }
} 