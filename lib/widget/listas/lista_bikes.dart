import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_bikes.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaBikes extends StatefulWidget {
  const ListaBikes({super.key});

  @override
  State<ListaBikes> createState() => _ListaBikesState();
}

class _ListaBikesState extends State<ListaBikes> {
  List<DTOBike> _bikes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarBikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bikes'),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _bikes.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _bikes.length,
                  itemBuilder: (context, index) => _itemListaBike(_bikes[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  String _definirDescricao(DTOBike bike) {
    return bike.nome;
  }

  String _definirDetalhesDescricao(DTOBike bike) {
    final fabricante = 'Fabricante: ${bike.fabricante.nome}\n';
    final numeroSerie = (bike.numeroSerie != null && bike.numeroSerie!.isNotEmpty)
        ? 'Número de Série: ${bike.numeroSerie}\n'
        : '';
    final dataCadastro = 'Cadastrada em: ${bike.dataCadastro.toString().split(' ')[0]}\n';
    final status = bike.ativa ? 'Ativa' : 'Inativa';
    return '$fabricante$numeroSerie$dataCadastro$status';
  }

  Future<void> _carregarBikes() async {
    setState(() {
      _carregando = true;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final bikes = mockBikes;
      setState(() {
        _bikes = bikes;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar bikes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirBike(DTOBike bike) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir a bike "${bike.nome}"?'),
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
          _bikes.removeWhere((b) => b.id == bike.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bike "${bike.nome}" excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir bike: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editarBike(DTOBike bike) {
    Navigator.pushNamed(
      context,
      Rotas.cadastroBike,
      arguments: bike,
    ).then((_) => _carregarBikes());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_bike_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhuma bike cadastrada', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemListaBike(DTOBike bike) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bike.ativa ? Colors.green : Colors.grey,
          child: const Icon(Icons.directions_bike, color: Colors.white),
        ),
        title: Text(_definirDescricao(bike)),
        subtitle: Text(_definirDetalhesDescricao(bike)),
        trailing: _painelBotoesItem(bike),
      ),
    );
  }

  Widget _painelBotoesItem(DTOBike bike) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarBike(bike),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirBike(bike),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Rotas.cadastroBike)
          .then((_) => _carregarBikes()),
      tooltip: 'Adicionar Bike',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarBikes,
      tooltip: 'Recarregar',
    );
  }
} 