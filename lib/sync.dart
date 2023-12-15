import 'dart:async';
import 'dart:io';
import 'package:flutter_sync/db.dart';

class SincronizacaoService {
  bool sincronizando = false;
  Duration timeDuration = const Duration(seconds: 10);
  static const String tabela = "meus_dados";
  late Timer timer;
  MeuBancoDeDados meuBancoDeDados = MeuBancoDeDados();

  Future<void> _sincronizarTabela1() async {
    print('sincronizando tabela 1');

    List<Map<String, dynamic>> registros = [];

    try {
      registros = await meuBancoDeDados.registros();
    } catch (e) {
      throw Exception("Erro ao tentar acessar os registros da tabela 1 $e");
    }

    for (Map<String, dynamic> registro in registros) {
      try {
        final Map<String, dynamic> corpo = {
          "id": registro['id'],
          "numero": registro["numero"],
          "ano": registro["ano"],
        };
        int statusSincronizando = 33;

        await MeuBancoDeDados.alterarSincronismo(
            corpo['id'], statusSincronizando);

        // final http.Response resposta = await http.post(
        //   urlBase,
        //   body: corpo,
        // );

        // if (resposta.statusCode != 200) {
        //   throw Exception("Erro ao sincronizar: ${resposta.statusCode}");
        //  await meuBancoDeDados.updateSincronismo(corpo['id'], 0);
        // }

        print('${corpo['numero']}/${corpo['ano']}');

        await MeuBancoDeDados.alterarSincronismo(registro['id'], 1);
      } catch (e) {
        throw Exception(
            "Erro ao tentar sincronizar os registro de id ${registro['id']} da tabela 1 $e");
      }
      sleep(const Duration(milliseconds: 10));
    }
    print('tabela 1 sincronizada');
  }

  void executarSincronizacao() {
    if (!sincronizando) {
      sincronizando = true;
      try {
        timer = Timer.periodic(timeDuration, (t) {
          _sincronizarTabela1();
          // sincronizarTabela2();
          // sincronizarTabela3();
        });
      } catch (e) {
        throw Exception("Erro Ao Iniciar Sincronismo: $e");
      }
      print("Sincronismo Iniciado");
    }
  }

  void finalizarSincronizacao() {
    if (sincronizando) {
      try {
        timer.cancel();

        sincronizando = false;
      } catch (e) {
        throw Exception("Erro Ao Finalizar Sincronismo: $e");
      }
      print("Sincronismo Finalizado");
    }
  }
}
