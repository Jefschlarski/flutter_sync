import 'package:sqflite/sqflite.dart';

class MeuBancoDeDados {
  static const String nomeBancoDeDados = "meu_banco.db";
  static const String tabela = "meus_dados";
  int valor = 0;
  static Future<Database> getDatabase() async {
    return await openDatabase(
      nomeBancoDeDados,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $tabela (id INTEGER PRIMARY KEY, numero INTEGER, ano INTEGER, sincronismo INTEGER)",
        );
      },
    );
  }

  static Future<void> inserirDados(int numero, int ano, int sincronismo) async {
    final Database db = await getDatabase();

    await db.insert(
      tabela,
      {
        "numero": numero,
        "ano": ano,
        "sincronismo": sincronismo,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> alterarSincronismo(int id, int sincronismo) async {
    try {
      final Database db = await getDatabase();

      await db.update(
        tabela,
        {
          "sincronismo": sincronismo,
        },
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception(
          "Erro ao tentar alterar o sincrinismo do item com id $id da tabela 1.  $e");
    }
  }

  Future<void> zerarSincronismo() async {
    final Database db = await getDatabase();

    await db.update(
      tabela,
      {
        "sincronismo": 0,
      },
    );
  }

  Future<List<Map<String, dynamic>>> registros() async {
    final Database db = await getDatabase();
    return await db.query(
      tabela,
      where: "sincronismo = ?",
      whereArgs: [0],
    );
  }

  Future<void> zerarDb() async {
    final Database db = await getDatabase();
    await db.delete(tabela);
  }

  Future<void> insert() async {
    valor = valor + 1;
    await MeuBancoDeDados.inserirDados(valor, 2023, 0);
  }
}
