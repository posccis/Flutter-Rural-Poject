import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Generator',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  @override
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final tiles = _saved.map((WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();
      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    String texto1 = "";
    String texto2 = "";

    return Dismissible(
      key: Key(pair.toString()),
      onDismissed: (direction) {
        setState(() {
          _suggestions.remove(pair);
          _saved.remove(pair);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$pair dismissed')));
      },
      background: Container(
        color: Colors.red,
      ),
      child: ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: new IconButton(
          onPressed: () {
            setState(() {
              if (alreadySaved) {
                _saved.remove(pair);
              } else {
                _saved.add(pair);
              }
            });
          },
          icon: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.blue : null,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(pair.toString()),
                ),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Editar",
                          style: _biggerFont,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            height: 40,
                            width: 200,
                            child: TextField(
                              onChanged: (text1) {
                                texto1 = text1;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(100.0),
                          child: Container(
                            height: 40,
                            width: 200,
                            child: TextField(
                              onChanged: (text2) {
                                texto2 = text2;
                              },
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _suggestions[_suggestions.indexOf(pair)] =
                                    WordPair(texto1, texto2);
                                if (alreadySaved) {
                                  _saved[_saved.indexOf(pair)] =
                                      WordPair(texto1, texto2);
                                }
                              });
                            },
                            child: Text("Editar"))
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name Generator'),
        actions: [
          IconButton(onPressed: _pushSaved, icon: Icon(Icons.list)),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
