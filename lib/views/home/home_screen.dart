import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:social_x/constants/appcolor.dart';
import 'package:social_x/constants/images.dart';
import 'package:social_x/model/news_model.dart';
import 'package:social_x/services/news_service.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Album album = Album();
  fetchAlbum() async {
    Album album1 = Album();

    final http.Response response = await http.get(Uri.parse(
        'http://newsapi.org/v2/top-headlines?country=id&category=business&apiKey=e23aecd6cac546658f88653a5550ba98'));
    album1 = albumFromJson(response.body);
    if (response.statusCode == 200) {
      setState(() {
        album = album1;
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          title: Row(
            children: [
              Icon(
                Icons.search,
                weight: 5,
                color: AppColor.mediumBlue,
                size: 40,
                shadows: const [
                  BoxShadow(
                    blurRadius: 8,
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Search in feed',
                style: TextStyle(
                  color: AppColor.mediumBlue,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        body: ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              // debugPrint('===================${article.title}');

              return album.status!.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text.rich(
                                      TextSpan(
                                        text: '2 hours ago ',
                                        children: [
                                          TextSpan(
                                            text: 'BBC News',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListTile(
                                    title: Text(
                                      album.articles![index].title ?? "",
                                      style: TextStyle(
                                        color: AppColor.deepBlue,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        album.articles![index].description ??
                                            "",
                                        style: TextStyle(
                                          color: AppColor.lightBlue,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    trailing: Image.network(
                                      album.articles![index].urlToImage ?? "",
                                      height: 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
            }),

        // body: Column(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(top: 20),
        //       child: Card(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         elevation: 5,
        //         margin: const EdgeInsets.symmetric(horizontal: 15),
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(vertical: 15),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               const Padding(
        //                 padding: EdgeInsets.only(left: 15),
        //                 child: Text.rich(
        //                   TextSpan(
        //                     text: '2 hours ago ',
        //                     children: [
        //                       TextSpan(
        //                         text: 'BBC News',
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               ListTile(
        //                 title: Text(
        //                   title,
        //                   style: TextStyle(
        //                     color: AppColor.deepBlue,
        //                     fontSize: 18,
        //                   ),
        //                 ),
        //                 subtitle: Padding(
        //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
        //                   child: Text(
        //                     description,
        //                     style: TextStyle(
        //                       color: AppColor.lightBlue,
        //                       fontSize: 12,
        //                     ),
        //                   ),
        //                 ),
        //                 trailing: Image.asset(
        //                   StringImage.googleIcon,
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
