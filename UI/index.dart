import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dam_u3practica2_platillos/FIREBASE/configuracion.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "FoodiEs!",
          style: GoogleFonts.marhey(
            textStyle:
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 38,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
      body:
      Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1, 3),
                        blurRadius: 1.5
                    )
                  ]
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Seleccionar platillo',
                    style: GoogleFonts.ubuntuCondensed(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 26,
                            letterSpacing: 1
                        )
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(child: FutureBuilder(
                future: Fire.mostrarColeccion(),
                builder: (context, lista){
                  return ListView.builder(
                    itemCount: lista.data?.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text('${lista.data?[i]['nombrePlatillo'] ?? 'Platillo no disponible'}', style: TextStyle(fontSize: 18),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${lista.data?[i]['precio']} mxn  -- ${lista.data?[i]['calorias']} Kcal',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    '${lista.data?[i]['descripcion'] ?? ''}', // Agrega la descripción aquí
                                    style: TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                  onPressed: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirmación'),
                                          content: Text('¿Estás seguro de que deseas eliminar esto?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Cerrar el diálogo
                                              },
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Fire.eliminar(lista.data?[i]['id']);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Eliminar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.delete)
                              ),
                              onTap: (){
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      Map<String, dynamic> p = {
                                        'id':lista.data?[i]['id'],
                                        'nombrePlatillo':lista.data?[i]['nombrePlatillo'],
                                        'precio':lista.data?[i]['precio'],
                                        'calorias':lista.data?[i]['calorias'],
                                        'descripcion':lista.data?[i]['descripcion'],
                                      };
                                      return Padding(
                                          padding: MediaQuery.of(context).viewInsets,
                                          child: contenido(p),
                                      );
                                    }
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 12), // Agregar un SizedBox con la altura que desees
                        ],
                      );
                    },
                  );

                }
            ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        nombrePlatillo.clear();
        precio.clear();
        calorias.clear();
        descripcion.clear();
        
        setState(() {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: insertar(),
                );
              }
          );

        });
      },
      child: Icon(Icons.add),
      ),
    );
  }

  final nombrePlatillo = TextEditingController();
  final precio = TextEditingController();
  final calorias = TextEditingController();
  final descripcion = TextEditingController();

  Widget contenido(Map<String, dynamic> p) {

    if(nombrePlatillo.text.isEmpty){
      nombrePlatillo.text = p['nombrePlatillo'] ?? '';
      precio.text = p['precio']?.toString() ?? '';
      calorias.text = p['calorias'] ?? '';
      descripcion.text = p['descripcion'] ?? '';
    }

    return Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: 75,),
            Text('Información del platillo', style: TextStyle(
              fontSize: 30,
            ),),
            SizedBox(height: 20,),
            TextField(
              controller: nombrePlatillo,
              decoration: InputDecoration(
                labelText: 'Nombre platillo...',
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: precio,
              decoration: InputDecoration(
                labelText: 'Precio...',
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: calorias,
              decoration: InputDecoration(
                labelText: 'Calorias...',
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: descripcion,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descripción...',
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      nombrePlatillo.text = precio.text = descripcion.text = calorias.text = '';
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar')),
                SizedBox(width: 20,),
                ElevatedButton(
                    onPressed: (){
                      p['nombrePlatillo'] = nombrePlatillo.text;
                      p['precio'] = int.parse(precio.text);
                      p['calorias'] = calorias.text;
                      p['descripcion'] = descripcion.text;
                      setState(() {
                        Fire.actualizar(p);
                      });
                      nombrePlatillo.text = precio.text = descripcion.text = calorias.text = '';
                      Navigator.of(context).pop();
                    },
                    child: Text('Confirmar')),
              ],
            )
          ],
        ),
    );
  }
  Widget insertar() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          SizedBox(height: 75,),
          Text('Nuevo platillo', style: TextStyle(
            fontSize: 30,
          ),),
          SizedBox(height: 20,),
          TextField(
            controller: nombrePlatillo,
            decoration: InputDecoration(
              labelText: 'Nombre platillo...',
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: precio,
            decoration: InputDecoration(
              labelText: 'Precio...',
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: calorias,
            decoration: InputDecoration(
              labelText: 'Calorias...',
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: descripcion,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Descripción...',
            ),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    nombrePlatillo.text = precio.text = descripcion.text = calorias.text = '';
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar')),
              SizedBox(width: 20,),
              ElevatedButton(
                  onPressed: (){
                    Map<String, dynamic> p = {
                      'nombrePlatillo':nombrePlatillo.text,
                      'precio': int.parse(precio.text),
                      'calorias':calorias.text,
                      'descripcion':descripcion.text,
                    };
                    setState(() {
                      Fire.insert(p);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Confirmar')),
            ],
          )
        ],
      ),
    );
  }
}