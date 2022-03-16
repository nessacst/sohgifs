import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:sohgifs/ui/gif_page.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search;
  int _offSet = 0;

  Future<Map> _getGif() async {
    // função requisitiva
    http.Response response; // declaração de resposta

    if (_search == null)
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=SapCHDpzhSFWBuhbWDsHcmD7ret7Hu1W&limit=20&rating=g"));
    else
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=SapCHDpzhSFWBuhbWDsHcmD7ret7Hu1W&q=$_search&limit=19&offset=$_offSet&rating=g&lang=pt"));
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGif().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.green[800],
            title: Text(
              "Só Gifs",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            )),
        backgroundColor: Colors.green,
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Buscar",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                // faz a busca
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGif(),
                builder: (context, snapchot) {
                  switch (snapchot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (snapchot.hasError) {
                        return Container();
                      } else {
                        return _createGridfTable(context, snapchot);
                      }
                  }
                }),
          ),
        ]));
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGridfTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        // organização
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // quantos itens na horizontal
          crossAxisSpacing: 10, // espaçamento horizontal
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          // se eu não estiver pesquisando ou se não é o último item
          if (_search == null || index < snapshot.data["data"].length)
            return GestureDetector(
              // mostra
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300,
                fit: BoxFit.cover,
              ), //caminho do gif
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])),
                );
              },
              onLongPress: () {
                Share.share("Compartilhe esse gif..." +
                    snapshot.data["data"][index]["title"] +
                    " - " +
                    snapshot.data["data"][index]["images"]["fixed_height"]
                        ["url"]);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      "Carregar mais..",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offSet += 19; // carrega mais 19 gifs
                  });
                },
              ),
            );
        });
  }
}
