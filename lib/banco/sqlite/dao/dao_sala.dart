import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_sala.dart';

class DAOSala {
  static const String _tabela = 'sala';

  // Salvar (inserir ou atualizar)
  Future<int> salvar(DTOSala sala) async {
    final db = await ConexaoSQLite.database;
    
    if (sala.id != null) {
      // Atualizar
      return await db.update(
        _tabela,
        {
          'nome': sala.nome,
          'numero_bikes': sala.numeroBikes,
          'numero_filas': sala.numeroFilas,
          'limite_bikes_por_fila': sala.limiteBikesPorFila,
          'grade_bikes': _gradeBikesToString(sala.gradeBikes),
          'ativa': sala.ativa ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [sala.id],
      );
    } else {
      // Inserir
      return await db.insert(
        _tabela,
        {
          'nome': sala.nome,
          'numero_bikes': sala.numeroBikes,
          'numero_filas': sala.numeroFilas,
          'limite_bikes_por_fila': sala.limiteBikesPorFila,
          'grade_bikes': _gradeBikesToString(sala.gradeBikes),
          'ativa': sala.ativa ? 1 : 0,
        },
      );
    }
  }

  // Buscar todos
  Future<List<DTOSala>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(_tabela);
    
    return List.generate(maps.length, (i) {
      return DTOSala(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        numeroBikes: maps[i]['numero_bikes'],
        numeroFilas: maps[i]['numero_filas'],
        limiteBikesPorFila: maps[i]['limite_bikes_por_fila'],
        gradeBikes: _stringToGradeBikes(maps[i]['grade_bikes']),
        ativa: maps[i]['ativa'] == 1,
      );
    });
  }

  // Buscar por ID
  Future<DTOSala?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return DTOSala(
        id: maps[0]['id'],
        nome: maps[0]['nome'],
        numeroBikes: maps[0]['numero_bikes'],
        numeroFilas: maps[0]['numero_filas'],
        limiteBikesPorFila: maps[0]['limite_bikes_por_fila'],
        gradeBikes: _stringToGradeBikes(maps[0]['grade_bikes']),
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

  // Converter grade de bikes para string JSON
  String _gradeBikesToString(List<List<bool>> gradeBikes) {
    return gradeBikes.map((fila) => fila.map((bike) => bike ? 1 : 0).toList()).toList().toString();
  }

  // Converter string JSON para grade de bikes
  List<List<bool>> _stringToGradeBikes(String? gradeString) {
    if (gradeString == null || gradeString.isEmpty) {
      return [];
    }
    
    try {
      // Remove colchetes externos e divide por filas
      final cleanString = gradeString.substring(1, gradeString.length - 1);
      final filas = cleanString.split('], [');
      
      return filas.map((fila) {
        // Remove colchetes da fila e divide por bikes
        final cleanFila = fila.replaceAll('[', '').replaceAll(']', '');
        final bikes = cleanFila.split(', ');
        return bikes.map((bike) => bike == '1').toList();
      }).toList();
    } catch (e) {
      return [];
    }
  }
} 