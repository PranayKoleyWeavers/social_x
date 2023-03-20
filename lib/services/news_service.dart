// import 'dart:convert';

// import 'package:social_x/model/news_model.dart';
// import 'package:http/http.dart' as http;

//  fetchAlbum() async {
//   final http.Response response = await http.get(Uri.parse(
//       'http://newsapi.org/v2/top-headlines?country=id&category=business&apiKey=e23aecd6cac546658f88653a5550ba98'));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Articles.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }
