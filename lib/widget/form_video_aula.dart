import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_video_aula.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';

class FormVideoAula extends StatefulWidget {
  final DTOVideoAula? videoAula;
  const FormVideoAula({super.key, this.videoAula});

  @override
  State<FormVideoAula> createState() => _FormVideoAulaState();
}

class _FormVideoAulaState extends State<FormVideoAula> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _linkController;
  bool _ativo = true;
  final _dao = DAOVideoAula();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.videoAula?.nome ?? '');
    _linkController =
        TextEditingController(text: widget.videoAula?.linkVideo ?? '');
    _ativo = widget.videoAula?.ativo ?? true;
    debugPrint(
        'Form initialized with videoAula: ${widget.videoAula?.toString()}');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_formKey.currentState?.validate() ?? false) {
      final dto = DTOVideoAula(
        id: widget.videoAula?.id,
        nome: _nomeController.text.trim(),
        linkVideo: _linkController.text.trim().isEmpty
            ? null
            : _linkController.text.trim(),
        ativo: _ativo,
      );
      debugPrint('Saving DTO: ${dto.toString()}');
      try {
        if (dto.id == null) {
          debugPrint('Creating new video aula');
          final result = await _dao.salvar(dto);
          debugPrint('Insert result: $result');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vídeo-aula criada com sucesso')),
            );
          }
        } else {
          debugPrint('Updating video aula with id: ${dto.id}');
          final result = await _dao.update(dto);
          debugPrint('Update result: $result rows affected');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Vídeo-aula atualizada com sucesso')),
            );
          }
        }
        if (mounted) {
          Navigator.of(context).pop(dto);
        }
      } catch (e) {
        debugPrint('Error saving video aula: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar: $e')),
          );
        }
      }
    } else {
      debugPrint('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoAula != null && widget.videoAula!.id == null) {
      debugPrint(
          'Warning: videoAula has null id: ${widget.videoAula.toString()}');
      return const Scaffold(
        body: Center(child: Text('Erro: Vídeo-aula inválida')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.videoAula == null ? 'Nova Vídeo-aula' : 'Editar Vídeo-aula'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvar,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Informe o nome da vídeo-aula'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link do vídeo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final urlPattern = r'^(http|https):\/\/';
                    if (!RegExp(urlPattern).hasMatch(value.trim())) {
                      return 'Informe uma URL válida (http ou https)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                value: _ativo,
                onChanged: (v) => setState(() => _ativo = v),
                title: const Text('Ativa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
