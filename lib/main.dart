import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Corrigido
import 'app/app.dart';
import 'app/config/injection.dart';
import 'core/services/SeedService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carregar variáveis de ambiente
  await dotenv.load(fileName: ".env");
  
  // Inicializar Injeção de Dependência
  await setupInjection();
  
  // Rodar Seed (Administrador Inicial)
  await getIt<SeedService>().inicializar();

  runApp(const MyApp());
}
