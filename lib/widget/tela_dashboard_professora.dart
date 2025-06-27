import 'package:flutter/material.dart';

import '../configuracoes/rotas.dart';

class TelaDashboardProfessora extends StatefulWidget {
  const TelaDashboardProfessora({super.key});

  @override
  State<TelaDashboardProfessora> createState() =>
      _TelaDashboardProfessoraState();
}

class _TelaDashboardProfessoraState extends State<TelaDashboardProfessora>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _abas = const [
    Tab(icon: Icon(Icons.dashboard), text: 'Visão Geral'),
    Tab(icon: Icon(Icons.folder_copy), text: 'Cadastros'),
    Tab(icon: Icon(Icons.list), text: 'Listas'),
    Tab(icon: Icon(Icons.event), text: 'Aulas'),
    Tab(icon: Icon(Icons.build), text: 'Manutenção'),
    Tab(icon: Icon(Icons.chat), text: 'Recados'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _abas.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard da Professora'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _abas,
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _visaoGeral(),
          _cadastros(),
          _listas(),
          _aulasEAuloes(),
          _manutencao(),
          _recados(),
        ],
      ),
    );
  }

  Widget _visaoGeral() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: const [
        _InfoCard(titulo: 'Recados', valor: '3', icone: Icons.message),
        _InfoCard(titulo: 'Alunos Ativos', valor: '82', icone: Icons.person),
        _InfoCard(
            titulo: 'Aulas Agendadas', valor: '12', icone: Icons.schedule),
        _InfoCard(
            titulo: 'Mix de Músicas', valor: '4', icone: Icons.music_note),
        _InfoCard(
            titulo: 'Bikes OK', valor: '18', icone: Icons.directions_bike),
      ],
    );
  }

  Widget _cadastros() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Cadastros Simples',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _CadastroTile('Fabricante', Icons.factory, () {
          Navigator.pushNamed(context, Rotas.cadastroFabricante);
        }),
        _CadastroTile('Sala', Icons.meeting_room, () {
          Navigator.pushNamed(context, Rotas.cadastroSala);
        }),
        _CadastroTile('Tipo de Manutenção', Icons.build, () {
          Navigator.pushNamed(context, Rotas.cadastroTipoManutencao);
        }),
        _CadastroTile('Categorias de Música', Icons.category, () {
          Navigator.pushNamed(context, Rotas.cadastroCategoriaMusica);
        }),
        _CadastroTile('Vídeo-aula', Icons.ondemand_video, () {
          Navigator.pushNamed(context, Rotas.cadastroVideoAula);
        }),
        _CadastroTile('Artistas/Bandas', Icons.music_video, () {
          Navigator.pushNamed(context, Rotas.cadastroArtistaBanda);
        }),
        _CadastroTile('Alunos', Icons.person, () {
          Navigator.pushNamed(context, Rotas.cadastroAluno);
        }),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Cadastros com Associações',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _CadastroTile('Bikes', Icons.directions_bike, () {
          Navigator.pushNamed(context, Rotas.cadastroBike);
        }),
        _CadastroTile('Músicas', Icons.library_music, () {
          Navigator.pushNamed(context, Rotas.cadastroMusica);
        }),
        _CadastroTile('Mix', Icons.queue_music, () {
          Navigator.pushNamed(context, Rotas.cadastroMix);
        }),
        _CadastroTile('Turmas', Icons.group, () {
          Navigator.pushNamed(context, Rotas.cadastroTurma);
        }),
        _CadastroTile('Grupos de Alunos', Icons.groups, () {
          Navigator.pushNamed(context, Rotas.cadastroGrupoAlunos);
        }),
      ],
    );
  }

  Widget _listas() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Listas Simples',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _CadastroTile('Fabricantes', Icons.factory, () {
          Navigator.pushNamed(context, Rotas.listaFabricantes);
        }),
        _CadastroTile('Categorias de Música', Icons.category, () {
          Navigator.pushNamed(context, Rotas.listaCategoriasMusica);
        }),
        _CadastroTile('Tipos de Manutenção', Icons.build, () {
          Navigator.pushNamed(context, Rotas.listaTiposManutencao);
        }),
        _CadastroTile('Artistas/Bandas', Icons.music_video, () {
          Navigator.pushNamed(context, Rotas.listaArtistasBandas);
        }),
        _CadastroTile('Alunos', Icons.person, () {
          Navigator.pushNamed(context, Rotas.listaAlunos);
        }),
        _CadastroTile('Salas', Icons.room, () {
          Navigator.pushNamed(context, Rotas.listaSalas);
        }),
        _CadastroTile('Vídeo-aula', Icons.ondemand_video, () {
          Navigator.pushNamed(context, '/lista-video-aula');
        }),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Listas com Associações',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _CadastroTile('Bikes', Icons.directions_bike, () {
          Navigator.pushNamed(context, Rotas.listaBikes);
        }),
        _CadastroTile('Músicas', Icons.library_music, () {
          Navigator.pushNamed(context, Rotas.listaMusicas);
        }),
        _CadastroTile('Mixes', Icons.queue_music, () {
          Navigator.pushNamed(context, Rotas.listaMixes);
        }),
        _CadastroTile('Turmas', Icons.group, () {
          Navigator.pushNamed(context, Rotas.listaTurmas);
        }),
        _CadastroTile('Grupos de Alunos', Icons.groups, () {
          Navigator.pushNamed(context, Rotas.listaGruposAlunos);
        }),
      ],
    );
  }

  Widget _aulasEAuloes() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _CadastroTile('Aulas Regulares', Icons.calendar_today, () {}),
        _CadastroTile('Aulões Especiais', Icons.star, () {}),
      ],
    );
  }

  Widget _manutencao() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _CadastroTile('Bikes', Icons.directions_bike, () {}),
        _CadastroTile('Manutenção de Bikes', Icons.build, () {}),
      ],
    );
  }

  Widget _recados() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _CadastroTile('Recados para Alunos', Icons.message, () {}),
        _CadastroTile('Recados para Turmas', Icons.announcement, () {}),
        _CadastroTile('Recados para Grupos', Icons.group, () {}),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;

  const _InfoCard({
    required this.titulo,
    required this.valor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 40, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              valor,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _CadastroTile extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback onTap;

  const _CadastroTile(this.titulo, this.icone, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icone),
      title: Text(titulo),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
