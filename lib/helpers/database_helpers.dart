import 'package:coletor_nativo/controller/user_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._createInstance();
  static Database? _database;

  String colCodBarrasTable = "Codigo_barras";
  String colId = "id";
  String colCodigo = "codigo";
  String colQuantidade = "quantidade";

  // static DatabaseHelper instance = DatabaseHelper();
  //Construtor nomeado para criar a instancia
  DatabaseHelper._createInstance();

  // DatabaseHelper _databaseHelper = DatabaseHelper._createInstance();

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  //Inicializa o banco de dados
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "codigo_barras.db";

    var codBarrasDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return codBarrasDatabase;
  }

  //Cria o banco de dados na primeira passagem
  void _createDB(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $colCodBarrasTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colCodigo TEXT, $colQuantidade INTEGER)"); //, $colNome TEXT
  }

  //Insere um código de barras dentro do banco de dados
  Future<int> insertCodBarra(codigo_barras codigoBarras) async {
    Database db = await this.database;

    var resultado = db.insert(colCodBarrasTable, codigoBarras.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return resultado;
  }

  //Seleciona o codigo de barras pelo ID
  Future<codigo_barras?> getCodBarrasPerId(int id) async {
    Database db = await this.database;

    List<Map> maps = await db.query(colCodBarrasTable,
        columns: [colId, colCodigo, colQuantidade],
        where: "$colId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return codigo_barras.fromMap(maps.first);
    } else {
      return null;
    }
  }

  //Convertendo em lista para aparecer no Formulário
  Future<List<codigo_barras>> getCodBarras() async {
    Database db = await this.database;

    var resultado = await db.query(colCodBarrasTable);

    List<codigo_barras> lista = resultado.isNotEmpty
        ? resultado.map((c) => codigo_barras.fromMap(c)).toList()
        : [];

    return lista;
  }

  //Altera o código de barras dentro do banco pelo ID
  Future<int> updateCodBarras(codigo_barras codBarras) async {
    var db = await this.database;

    var resultado = await db.update(colCodBarrasTable, codBarras.toMap(),
        where: '$colId = ?', whereArgs: [codBarras.id]);

    return resultado;
  }

  //Altera o código de barras dentro do banco pelo Numero do Codigo
  Future<int> updateCodBarrasPerCodigo(codigo_barras codBarras) async {
    var db = await this.database;
    var resultado = await db.update(colCodBarrasTable, codBarras.toMap(),
        where: '$colCodigo = ?', whereArgs: [codBarras.codigo]);
    return resultado;
  }

  //Deleta o codigo de barras pelo ID
  Future<int> deleteCodBarras(int id) async {
    var db = await this.database;

    var resultado = await db
        .delete(colCodBarrasTable, where: '$colId = ?', whereArgs: [id]);

    return resultado;
  }

  //Deleta o codigo de barras pelo Codigo
  Future<int> deleteCodBarrasStr(int codigo) async {
    var db = await this.database;

    var resultado = await db.delete(colCodBarrasTable,
        where: '$colCodigo = ?', whereArgs: [codigo]);

    return resultado;
  }

  //Deleta todos os códigos registrados até o momento
  Future<int> deleteCodBarrasAll() async {
    var db = await this.database;
    var resultado = await db.delete(colCodBarrasTable);
    return resultado;
  }

  //Soma a quantidade de código de barras via ID
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $colCodBarrasTable");
    int? resultado = Sqflite.firstIntValue(x);
    return resultado!;
  }

  //Fecha a conexão com o banco
  Future close() async {
    Database db = await this.database;
    db.close();
  }

  //Convertendo em lista para aparecer no Formulário
  Future<List<codigo_barras>> getCodBarrasGroup() async {
    Database db = await this.database;

    var resultado = await db.query(colCodBarrasTable, groupBy: colCodigo);

    List<codigo_barras> lista = resultado.isNotEmpty
        ? resultado.map((c) => codigo_barras.fromMap(c)).toList()
        : [];

    return lista;
  }

  //Lista que puxa os valores contados
  Future<List<codigo_barras>> getCodBarrasCount() async {
    Database db = await this.database;

    var resultado = await db.rawQuery(
        'SELECT $colCodigo, SUM($colQuantidade) AS quantidade FROM $colCodBarrasTable GROUP BY $colCodigo');

    List<codigo_barras> lista = resultado.isNotEmpty
        ? resultado.map((c) => codigo_barras.fromMap(c)).toList()
        : [];

    return lista;
  }

  //Lista que puxa os valores contados
  Future<List<codigo_barras>> getCodBarraRepetido(String valor) async {
    Database db = await this.database;

    var resultado = await db.rawQuery(
        'SELECT $colCodigo, SUM($colQuantidade) AS quantidade FROM $colCodBarrasTable WHERE $colCodigo = $valor');

    List<codigo_barras> lista = resultado.isNotEmpty
        ? resultado.map((c) => codigo_barras.fromMap(c)).toList()
        : [];

    print(lista);
    return lista;
  }

  //Altera o código de barras dentro do banco pelo CODIGO
  Future<List> updateQtdCodBarras(String valor) async {
    var db = await this.database;
    List<codigo_barras> teste = <codigo_barras>[];
    getCodBarraRepetido(valor).then((value) => teste = value);

    if (teste.isEmpty) {
      print(teste);
      return teste;
    } else {
      var resultado = await db.rawQuery(
          'UPDATE $colCodBarrasTable SET $colQuantidade = $colQuantidade + 1 WHERE $colCodigo = $valor');

      List<codigo_barras> lista = resultado.isNotEmpty
          ? resultado.map((c) => codigo_barras.fromMap(c)).toList()
          : [];
      print(lista);
      return lista;
    }
  }
}
