import 'package:essential_youtube/YouTube_player.dart';
import 'package:essential_youtube/api-key.dart';

import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoApp(),
    );
  }
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  static String key = apiKey;
  TextEditingController _searchTextController = TextEditingController();

  YoutubeAPI ytApi = YoutubeAPI(key);
  List<YT_API> ytResult = [];

  callAPI() async {
    String query = "TED";
    ytResult = await ytApi.search(query);
    ytResult = await ytApi.nextPage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callAPI();
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Essential YouTube'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchTextController,
            onSubmitted: (value) {
              // Navigator.of(context).pop();
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return DemoApp();
              //     },
              //   ),
              // );
              setState(() {
                ytResult = null;
              });
              setState(() {
                ytApi.search(value).then((value) {
                  setState(() {
                    ytResult = value;
                  });
                });
                ytApi.nextPage().then((value) {
                  setState(() {
                    ytResult = value;
                  });
                });
              });
            },
          ),
          ytResult != null
              ? Expanded(
                  child: ListView.builder(
                    itemCount: ytResult.length,
                    itemBuilder: (_, int index) => listItem(index),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Center(
                        child: Text(
                          'Searching Essential',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget listItem(index) {
    return GestureDetector(
      onTap: () async {
        print(ytResult[index].url);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Player(
                  url: YoutubePlayer.convertUrlToId(ytResult[index].url),
                  title: ytResult[index].title);
            },
          ),
        );
      },
      child: Card(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7.0),
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Image.network(
                ytResult[index].thumbnail['default']['url'],
              ),
              Padding(padding: EdgeInsets.only(right: 20.0)),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text(
                      ytResult[index].title,
                      softWrap: true,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 1.5)),
                    Text(
                      ytResult[index].channelTitle,
                      softWrap: true,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 3.0)),
                    Text(
                      ytResult[index].url,
                      softWrap: true,
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
}
