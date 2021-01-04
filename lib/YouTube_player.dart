import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Player extends StatefulWidget {
  String url, title;
  Player({this.url, this.title});
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  YoutubePlayerController _youtubePlayerController;
  YoutubePlayerValue _playerValue;
  @override
  void initState() {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.url,
      flags: YoutubePlayerFlags(
        controlsVisibleAtStart: true,
        autoPlay: true,
        forceHD: false,
        hideControls: false,
        disableDragSeek: true,
        hideThumbnail: true,
      ),
    );

    _playerValue = YoutubePlayerValue(
      playbackQuality: _youtubePlayerController.value.playbackQuality,
    );
    super.initState();
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: YoutubePlayer(
          controller: _youtubePlayerController,
          actionsPadding: EdgeInsets.all(20),
          // bufferIndicator: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
