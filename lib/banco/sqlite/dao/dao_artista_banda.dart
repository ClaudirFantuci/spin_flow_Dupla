import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';

class DAOArtistaBanda {
  static const String _tabela = 'artista_banda';

  // Salvar (inserir ou atualizar)
  Future<int> salvar(DTOArtistaBanda artista) async {
    final db = await ConexaoSQLite.database;
    
    if (artista.id != null) {
      // Atualizar
      return await db.update(
        _tabela,
        {
          'nome': artista.nome,
          'descricao': artista.descricao,
          'link': artista.link,
          'foto': artista.foto,
          'ativo': artista.ativo ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [artista.id],
      );
    } else {
      // Inserir
      return await db.insert(
        _tabela,
        {
          'nome': artista.nome,
          'descricao': artista.descricao,
          'link': artista.link,
          'foto': artista.foto,
          'ativo': artista.ativo ? 1 : 0,
        },
      );
    }
  }

  // Buscar todos
  Future<List<DTOArtistaBanda>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(_tabela);
    
    return List.generate(maps.length, (i) {
      return DTOArtistaBanda(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        descricao: maps[i]['descricao'],
        link: maps[i]['link'],
        foto: maps[i]['foto'],
        ativo: maps[i]['ativo'] == 1,
      );
    });
  }

  // Buscar por ID
  Future<DTOArtistaBanda?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return DTOArtistaBanda(
        id: maps[0]['id'],
        nome: maps[0]['nome'],
        descricao: maps[0]['descricao'],
        link: maps[0]['link'],
        foto: maps[0]['foto'],
        ativo: maps[0]['ativo'] == 1,
      );
    }
    return null;
  }

  // Excluir
  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 