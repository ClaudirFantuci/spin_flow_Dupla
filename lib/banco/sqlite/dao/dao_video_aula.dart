import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';

class DAOVideoAula {
  static const String _tabela = 'video_aula';

  // Inserir
  Future<int> salvar(DTOVideoAula videoAula) async {
    final db = await ConexaoSQLite.database;
    return await db.insert(
      _tabela,
      {
        'nome': videoAula.nome,
        'link_video': videoAula.linkVideo,
        'ativo': videoAula.ativo ? 1 : 0,
      },
    );
  }

  // Atualizar
  Future<int> update(DTOVideoAula videoAula) async {
    final db = await ConexaoSQLite.database;
    return await db.update(
      _tabela,
      {
        'nome': videoAula.nome,
        'link_video': videoAula.linkVideo,
        'ativo': videoAula.ativo ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [videoAula.id],
    );
  }

  // Buscar todos
  Future<List<DTOVideoAula>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(_tabela);

    return List.generate(maps.length, (i) {
      return DTOVideoAula(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        linkVideo: maps[i]['link_video'],
        ativo: maps[i]['ativo'] == 1,
      );
    });
  }

  // Buscar por ID
  Future<DTOVideoAula?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DTOVideoAula(
        id: maps[0]['id'],
        nome: maps[0]['nome'],
        linkVideo: maps[0]['link_video'],
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
