import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nomes de Bandas',
        theme: ThemeData(primaryColor: Colors.red),
        home: ListStatelessWidget());
  }
}

class ListStatelessWidget extends StatelessWidget {
  const ListStatelessWidget({Key? key}) : super(key: key);

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.red, width: 0.3),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              document.get('Nome de Banda'),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(padding: const EdgeInsets.all(25.0)),
          Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 35.5,
              height: 70.0,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(7.5),
              child: Text(
                document.get('Votos').toString(),
                style: Theme.of(context).textTheme.headline4,
              )),
        ],
      ),
      onTap: () {
        document.reference.update({'Votos': document['Votos'] + 1});
      },
    );
  }

  Widget constroi(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nomes de Bandas'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Nomes de bandas')
              .snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data!.docs;
            if (!snapshot.hasData) return const Text('Carregando...');

            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) =>
                  _buildListItem(context, data[index]),
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Deu erro!');
          if (snapshot.connectionState == ConnectionState.done)
            return constroi(context);
          return const Text('Loading...');
        });
  }
}
