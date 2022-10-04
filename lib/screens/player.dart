import 'dart:convert';

import 'package:cantor/screens/music_player.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/song.dart';

Future<List<Song>> getTopSongsList() async {
  final response = await http.get(Uri.parse(
      'https://api.napster.com/v2.2/tracks/top?apikey=ZTk2YjY4MjMtMDAzYy00MTg4LWE2MjYtZDIzNjJmMmM0YTdm&range=life'));
  if (response.statusCode == 200) {
    var responseJSON = jsonDecode(response.body);
    List<Song> songsList = [];
    for (var song in responseJSON["tracks"]) {
      Song newSong = Song(
        name: song["name"],
        artist: song["artistName"],
        album: song["albumName"],
        albumID: song["albumId"],
        artistID: song["artistId"],
        previewURL: song["previewURL"],
      );
      songsList.add(newSong);
    }
    return songsList;
  } else {
    throw Exception('Failed to load album');
  }
}

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late Future<List<Song>> topSongsList;

  @override
  void initState() {
    super.initState();
    topSongsList = getTopSongsList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          FutureBuilder<List<Song>>(
            future: topSongsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[MusicPlayer(song: snapshot.data![8])],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Container(
                height: MediaQuery.of(context).size.height * 0.85,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 60.0,
                    ),
                    const Text(
                      "Loading music Player...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
