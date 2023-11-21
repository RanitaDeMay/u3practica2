import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore instancia = FirebaseFirestore.instance;

class Fire {

  static Future<List> mostrarColeccion() async {
    List platillos = [];

    var query = await instancia.collection('platillos').get();
    query.docs.forEach((element) {
      Map<String, dynamic> documento = element.data();
      documento.addAll({'id':element.id});
      platillos.add(documento);
    });
    return platillos;
  }
  static Future insert(Map<String, dynamic> p) async {
    return await instancia.collection('platillos').add(p);
  }
  static Future eliminar(String id) async {
    return await instancia.collection('platillos').doc(id).delete();
  }
  static Future actualizar(Map<String, dynamic> p) async {
    String id = p['id'];
    p.remove('p');
    return await instancia.collection('platillos').doc(id).update(p);
  }

}