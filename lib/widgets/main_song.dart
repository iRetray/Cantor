import 'package:cantor/screens/songs.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:just_audio/just_audio.dart';

final player = AudioPlayer();

class MainSong extends StatelessWidget {
  final Song song;

  const MainSong({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: const Text(
            "Song of the day",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            "https://api.napster.com/imageserver/v2/albums/${song.albumID}/images/500x500.jpg",
            width: 300,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(children: <Widget>[
            Text(
              song.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "https://api.napster.com/imageserver/v2/artists/${song.artistID}/images/300x300.jpg",
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    informationCard(
                      CupertinoIcons.music_mic,
                      "Artist",
                      song.artist,
                    ),
                    informationCard(
                      CupertinoIcons.music_albums,
                      "Album",
                      song.album,
                    ),
                  ],
                ),
              ],
            )
          ]),
        ),
        TextButton(
          onPressed: playSong,
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const Text('Enabled'),
        ),
      ],
    );
  }

  Widget informationCard(IconData icon, String label, String text) {
    return Row(children: <Widget>[
      Icon(
        icon,
        size: 12,
        color: Colors.white,
      ),
      Container(
        margin: const EdgeInsets.only(right: 5, left: 2),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12,
          ),
        ),
      ),
      Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
        ),
      ),
    ]);
  }

  Future<void> playSong() async {
    await player.setUrl(song.previewURL);
    player.play();
  }
}
