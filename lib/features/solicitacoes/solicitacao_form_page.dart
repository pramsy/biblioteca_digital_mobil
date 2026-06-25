import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/usecases/EnviarSolicitacaoUseCase.dart';

class SolicitacaoFormPage extends StatefulWidget {
  const SolicitacaoFormPage({super.key});

  @override
  State<SolicitacaoFormPage> createState() => _SolicitacaoFormPageState();
}

class _SolicitacaoFormPageState extends State<SolicitacaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _assuntoController = TextEditingController();
  final _descricaoController = TextEditingController();
  String _prioridade = 'MEDIA';
  bool _isLoading = false;

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await getIt<EnviarSolicitacaoUseCase>().execute(
        _assuntoController.text,
        _descricaoController.text,
        _prioridade,
      );
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitação enviada com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Solicitação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _assuntoController,
                  decoration: const InputDecoration(labelText: 'Assunto'),
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 4,
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _prioridade,
                  decoration: const InputDecoration(labelText: 'Prioridade'),
                  items: const [
                    DropdownMenuItem(value: 'BAIXA', child: Text('Baixa')),
                    DropdownMenuItem(value: 'MEDIA', child: Text('Média')),
                    DropdownMenuItem(value: 'ALTA', child: Text('Alta')),
                  ],
                  onChanged: (v) => setState(() => _prioridade = v!),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _enviar,
                        child: const Text('ENVIAR SOLICITAÇÃO'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
