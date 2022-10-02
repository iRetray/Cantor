import 'dart:convert';

import 'package:cantor/widgets/music_player.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Song {
  final String name;
  final String artist;
  final String album;
  final String albumID;
  final String artistID;
  final String previewURL;

  const Song({
    required this.name,
    required this.artist,
    required this.album,
    required this.albumID,
    required this.artistID,
    required this.previewURL,
  });
}

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
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
