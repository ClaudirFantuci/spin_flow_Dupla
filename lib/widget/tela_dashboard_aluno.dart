import 'package:flutter/material.dart';

class TelaDashboardAluno extends StatelessWidget {
  const TelaDashboardAluno({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Aluno'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPerfilAluno(),
            const SizedBox(height: 24),
            _buildStatusAulas(),
            const SizedBox(height: 24),
            _buildAcoesRapidas(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfilAluno() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/147/147144.png'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'João Silva',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Aluno de Spinning',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusAulas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Status das Aulas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Aulas concluídas este mês'),
            trailing: Text('8'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.access_time, color: Colors.orange),
            title: Text('Aulas agendadas'),
            trailing: Text('3'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.star, color: Colors.blue),
            title: Text('Desafios completados'),
            trailing: Text('2'),
          ),
        ),
      ],
    );
  }

  Widget _buildAcoesRapidas(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ações Rápidas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            // Navegar para tela de marcação de bike
          },
          icon: const Icon(Icons.pedal_bike),
          label: const Text('Marcar Bike'),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            // Navegar para tela de desafios
          },
          icon: const Icon(Icons.emoji_events),
          label: const Text('Desafios'),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            // Navegar para tela de aulas particulares
          },
          icon: const Icon(Icons.schedule),
          label: const Text('Aulas Particulares'),
        ),
      ],
    );
  }
}
