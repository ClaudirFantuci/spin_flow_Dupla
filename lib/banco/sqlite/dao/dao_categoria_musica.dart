import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';

class DAOCategoriaMusica {
  static const String _tabela = 'categoria_musica';

  // Salvar (inserir ou atualizar)
  Future<int> salvar(DTOCategoriaMusica categoria) async {
    final db = await ConexaoSQLite.database;
    
    if (categoria.id != null) {
      // Atualizar
      return await db.update(
        _tabela,
        {
          'nome': categoria.nome,
          'descricao': categoria.descricao,
          'ativa': categoria.ativa ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [categoria.id],
      );
    } else {
      // Inserir
      return await db.insert(
        _tabela,
        {
          'nome': categoria.nome,
          'descricao': categoria.descricao,
          'ativa': categoria.ativa ? 1 : 0,
        },
      );
    }
  }

  // Buscar todos
  Future<List<DTOCategoriaMusica>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(_tabela);
    
    return List.generate(maps.length, (i) {
      return DTOCategoriaMusica(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        descricao: maps[i]['descricao'],
        ativa: maps[i]['ativa'] == 1,
      );
    });
  }

  // Buscar por ID
  Future<DTOCategoriaMusica?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return DTOCategoriaMusica(
        id: maps[0]['id'],
        nome: maps[0]['nome'],
        descricao: maps[0]['descricao'],
        ativa: maps[0]['ativa'] == 1,
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