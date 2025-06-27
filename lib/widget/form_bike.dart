import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_opcoes.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/banco/mock/mock_fabricantes.dart';

class FormBike extends StatefulWidget {
  const FormBike({super.key});

  @override
  State<FormBike> createState() => _FormBikeState();
}

class _FormBikeState extends State<FormBike> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos do formulário
  String? _nome;
  String? _numeroSerie;
  DTOFabricante? _fabricanteSelecionado;
  DateTime? _dataCadastro;
  bool _ativa = true;

  final List<DTOFabricante> _fabricantes = mockFabricantes;

  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _numeroSerieControlador = TextEditingController();

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _numeroSerie = null;
      _fabricanteSelecionado = null;
      _dataCadastro = null;
      _ativa = true;
    });
    _formKey.currentState?.reset();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      if (_fabricanteSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione um fabricante')),
        );
        return;
      }

      if (_dataCadastro == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informe a data de cadastro')),
        );
        return;
      }

      // Criar DTO
      final dto = DTOBike(
        nome: _nome ?? '',
        numeroSerie: _numeroSerie,
        fabricante: _fabricanteSelecionado!,
        dataCadastro: _dataCadastro!,
        ativa: _ativa,
      );

      // Mostrar dados em dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Bike Criada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${dto.nome}'),
              Text('Número de Série: ${dto.numeroSerie ?? 'Não informado'}'),
              Text('Fabricante: ${dto.fabricante.nome}'),
              Text('Data de Cadastro: ${dto.dataCadastro.toString().split(' ')[0]}'),
              Text('Ativa: ${dto.ativa ? 'Sim' : 'Não'}'),
            ],
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
        SnackBar(content: Text('Bike salva com sucesso! ${dto.nome}')),
      );

      // Limpar formulário
      _limparFormulario();
    }
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _numeroSerieControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Bike')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CampoTexto(
                controle: _nomeControlador,
                rotulo: 'Nome da Bike',
                dica: 'Nome identificador da bike',
                eObrigatorio: true,
                aoAlterar: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controle: _numeroSerieControlador,
                rotulo: 'Número de Série',
                dica: 'Número de série da bike',
                eObrigatorio: false,
                aoAlterar: (value) => _numeroSerie = value,
              ),
              const SizedBox(height: 16),
              CampoOpcoes<DTOFabricante>(
                opcoes: _fabricantes,
                rotulo: 'Fabricante',
                textoPadrao: 'Selecione um fabricante',
                rotaCadastro: Rotas.cadastroFabricante,
                aoAlterar: (fabricante) => setState(() => _fabricanteSelecionado = fabricante),
              ),
              const SizedBox(height: 16),
              CampoData(
                rotulo: 'Data de Cadastro',
                valor: _dataCadastro,
                eObrigatorio: true,
                aoAlterar: (data) {
                  setState(() {
                    _dataCadastro = data;
                  });
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Ativa'),
                value: _ativa,
                onChanged: (valor) {
                  setState(() {
                    _ativa = valor;
                  });
                },
              ),
              const SizedBox(height: 24),
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
