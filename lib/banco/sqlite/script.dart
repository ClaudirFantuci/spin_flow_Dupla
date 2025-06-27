class ScriptSQLite {
  // ===== COMANDOS DE CRIAÇÃO DE TABELAS =====

  static const String _criarTabelaFabricante = '''
    CREATE TABLE fabricante (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      nome_contato_principal TEXT,
      email_contato TEXT,
      telefone_contato TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaCategoriaMusica = '''
    CREATE TABLE categoria_musica (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      ativa INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaTipoManutencao = '''
    CREATE TABLE tipo_manutencao (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      ativa INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaArtistaBanda = '''
    CREATE TABLE artista_banda (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      link TEXT,
      foto TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaAluno = '''
    CREATE TABLE aluno (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      email TEXT NOT NULL,
      data_nascimento TEXT NOT NULL,
      genero TEXT NOT NULL,
      telefone TEXT NOT NULL,
      url_foto TEXT,
      instagram TEXT,
      facebook TEXT,
      tiktok TEXT,
      observacoes TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaSala = '''
    CREATE TABLE sala (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      numero_bikes INTEGER NOT NULL,
      numero_filas INTEGER NOT NULL,
      limite_bikes_por_fila INTEGER NOT NULL,
      grade_bikes TEXT,
      ativa INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaVideoAula = '''
    CREATE TABLE video_aula (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      link_video TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  // Tabela com dependência (deve ser criada após fabricante)
  static const String _criarTabelaBike = '''
    CREATE TABLE bike (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      numero_serie TEXT,
      fabricante_id INTEGER NOT NULL,
      data_cadastro TEXT NOT NULL,
      ativa INTEGER NOT NULL DEFAULT 1,
      FOREIGN KEY (fabricante_id) REFERENCES fabricante(id) ON DELETE RESTRICT
    )
  ''';

  // Variável pública com todos os comandos de criação
  static const List<String> comandosCriarTabelas = [
    _criarTabelaFabricante,
    _criarTabelaCategoriaMusica,
    _criarTabelaTipoManutencao,
    _criarTabelaArtistaBanda,
    _criarTabelaAluno,
    _criarTabelaSala,
    _criarTabelaVideoAula,
    _criarTabelaBike,
  ];

  // ===== COMANDOS DE INSERÇÃO =====

  // Inserções para Fabricante
  static const List<String> _insercoesFabricante = [
    "INSERT INTO fabricante (nome, ativo) VALUES ('Specialized', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Trek', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Giant', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Cannondale', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Scott', 1)",
  ];

  // Inserções para CategoriaMusica
  static const List<String> _insercoesCategoriaMusica = [
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Pop', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Rock', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Eletrônica', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Hip Hop', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Reggaeton', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Funk', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Sertanejo', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('MPB', 1)",
  ];

  // Inserções para TipoManutencao
  static const List<String> _insercoesTipoManutencao = [
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Pedal quebrado', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Regulagem de altura', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Pé-de-vela solto', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Correia desgastada', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Banco com problema', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Monitor com defeito', 1)",
  ];

  // Inserções para ArtistaBanda
  static const List<String> _insercoesArtistaBanda = [
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('The Weeknd', 'Artista canadense de R&B', 'https://theweeknd.com', 'https://example.com/theweeknd.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Dua Lipa', 'Cantora britânica de pop', 'https://dualipa.com', 'https://example.com/dualipa.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Imagine Dragons', 'Banda de rock alternativo', 'https://imaginedragonsmusic.com', 'https://example.com/imaginedragons.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Calvin Harris', 'DJ e produtor escocês', 'https://calvinharris.com', 'https://example.com/calvinharris.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Post Malone', 'Rapper e cantor americano', 'https://postmalone.com', 'https://example.com/postmalone.jpg', 1)",
  ];

  // Inserções para Aluno
  static const List<String> _insercoesAluno = [
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Ana Silva', 'ana.silva@email.com', '1990-05-15', 'feminino', '(11) 99999-1111', 'https://example.com/ana.jpg', 'https://instagram.com/ana.silva', 'https://facebook.com/ana.silva', 'https://tiktok.com/@ana.silva', 'Aluna dedicada', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('João Santos', 'joao.santos@email.com', '1985-08-22', 'masculino', '(11) 99999-2222', 'https://example.com/joao.jpg', 'https://instagram.com/joao.santos', 'https://facebook.com/joao.santos', 'https://tiktok.com/@joao.santos', 'Aluno iniciante', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Maria Costa', 'maria.costa@email.com', '1992-12-10', 'feminino', '(11) 99999-3333', 'https://example.com/maria.jpg', 'https://instagram.com/maria.costa', 'https://facebook.com/maria.costa', 'https://tiktok.com/@maria.costa', 'Aluna avançada', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Pedro Oliveira', 'pedro.oliveira@email.com', '1988-03-25', 'masculino', '(11) 99999-4444', 'https://example.com/pedro.jpg', 'https://instagram.com/pedro.oliveira', 'https://facebook.com/pedro.oliveira', 'https://tiktok.com/@pedro.oliveira', 'Aluno intermediário', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Lucia Ferreira', 'lucia.ferreira@email.com', '1995-07-08', 'feminino', '(11) 99999-5555', 'https://example.com/lucia.jpg', 'https://instagram.com/lucia.ferreira', 'https://facebook.com/lucia.ferreira', 'https://tiktok.com/@lucia.ferreira', 'Aluna nova', 1)",
  ];

  // Inserções para Sala
  static const List<String> _insercoesSala = [
    "INSERT INTO sala (nome, numero_bikes, numero_filas, limite_bikes_por_fila, grade_bikes, ativa) VALUES ('Sala Principal', 20, 4, 5, '[[0,0,1,0,0],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1]]', 1)",
    "INSERT INTO sala (nome, numero_bikes, numero_filas, limite_bikes_por_fila, grade_bikes, ativa) VALUES ('Sala VIP', 12, 3, 4, '[[0,0,1,0],[1,1,1,1],[1,1,1,1],[1,1,1,1]]', 1)",
    "INSERT INTO sala (nome, numero_bikes, numero_filas, limite_bikes_por_fila, grade_bikes, ativa) VALUES ('Sala Iniciantes', 15, 3, 5, '[[0,0,1,0,0],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1]]', 1)",
  ];

  // Inserções para VideoAula
  static const List<String> _insercoesVideoAula = [
    "INSERT INTO video_aula (nome, link_video, ativo) VALUES ('Aula de Spinning Iniciante', 'https://example.com/spinning_iniciante.mp4', 1)",
    "INSERT INTO video_aula (nome, link_video, ativo) VALUES ('Treino de Ritmo Avançado', 'https://example.com/ritmo_avancado.mp4', 1)",
    "INSERT INTO video_aula (nome, link_video, ativo) VALUES ('Aula de Cardio Intenso', 'https://example.com/cardio_intenso.mp4', 1)",
    "INSERT INTO video_aula (nome, link_video, ativo) VALUES ('Spinning com Música Pop', 'https://example.com/spinning_pop.mp4', 1)",
    "INSERT INTO video_aula (nome, link_video, ativo) VALUES ('Treino de Resistência', 'https://example.com/resistencia.mp4', 1)",
  ];

  // Inserções para Bike
  static const List<String> _insercoesBike = [
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Speedster X1', 'SPX123456', 1, '2025-06-01', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Trailblazer T2', 'TRB789012', 2, '2025-06-02', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Racer G3', NULL, 3, '2025-06-03', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Enduro C4', 'END456789', 4, '2025-06-04', 0)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Sprint S5', 'SPR321654', 5, '2025-06-05', 1)",
  ];

  // Variável pública com todas as inserções
  static const List<List<String>> comandosInsercoes = [
    _insercoesFabricante,
    _insercoesCategoriaMusica,
    _insercoesTipoManutencao,
    _insercoesArtistaBanda,
    _insercoesAluno,
    _insercoesSala,
    _insercoesVideoAula,
    _insercoesBike,
  ];
}