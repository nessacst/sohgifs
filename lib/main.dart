import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    //theme: ThemeData(hintColor: Colors.purple),
  ));
}
