import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/dto/dto_grupo_alunos.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_multipla/campo_busca_multipla.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
class FormGrupoAlunos extends StatefulWidget {
  const FormGrupoAlunos({super.key});

  @override
  State<FormGrupoAlunos> createState() => _FormGrupoAlunosState();
}

class _FormGrupoAlunosState extends State<FormGrupoAlunos> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _descricaoControlador = TextEditingController();
  final _daoAlunos = DAOAluno();

  // Campos do formulário
  String? _nome;
  String? _descricao;
  List<DTOAluno> _alunosSelecionados = [];
  bool _carregando = true;
  List<DTOAluno> _alunos = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final alunos = await _daoAlunos.buscarTodos();
      setState(() {
        _alunos = alunos;
        _carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar alunos: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao carregar alunos: $e'),
              backgroundColor: Colors.red),
        );
      }
      setState(() {
        _carregando = false;
      });
    }
  }

  // Função para validar que há pelo menos 1 aluno selecionado
  String? _validaAlunosSelecionados() {
    if (_alunosSelecionados.isEmpty) {
      return 'Selecione pelo menos um aluno';
    }
    return null;
  }

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _descricao = null;
      _alunosSelecionados.clear();
    });
    _nomeControlador.clear();
    _descricaoControlador.clear();
    _formKey.currentState?.reset();
  }

  void _salvar() {
    final formValido = _formKey.currentState?.validate() ?? false;
    final alunosValidos = _validaAlunosSelecionados() == null;

    if (formValido && alunosValidos) {
      // Criar DTO
      final dto = DTOGrupoAlunos(
        nome: _nome ?? '',
        descricao: _descricao,
        alunos: List.from(_alunosSelecionados),
      );

      // Mostrar dados em dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Grupo de Alunos Criado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${dto.nome}'),
                Text('Descrição: ${dto.descricao ?? 'Não informado'}'),
                const SizedBox(height: 8),
                Text('Alunos (${dto.alunos.length}):',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ...dto.alunos.map(
                  (aluno) => Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Text('• ${aluno.nome}'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );

      // SnackBar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grupo salvo com sucesso! ${dto.nome}')),
      );

      // Limpar formulário
      _limparFormulario();
    } else {
      if (!alunosValidos) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_validaAlunosSelecionados()!)),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _descricaoControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_alunos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cadastro de Grupo de Alunos')),
        body: const Center(child: Text('Erro: Nenhum aluno disponível')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Grupo de Alunos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CampoTexto(
                controle: _nomeControlador,
                rotulo: 'Nome do Grupo',
                dica: 'Nome do grupo de alunos',
                eObrigatorio: true,
                aoAlterar: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controle: _descricaoControlador,
                rotulo: 'Descrição',
                dica: 'Descrição do grupo (opcional)',
                eObrigatorio: false,
                aoAlterar: (value) => _descricao = value,
              ),
              const SizedBox(height: 16),
              Text('Alunos'),
              const SizedBox(height: 8),
              CampoBuscaMultipla<DTOAluno>(
                opcoes: _alunos,
                valoresSelecionados: _alunosSelecionados,
                rotulo: 'Alunos do Grupo',
                textoPadrao: 'Digite para buscar alunos...',
                rotaCadastro: Rotas.cadastroAluno,
                onChanged: (lista) =>
                    setState(() => _alunosSelecionados = lista),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: const Text('Salvar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
