import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/usecases/GerarRelatoriosUseCase.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  DateTime _inicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fim = DateTime.now();
  List<Map<String, dynamic>> _dados = [];
  bool _isLoading = false;

  Future<void> _gerar() async {
    setState(() => _isLoading = true);
    try {
      _dados = await getIt<GerarRelatoriosUseCase>().execute(_inicio, _fim);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios Gerenciais')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Período'),
            subtitle: Text('${_inicio.day}/${_inicio.month} até ${_fim.day}/${_fim.month}'),
            trailing: const Icon(Icons.date_range),
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDateRange: DateTimeRange(start: _inicio, end: _fim),
              );
              if (picked != null) {
                setState(() {
                  _inicio = picked.start;
                  _fim = picked.end;
                });
              }
            },
          ),
          ElevatedButton(onPressed: _gerar, child: const Text('GERAR RELATÓRIO')),
          const Divider(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _dados.length,
                    itemBuilder: (context, index) {
                      final item = _dados[index];
                      return ListTile(
                        title: Text('Total de Empréstimos no período: ${item['totalEmprestimos']}'),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
