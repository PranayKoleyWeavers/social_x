import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:social_x/constants/appcolor.dart';
import 'package:social_x/constants/images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = 'Apple admits slowing dfiufg rihsf sdihud dfhug';
  String description =
      'fdihufg dgikdf dkjvbdf gdfkbdf fdbfid difdf gdfiubgdf fgdiug dfgh';
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
        body: Column(
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
                          title,
                          style: TextStyle(
                            color: AppColor.deepBlue,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            description,
                            style: TextStyle(
                              color: AppColor.lightBlue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        trailing: Image.asset(
                          StringImage.googleIcon,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
