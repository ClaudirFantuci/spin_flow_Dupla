import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';

class DAOMusicas {
  static const String _tabelaMusica = 'musica';
  static const String _tabelaMusicaCategoria = 'musica_categoria';
  static const String _tabelaMusicaVideoAula = 'musica_video_aula';

  // Salvar (inserir ou atualizar)
  Future<int> salvar(DTOMusica musica) async {
    final db = await ConexaoSQLite.database;
    return await db.transaction((txn) async {
      // Inserir ou atualizar música
      final musicaData = {
        'nome': musica.nome,
        'artista_id': musica.artista.id,
        'descricao': musica.descricao,
        'ativo': musica.ativo ? 1 : 0,
      };

      int musicaId;
      if (musica.id == null) {
        // Inserir nova música
        musicaId = await txn.insert(_tabelaMusica, musicaData);
      } else {
        // Atualizar música existente
        musicaId = musica.id!;
        await txn.update(
          _tabelaMusica,
          musicaData,
          where: 'id = ?',
          whereArgs: [musicaId],
        );
      }

      // Atualizar categorias (remover existentes e inserir novas)
      await txn.delete(
        _tabelaMusicaCategoria,
        where: 'musica_id = ?',
        whereArgs: [musicaId],
      );
      for (final categoria in musica.categorias) {
        await txn.insert(_tabelaMusicaCategoria, {
          'musica_id': musicaId,
          'categoria_id': categoria.id,
        });
      }

      // Atualizar links de vídeo-aula (remover existentes e inserir novos)
      await txn.delete(
        _tabelaMusicaVideoAula,
        where: 'musica_id = ?',
        whereArgs: [musicaId],
      );
      for (final link in musica.linksVideoAula) {
        await txn.insert(_tabelaMusicaVideoAula, {
          'musica_id': musicaId,
          'url': link.url,
          'descricao': link.descricao,
        });
      }

      return musicaId;
    });
  }

  // Buscar todos
  Future<List<DTOMusica>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> musicaMaps = await db.query(_tabelaMusica);

    List<DTOMusica> musicas = [];
    for (final mapa in musicaMaps) {
      final musica = await _construirMusicaCompleta(mapa, db);
      if (musica != null) {
        musicas.add(musica);
      }
    }
    return musicas;
  }

  // Buscar por ID
  Future<DTOMusica?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabelaMusica,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return await _construirMusicaCompleta(maps[0], db);
    }
    return null;
  }

  // Excluir
  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.transaction((txn) async {
      // Remover links de vídeo-aula
      await txn.delete(
        _tabelaMusicaVideoAula,
        where: 'musica_id = ?',
        whereArgs: [id],
      );
      // Remover categorias associadas
      await txn.delete(
        _tabelaMusicaCategoria,
        where: 'musica_id = ?',
        whereArgs: [id],
      );
      // Remover música
      return await txn.delete(
        _tabelaMusica,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  // Construir DTOMusica com relacionamentos
  Future<DTOMusica?> _construirMusicaCompleta(
      Map<String, dynamic> mapa, dynamic db) async {
    try {
      // Buscar artista
      final List<Map<String, dynamic>> artistaMaps = await db.query(
        'artista_banda',
        where: 'id = ?',
        whereArgs: [mapa['artista_id']],
      );
      if (artistaMaps.isEmpty) {
        debugPrint('Artista não encontrado para musica id: ${mapa['id']}');
        return null;
      }
      final artista = DTOArtistaBanda(
        id: artistaMaps[0]['id'],
        nome: artistaMaps[0]['nome'],
        descricao: artistaMaps[0]['descricao'],
        link: artistaMaps[0]['link'],
        foto: artistaMaps[0]['foto'],
        ativo: artistaMaps[0]['ativo'] == 1,
      );

      // Buscar categorias
      final List<Map<String, dynamic>> categoriaMaps = await db.query(
        'categoria_musica',
        where:
            'id IN (SELECT categoria_id FROM musica_categoria WHERE musica_id = ?)',
        whereArgs: [mapa['id']],
      );
      final categorias = categoriaMaps
          .map((c) => DTOCategoriaMusica(
                id: c['id'],
                nome: c['nome'],
                ativa: c['ativo'] == 1,
              ))
          .toList();

      // Buscar links de vídeo-aula
      final List<Map<String, dynamic>> videoMaps = await db.query(
        _tabelaMusicaVideoAula,
        where: 'musica_id = ?',
        whereArgs: [mapa['id']],
      );
      final linksVideoAula = videoMaps
          .map((v) => DTOLinkVideoAula(
                url: v['url'],
                descricao: v['descricao'],
              ))
          .toList();

      return DTOMusica(
        id: mapa['id'],
        nome: mapa['nome'],
        artista: artista,
        categorias: categorias,
        linksVideoAula: linksVideoAula,
        descricao: mapa['descricao'],
        ativo: mapa['ativo'] == 1,
      );
    } catch (e) {
      debugPrint('Erro ao construir DTOMusica: $e');
      return null;
    }
  }
}
