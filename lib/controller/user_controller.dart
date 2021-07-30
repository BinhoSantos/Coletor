class codigo_barras {
  //lembrar de consertar isso aqui depois
  int? id;
  String? codigo;
  int? quantidade;

  codigo_barras(this.id, this.codigo, this.quantidade);

  //ToMap codifica as informações para Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'codigo': codigo,
      'quantidade': quantidade,
    };
    return map;
  }

  //FromMap decodifica as informações que antes eram Map
  codigo_barras.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    codigo = map['codigo'];
    quantidade = map['quantidade'];
  }

  @override
  String toString() {
    String teste = "\n";
    String Space = "         ";
    String resultado = ('$codigo : $quantidade');
    /*String resultado = ('{' +
        teste +
        Space +
        'quantidade:"$quantidade"' +
        teste +
        Space +
        'codigo:"$codigo"' +
        teste +
        '}')*/
    ;
    // Retorna os valores como String
    //return "codigo_barras => (id: $id, codigo: $codigo, quantidade: $quantidade)";
    return resultado;
    //('quantidade:"$quantidade" codigo"$codigo"');
  }
}
