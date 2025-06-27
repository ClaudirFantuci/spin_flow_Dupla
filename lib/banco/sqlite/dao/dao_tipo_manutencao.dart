import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_tipo_manutencao.dart';

class DAOTipoManutencao {
  static const String _tabela = 'tipo_manutencao';

  // Salvar (inserir ou atualizar)
  Future<int> salvar(DTOTipoManutencao tipo) async {
    final db = await ConexaoSQLite.database;
    
    if (tipo.id != null) {
      // Atualizar
      return await db.update(
        _tabela,
        {
          'nome': tipo.nome,
          'ativa': tipo.ativa ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [tipo.id],
      );
    } else {
      // Inserir
      return await db.insert(
        _tabela,
        {
          'nome': tipo.nome,
          'ativa': tipo.ativa ? 1 : 0,
        },
      );
    }
  }

  // Buscar todos
  Future<List<DTOTipoManutencao>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(_tabela);
    
    return List.generate(maps.length, (i) {
      return DTOTipoManutencao(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        ativa: maps[i]['ativa'] == 1,
      );
    });
  }

  // Buscar por ID
  Future<DTOTipoManutencao?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return DTOTipoManutencao(
        id: maps[0]['id'],
        nome: maps[0]['nome'],
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