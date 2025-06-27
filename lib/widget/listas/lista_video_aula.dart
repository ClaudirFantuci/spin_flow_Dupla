import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_video_aula.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/form_video_aula.dart';

class ListaVideoAula extends StatefulWidget {
  const ListaVideoAula({super.key});

  @override
  State<ListaVideoAula> createState() => _ListaVideoAulaState();
}

class _ListaVideoAulaState extends State<ListaVideoAula> {
  final _dao = DAOVideoAula();
  List<DTOVideoAula> _videoAulas = [];

  @override
  void initState() {
    super.initState();
    _carregarVideoAulas();
  }

  Future<void> _carregarVideoAulas() async {
    try {
      final videoAulas = await _dao.buscarTodos();
      if (mounted) {
        setState(() {
          _videoAulas = videoAulas;
          debugPrint(
              'Loaded video aulas: ${_videoAulas.map((v) => v.toString()).toList()}');
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar vídeo-aulas: $e')),
        );
      }
    }
  }

  Future<void> _excluirVideoAula(int id) async {
    try {
      await _dao.excluir(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vídeo-aula excluída com sucesso')),
        );
        await _carregarVideoAulas();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir vídeo-aula: $e')),
        );
      }
    }
  }

  Future<void> _editarVideoAula(DTOVideoAula videoAula) async {
    if (videoAula.id == null) {
      debugPrint('Error: videoAula.id is null: ${videoAula.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro: Vídeo-aula inválida para edição')),
        );
      }
      return;
    }
    debugPrint('Navigating to edit: ${videoAula.toString()}');
    final result = await Navigator.pushNamed(
      context,
      Rotas.cadastroVideoAula,
      arguments: videoAula,
    );
    // Alternative direct navigation (uncomment to test):
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FormVideoAula(videoAula: videoAula),
    //   ),
    // );
    if (result != null && mounted) {
      debugPrint('Edit completed, refreshing list');
      await _carregarVideoAulas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vídeo-aulas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarVideoAulas,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: _videoAulas.isEmpty
          ? _widgetSemDados(context)
          : ListView.builder(
              itemCount: _videoAulas.length,
              itemBuilder: (context, index) =>
                  _itemLista(context, _videoAulas[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, Rotas.cadastroVideoAula);
          if (result != null && mounted) {
            debugPrint('New video aula added, refreshing list');
            await _carregarVideoAulas();
          }
        },
        tooltip: 'Adicionar Vídeo-aula',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _widgetSemDados(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.ondemand_video, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhuma vídeo-aula cadastrada',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, Rotas.cadastroVideoAula);
              if (result != null && mounted) {
                debugPrint(
                    'New video aula added from empty state, refreshing list');
                await _carregarVideoAulas();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Vídeo-aula'),
          ),
        ],
      ),
    );
  }

  Widget _itemLista(BuildContext context, DTOVideoAula videoAula) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          videoAula.ativo ? Icons.play_circle_fill : Icons.pause_circle_filled,
          color: videoAula.ativo ? Colors.green : Colors.grey,
        ),
        title: Text(videoAula.nome),
        subtitle: Text(videoAula.linkVideo ?? 'Sem link'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: 'Abrir link',
              onPressed:
                  videoAula.linkVideo != null && videoAula.linkVideo!.isNotEmpty
                      ? () => _abrirLink(context, videoAula.linkVideo!)
                      : null,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar',
              onPressed: () => _editarVideoAula(videoAula),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Excluir',
              onPressed: () => _confirmarExclusao(context, videoAula),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirLink(BuildContext context, String url) async {
    // Para abrir links, normalmente se usa url_launcher, mas aqui só mostra um SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abrir link: $url')),
    );
  }

  void _confirmarExclusao(BuildContext context, DTOVideoAula videoAula) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir a vídeo-aula "${videoAula.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _excluirVideoAula(videoAula.id!);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
