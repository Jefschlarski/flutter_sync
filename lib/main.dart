import 'package:flutter_sync/db.dart';
import 'package:flutter_sync/sync.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MeuBancoDeDados meuBancoDeDados = MeuBancoDeDados();
    SincronizacaoService sincronizacaoService = SincronizacaoService();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Sincronismo'),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    meuBancoDeDados.zerarDb();
                  },
                  child: const Text('zerar')),
              TextButton(
                  onPressed: () {
                    meuBancoDeDados.insert();
                  },
                  child: const Text('Inserir dados')),
              TextButton(
                  onPressed: () {
                    sincronizacaoService.finalizarSincronizacao();
                  },
                  child: const Text('Parar sincronismo')),
              TextButton(
                  onPressed: () {
                    meuBancoDeDados.zerarSincronismo();
                  },
                  child: const Text('Update Sincronismo')),
              TextButton(
                  onPressed: () {
                    sincronizacaoService.executarSincronizacao();
                  },
                  child: const Text('iniciar Sincronismo')),
            ],
          ),
        ));
  }
}
