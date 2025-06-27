// import 'package:spin_flow/banco/sqlite/conexao.dart';
// import 'package:spin_flow/dto/dto_bike.dart';
// import 'package:spin_flow/dto/dto_fabricante.dart';

// class DAOBike {
//   static const String _tabela = 'bike';

//   Future<int> salvar(DTOBike bike) async {
//     final db = await ConexaoSQLite.database;

//     final Map<String, dynamic> dados = {
//       'nome': bike.nome,
//       'numero_serie': bike.numeroSerie,
//       'fabricante_id': bike.fabricante.id,
//       'data_cadastro': bike.dataCadastro.toIso8601String().split('T')[0],
//       'ativa': bike.ativa ? 1 : 0,
//     };

//     if (bike.id != null) {
//       return await db.update(
//         _tabela,
//         dados,
//         where: 'id = ?',
//         whereArgs: [bike.id],
//       );
//     } else {
//       return await db.insert(_tabela, dados);
//     }
//   }

//   Future<List<DTOBike>> buscarTodos() async {
//     final db = await ConexaoSQLite.database;
//     final List<Map<String, dynamic>> maps = await db.rawQuery('''
//       SELECT bike.*, fabricante.id AS fab_id, fabricante.nome AS fab_nome,
//              fabricante.descricao AS fab_descricao, fabricante.nome_contato_principal AS fab_nome_contato,
//              fabricante.email_contato AS fab_email, fabricante.telefone_contato AS fab_telefone,
//              fabricante.ativo AS fab_ativo
//       FROM $_tabela
//       JOIN fabricante ON bike.fabricante_id = fabricante.id
//     ''');

//     return List.generate(maps.length, (i) {
//       return DTOBike(
//         id: maps[i]['id'],
//         nome: maps[i]['nome'],
//         numeroSerie: maps[i]['numero_serie'],
//         fabricante: DTOFabricante(
//           id: maps[i]['fab_id'],
//           nome: maps[i]['fab_nome'],
//           descricao: maps[i]['fab_descricao'],
//           nomeContatoPrincipal: maps[i]['fab_nome_contato'],
//           emailContato: maps[i]['fab_email'],
//           telefoneContato: maps[i]['fab_telefone'],
//           ativo: maps[i]['fab_ativo'] == 1,
//         ),
//         dataCadastro: DateTime.parse(maps[i]['data_cadastro']),
//         ativa: maps[i]['ativa'] == 1,
//       );
//     });
//   }

//   Future<DTOBike?> buscarPorId(int id) async {
//     final db = await ConexaoSQLite.database;
//     final List<Map<String, dynamic>> maps = await db.rawQuery('''
//       SELECT bike.*, fabricante.id AS fab_id, fabricante.nome AS fab_nome,
//              fabricante.descricao AS fab_descricao, fabricante.nome_contato_principal AS fab_nome_contato,
//              fabricante.email_contato AS fab_email, fabricante.telefone_contato AS fab_telefone,
//              fabricante.ativo AS fab_ativo
//       FROM $_tabela
//       JOIN fabricante ON bike.fabricante_id = fabricante.id
//       WHERE bike.id = ?
//     ''', [id]);

//     if (maps.isNotEmpty) {
//       return DTOBike(
//         id: maps[0]['id'],
//         nome: maps[0]['nome'],
//         numeroSerie: maps[0]['numero_serie'],
//         fabricante: DTOFabricante(
//           id: maps[0]['fab_id'],
//           nome: maps[0]['fab_nome'],
//           descricao: maps[0]['fab_descricao'],
//           nomeContatoPrincipal: maps[0]['fab_nome_contato'],
//           emailContato: maps[0]['fab_email'],
//           telefoneContato: maps[0]['fab_telefone'],
//           ativo: maps[0]['fab_ativo'] == 1,
//         ),
//         dataCadastro: DateTime.parse(maps[0]['data_cadastro']),
//         ativa: maps[0]['ativa'] == 1,
//       );
//     }
//     return null;
//   }

//   Future<int> excluir(int id) async {
//     final db = await ConexaoSQLite.database;
//     return await db.delete(
//       _tabela,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }
