import 'package:spin_flow/dto/dto.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';

class DTOMusica implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final DTOArtistaBanda artista;
  final List<DTOCategoriaMusica> categorias;
  final List<DTOLinkVideoAula> linksVideoAula;
  final String? descricao;
  final bool ativo;

  DTOMusica({
    this.id,
    required this.nome,
    required this.artista,
    required this.categorias,
    required this.linksVideoAula,
    this.descricao,
    this.ativo = true,
  });
}

class DTOLinkVideoAula {
  final String url;
  final String descricao;

  DTOLinkVideoAula({
    required this.url,
    required this.descricao,
  });
} 