import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_email.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_senha.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _fazerLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, Rotas.dashboardProfessora);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login SpimFlow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CampoEmail(controle: _emailController),
              CampoSenha(
                controle: _senhaController,
                rotulo: 'Usuário',
                dica: 'Informe a senha',
                mensagemErro: Erro.obrigatorio,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _fazerLogin,
                child: const Text('Entrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}