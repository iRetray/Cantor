import 'package:cantor/screens/songs.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class MainSong extends StatelessWidget {
  final Song song;

  const MainSong({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            )
          ]),
        )
      ],
    );
  }

  Widget informationCard(IconData icon, String label, String text) {
    return Column(children: <Widget>[
      Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
        ),
      ),
      Row(
        children: <Widget>[
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
        ],
      ),
    ]);
  }
}
