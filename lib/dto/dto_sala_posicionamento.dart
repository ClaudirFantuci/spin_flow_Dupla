import 'package:spin_flow/dto/dto.dart';

class DTOSalaPosicionamento implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final int numeroBikes;
  final int numeroFilas;
  final int limiteBikesPorFila;
  final int posicaoBikeProfessora; // índice da coluna da bike da professora na fila 0
  final List<List<int>> posicoes; // grade das bikes
  final bool ativo;

  DTOSalaPosicionamento({
    this.id,
    required this.nome,
    required this.numeroBikes,
    required this.numeroFilas,
    required this.limiteBikesPorFila,
    required this.posicaoBikeProfessora,
    required this.posicoes,
    this.ativo = true,
  });
} 