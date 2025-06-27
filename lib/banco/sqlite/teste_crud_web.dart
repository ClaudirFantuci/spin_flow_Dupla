import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';
import 'dao/dao_fabricante.dart';
import 'dao/dao_categoria_musica.dart';
import '../../dto/dto_fabricante.dart';
import '../../dto/dto_categoria_musica.dart';

class TesteCRUDWeb extends StatefulWidget {
  const TesteCRUDWeb({super.key});

  @override
  State<TesteCRUDWeb> createState() => _TesteCRUDWebState();
}

class _TesteCRUDWebState extends State<TesteCRUDWeb> {
  final List<String> _logs = [];
  bool _testando = false;
  int _testesPassaram = 0;
  int _testesFalharam = 0;
  
  // Instâncias dos DAOs
  final DAOFabricante _daoFabricante = DAOFabricante();
  final DAOCategoriaMusica _daoCategoria = DAOCategoriaMusica();

  void _adicionarLog(String mensagem) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $mensagem');
    });
  }

  Future<void> _executarTestes() async {
    setState(() {
      _testando = true;
      _logs.clear();
      _testesPassaram = 0;
      _testesFalharam = 0;
    });

    try {
      _adicionarLog('🚀 Iniciando testes CRUD para Web...');
      
      // Configurar SQLite para web
      _adicionarLog('🌐 Configurando SQLite para web...');
      databaseFactory = databaseFactoryFfiWeb;
      
      // Inicializar conexão
      _adicionarLog('🔌 Inicializando conexão SQLite...');
      await ConexaoSQLite.database;
      _adicionarLog('✅ Conexão SQLite inicializada');

      // Testar Fabricante
      await _testarFabricante();
      
      // Testar CategoriaMusica
      await _testarCategoriaMusica();
      
      // Relatório final
      _mostrarRelatorioFinal();
      
      // Fechar conexão
      await ConexaoSQLite.fecharConexao();
      _adicionarLog('✅ Conexão SQLite fechada');
      
    } catch (e) {
      _adicionarLog('💥 ERRO FATAL: $e');
      _testesFalharam++;
    } finally {
      setState(() {
        _testando = false;
      });
    }
  }

  Future<void> _testarFabricante() async {
    _adicionarLog('\n🔧 TESTANDO FABRICANTE...');
    
    try {
      // CREATE
      _adicionarLog('  📝 Testando CREATE...');
      DTOFabricante fabricante = DTOFabricante(
        nome: 'Teste Fabricante Web',
        descricao: 'Descrição teste web',
        ativo: true,
      );
      
      int id = await _daoFabricante.salvar(fabricante);
      _adicionarLog('  ✅ CREATE: Fabricante criado com ID $id');
      _testesPassaram++;

      // READ
      _adicionarLog('  📖 Testando READ...');
      DTOFabricante? fabricanteLido = await _daoFabricante.buscarPorId(id);
      if (fabricanteLido != null && fabricanteLido.nome == 'Teste Fabricante Web') {
        _adicionarLog('  ✅ READ: Fabricante lido corretamente');
        _testesPassaram++;
      } else {
        _adicionarLog('  ❌ READ: Erro ao ler fabricante');
        _testesFalharam++;
      }

      // UPDATE
      _adicionarLog('  🔄 Testando UPDATE...');
      DTOFabricante fabricanteAtualizado = DTOFabricante(
        id: id,
        nome: 'Fabricante Web Atualizado',
        descricao: 'Descrição atualizada web',
        ativo: false,
      );
      await _daoFabricante.salvar(fabricanteAtualizado);
      
      DTOFabricante? fabricanteVerificado = await _daoFabricante.buscarPorId(id);
      if (fabricanteVerificado?.nome == 'Fabricante Web Atualizado') {
        _adicionarLog('  ✅ UPDATE: Fabricante atualizado corretamente');
        _testesPassaram++;
      } else {
        _adicionarLog('  ❌ UPDATE: Erro ao atualizar fabricante');
        _testesFalharam++;
      }

      // DELETE
      _adicionarLog('  🗑️ Testando DELETE...');
      await _daoFabricante.excluir(id);
      DTOFabricante? fabricanteDeletado = await _daoFabricante.buscarPorId(id);
      if (fabricanteDeletado == null) {
        _adicionarLog('  ✅ DELETE: Fabricante deletado corretamente');
        _testesPassaram++;
      } else {
        _adicionarLog('  ❌ DELETE: Erro ao deletar fabricante');
        _testesFalharam++;
      }

    } catch (e) {
      _adicionarLog('  ❌ ERRO no teste de Fabricante: $e');
      _testesFalharam++;
    }
  }

  Future<void> _testarCategoriaMusica() async {
    _adicionarLog('\n🎵 TESTANDO CATEGORIA MÚSICA...');
    
    try {
      // CREATE
      _adicionarLog('  📝 Testando CREATE...');
      DTOCategoriaMusica categoria = DTOCategoriaMusica(
        nome: 'Teste Categoria Web',
        ativa: true,
      );
      
      int id = await _daoCategoria.salvar(categoria);
      _adicionarLog('  ✅ CREATE: Categoria criada com ID $id');
      _testesPassaram++;

      // READ
      _adicionarLog('  📖 Testando READ...');
      DTOCategoriaMusica? categoriaLida = await _daoCategoria.buscarPorId(id);
      if (categoriaLida != null && categoriaLida.nome == 'Teste Categoria Web') {
        _adicionarLog('  ✅ READ: Categoria lida corretamente');
        _testesPassaram++;
      } else {
        _adicionarLog('  ❌ READ: Erro ao ler categoria');
        _testesFalharam++;
      }

      // UPDATE
      _adicionarLog('  🔄 Testando UPDATE...');
      DTOCategoriaMusica categoriaAtualizada = DTOCategoriaMusica(
        id: id,
        nome: 'Categoria Web Atualizada',
        ativa: false,
      );
      await _daoCategoria.salvar(categoriaAtualizada);
      
      DTOCategoriaMusica? categoriaVerificada = await _daoCategoria.buscarPorId(id);
      if (categoriaVerificada?.nome == 'Categoria Web Atualizada') {
        _adicionarLog('  ✅ UPDATE: Categoria atualizada corretamente');
        _testesPassaram++;
      } else {
        _adicionarLog('  ❌ UPDATE: Erro ao atualizar categoria');
        _testesFalharam++;
      }

      // DELETE
      _adicionarLog('  🗑️ Testando DELETE...');
      await _daoCategoria.excluir(id);
      DTOCategoriaMusica? categoriaDeletada = await _daoCategoria.buscarPorId(id);
      if (categoriaDeletada == null) {
        _adicionarLog('  ✅ DELETE: Categoria deletada corretamente');
        _testesPassaram++;
      } else {
        _adicionarLog('  ❌ DELETE: Erro ao deletar categoria');
        _testesFalharam++;
      }

    } catch (e) {
      _adicionarLog('  ❌ ERRO no teste de CategoriaMusica: $e');
      _testesFalharam++;
    }
  }

  void _mostrarRelatorioFinal() {
    _adicionarLog('\n📊 === RELATÓRIO FINAL ===');
    _adicionarLog('✅ Testes que passaram: $_testesPassaram');
    _adicionarLog('❌ Testes que falharam: $_testesFalharam');
    
    double taxaSucesso = _testesPassaram > 0 
        ? (_testesPassaram / (_testesPassaram + _testesFalharam)) * 100 
        : 0;
    _adicionarLog('📈 Taxa de sucesso: ${taxaSucesso.toStringAsFixed(1)}%');
    
    if (_testesFalharam == 0) {
      _adicionarLog('\n🎉 PARABÉNS! TODOS OS TESTES PASSARAM!');
    } else {
      _adicionarLog('\n⚠️ ALGUNS TESTES FALHARAM. Verifique os logs acima.');
    }
    
    _adicionarLog('=== FIM DOS TESTES ===');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste CRUD SQLite - Web'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botão de teste
            ElevatedButton(
              onPressed: _testando ? null : _executarTestes,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _testando 
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Executando testes...', style: TextStyle(color: Colors.white)),
                    ],
                  )
                : Text('🚀 EXECUTAR TESTES CRUD', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            
            SizedBox(height: 20),
            
            // Estatísticas
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('✅ Passaram', _testesPassaram.toString(), Colors.green),
                    _buildStatCard('❌ Falharam', _testesFalharam.toString(), Colors.red),
                    _buildStatCard('📊 Total', (_testesPassaram + _testesFalharam).toString(), Colors.blue),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Logs
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('📋 LOGS DOS TESTES', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () => setState(() => _logs.clear()),
                            child: Text('Limpar'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _logs.map((log) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                log,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            )).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

// Função main para web
void main() {
  runApp(MaterialApp(
    title: 'Teste CRUD SQLite',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    home: TesteCRUDWeb(),
    debugShowCheckedModeBanner: false,
  ));
} 