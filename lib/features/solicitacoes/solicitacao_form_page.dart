import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/usecases/EnviarSolicitacaoUseCase.dart';
import '../../core/utils/validator_helper.dart';

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
        _assuntoController.text.trim(),
        _descricaoController.text.trim(),
        _prioridade,
      );
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sucesso: Sua solicitação foi enviada para análise.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
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
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Utilize este canal para dúvidas, sugestões ou problemas técnicos.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _assuntoController,
                  decoration: const InputDecoration(
                    labelText: 'Título do Assunto',
                    hintText: 'Ex: Problema com devolução',
                  ),
                  validator: (v) => ValidatorHelper.validarObrigatorio(v, 'Assunto'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição detalhada',
                    hintText: 'Descreva aqui o que está ocorrendo...',
                  ),
                  maxLines: 4,
                  validator: (v) => ValidatorHelper.validarObrigatorio(v, 'Descrição'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _prioridade,
                  decoration: const InputDecoration(labelText: 'Grau de Prioridade'),
                  items: const [
                    DropdownMenuItem(value: 'BAIXA', child: Text('Baixa (Dúvidas)')),
                    DropdownMenuItem(value: 'MEDIA', child: Text('Média (Sugestões)')),
                    DropdownMenuItem(value: 'ALTA', child: Text('Alta (Problemas)')),
                  ],
                  onChanged: (v) => setState(() => _prioridade = v!),
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _enviar,
                        child: const Text('ENVIAR SOLICITAÇÃO AGORA'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
