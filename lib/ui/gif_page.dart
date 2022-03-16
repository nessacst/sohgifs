import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]), // título do gif
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
                Share.share(_gifData["images"]["fixed_height"]
                    ["url"]); // link compartilhamento
              },
              icon: Icon(Icons.share))
        ],
      ),
      backgroundColor: Colors.green,
      body: Center(
        // ao abrir o gif
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
