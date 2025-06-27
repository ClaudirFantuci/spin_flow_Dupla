import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_artista_banda.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_categoria_musica.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_musica.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_multipla/campo_multi_selecao.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_opcoes.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_url.dart';

class FormMusica extends StatefulWidget {
  final DTOMusica? musica;
  const FormMusica({super.key, this.musica});

  @override
  State<FormMusica> createState() => _FormMusicaState();
}

class _FormMusicaState extends State<FormMusica> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _daoArtistas = DAOArtistaBanda();
  final _daoCategorias = DAOCategoriaMusica();
  final _daoMusicas = DAOMusicas();

  // Campos do formulário
  String? _nome;
  DTOArtistaBanda? _artistaSelecionado;
  final List<DTOCategoriaMusica> _categoriasSelecionadas = [];
  final List<Map<String, String?>> _links = [];
  String? _descricao;
  bool _ativo = true;
  bool _carregando = true;

  List<DTOArtistaBanda> _artistas = [];
  List<DTOCategoriaMusica> _categorias = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final artistas = await _daoArtistas.buscarTodos();
      final categorias = await _daoCategorias.buscarTodos();
      setState(() {
        _artistas = artistas;
        _categorias = categorias;
        _carregando = false;
      });

      // Inicializar com dados da música, se fornecida
      if (widget.musica != null) {
        _nome = widget.musica!.nome;
        _artistaSelecionado = widget.musica!.artista;
        _categoriasSelecionadas.addAll(widget.musica!.categorias);
        _links.addAll(widget.musica!.linksVideoAula.map((link) => {
              'url': link.url,
              'descricao': link.descricao,
            }));
        _descricao = widget.musica!.descricao;
        _ativo = widget.musica!.ativo;
      }
      debugPrint('Form initialized with musica: ${widget.musica?.toString()}');
    } catch (e) {
      debugPrint('Erro ao carregar artistas/categorias: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao carregar dados: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _adicionarLink() {
    setState(() {
      _links.add({
        'url': null,
        'descricao': null,
      });
    });
  }

  void _removerLink(int index) {
    setState(() {
      _links.removeAt(index);
    });
  }

  void _atualizarLink(int index, String campo, String? valor) {
    setState(() {
      _links[index][campo] = valor;
    });
  }

  void _limparCampos() {
    setState(() {
      _nome = null;
      _artistaSelecionado = null;
      _categoriasSelecionadas.clear();
      _links.clear();
      _descricao = null;
      _ativo = true;
    });
    _chaveFormulario.currentState?.reset();
  }

  DTOMusica _criarDTO() {
    final links = _links
        .where((link) => link['url'] != null && link['url']!.isNotEmpty)
        .map((link) => DTOLinkVideoAula(
              url: link['url']!,
              descricao: link['descricao'] ?? '',
            ))
        .toList();
    return DTOMusica(
      id: widget.musica?.id,
      nome: _nome ?? '',
      artista: _artistaSelecionado!,
      categorias: List.from(_categoriasSelecionadas),
      linksVideoAula: links,
      descricao: _descricao,
      ativo: _ativo,
    );
  }

  void _mostrarMensagem(String mensagem, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate()) {
      if (_artistaSelecionado == null) {
        _mostrarMensagem('Selecione o artista/banda', erro: true);
        return;
      }
      if (_categoriasSelecionadas.isEmpty) {
        _mostrarMensagem('Selecione pelo menos uma categoria', erro: true);
        return;
      }
      final dto = _criarDTO();
      debugPrint('Saving DTO: ${dto.toString()}');
      try {
        final result = await _daoMusicas.salvar(dto);
        debugPrint('Save result: $result');
        if (mounted) {
          _mostrarMensagem(
            widget.musica == null
                ? 'Música "${dto.nome}" criada com sucesso!'
                : 'Música "${dto.nome}" atualizada com sucesso!',
          );
          Navigator.of(context).pop(dto);
        }
      } catch (e) {
        debugPrint('Erro ao salvar música: $e');
        if (mounted) {
          _mostrarMensagem('Erro ao salvar música: $e', erro: true);
        }
      }
    } else {
      debugPrint('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_artistas.isEmpty || _categorias.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cadastro de Música')),
        body: const Center(
            child: Text('Erro: Nenhum artista ou categoria disponível')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.musica == null ? 'Cadastro de Música' : 'Editar Música'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Salvar',
            onPressed: _salvar,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _chaveFormulario,
          child: ListView(
            children: [
              CampoTexto(
                rotulo: 'Nome da Música',
                dica: 'Nome da música',
                eObrigatorio: true,
                valorInicial: _nome,
                aoAlterar: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoOpcoes<DTOArtistaBanda>(
                opcoes: _artistas,
                valorSelecionado: _artistaSelecionado,
                rotulo: 'Artista/Banda',
                textoPadrao: 'Selecione o artista/banda',
                eObrigatorio: true,
                rotaCadastro: Rotas.cadastroArtistaBanda,
                aoAlterar: (artista) {
                  setState(() {
                    _artistaSelecionado = artista;
                  });
                },
              ),
              const SizedBox(height: 16),
              CampoMultiSelecao<DTOCategoriaMusica>(
                opcoes: _categorias,
                valoresSelecionados: _categoriasSelecionadas,
                rotaCadastro: Rotas.cadastroCategoriaMusica,
                rotulo: 'Categorias de Música',
                textoPadrao: 'Selecione categorias',
                eObrigatorio: true,
                onChanged: (selecionados) {
                  setState(() {
                    _categoriasSelecionadas
                      ..clear()
                      ..addAll(selecionados);
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text('Links de Vídeo Aula (opcional)'),
              const SizedBox(height: 8),
              ..._links.asMap().entries.map((entry) {
                int index = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CampoUrl(
                          rotulo: 'Link do Vídeo Aula ${index + 1}',
                          dica: 'https://...',
                          eObrigatorio: false,
                          valorInicial: _links[index]['url'],
                          aoAlterar: (value) =>
                              _atualizarLink(index, 'url', value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: CampoTexto(
                          rotulo: 'Descrição',
                          dica: 'Ex: Playlist oficial',
                          eObrigatorio: false,
                          valorInicial: _links[index]['descricao'],
                          aoAlterar: (value) =>
                              _atualizarLink(index, 'descricao', value),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Remover link',
                        onPressed: () => _removerLink(index),
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _adicionarLink,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Link'),
              ),
              const SizedBox(height: 16),
              CampoTexto(
                rotulo: 'Descrição',
                dica: 'Descrição da música (opcional)',
                eObrigatorio: false,
                maxLinhas: 3,
                valorInicial: _descricao,
                aoAlterar: (value) => _descricao = value,
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                value: _ativo,
                onChanged: (v) => setState(() => _ativo = v),
                title: const Text('Ativa'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
