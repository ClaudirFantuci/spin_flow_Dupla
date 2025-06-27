import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_aluno.dart';

class DAOAluno {
  static const String _tabela = 'aluno';

  // Salvar (inserir ou atualizar)
  Future<int> salvar(DTOAluno aluno) async {
    final db = await ConexaoSQLite.database;
    
    if (aluno.id != null) {
      // Atualizar
      return await db.update(
        _tabela,
        {
          'nome': aluno.nome,
          'email': aluno.email,
          'data_nascimento': aluno.dataNascimento.toIso8601String(),
          'genero': aluno.genero,
          'telefone': aluno.telefone,
          'url_foto': aluno.urlFoto,
          'instagram': aluno.instagram,
          'facebook': aluno.facebook,
          'tiktok': aluno.tiktok,
          'observacoes': aluno.observacoes,
          'ativo': aluno.ativo ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [aluno.id],
      );
    } else {
      // Inserir
      return await db.insert(
        _tabela,
        {
          'nome': aluno.nome,
          'email': aluno.email,
          'data_nascimento': aluno.dataNascimento.toIso8601String(),
          'genero': aluno.genero,
          'telefone': aluno.telefone,
          'url_foto': aluno.urlFoto,
          'instagram': aluno.instagram,
          'facebook': aluno.facebook,
          'tiktok': aluno.tiktok,
          'observacoes': aluno.observacoes,
          'ativo': aluno.ativo ? 1 : 0,
        },
      );
    }
  }

  // Buscar todos
  Future<List<DTOAluno>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(_tabela);
    
    return List.generate(maps.length, (i) {
      return DTOAluno(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        email: maps[i]['email'],
        dataNascimento: DateTime.parse(maps[i]['data_nascimento']),
        genero: maps[i]['genero'],
        telefone: maps[i]['telefone'],
        urlFoto: maps[i]['url_foto'],
        instagram: maps[i]['instagram'],
        facebook: maps[i]['facebook'],
        tiktok: maps[i]['tiktok'],
        observacoes: maps[i]['observacoes'],
        ativo: maps[i]['ativo'] == 1,
      );
    });
  }

  // Buscar por ID
  Future<DTOAluno?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return DTOAluno(
        id: maps[0]['id'],
        nome: maps[0]['nome'],
        email: maps[0]['email'],
        dataNascimento: DateTime.parse(maps[0]['data_nascimento']),
        genero: maps[0]['genero'],
        telefone: maps[0]['telefone'],
        urlFoto: maps[0]['url_foto'],
        instagram: maps[0]['instagram'],
        facebook: maps[0]['facebook'],
        tiktok: maps[0]['tiktok'],
        observacoes: maps[0]['observacoes'],
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