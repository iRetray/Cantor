import 'dart:async';
import 'dart:developer';

import 'package:cantor/screens/songs.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:just_audio/just_audio.dart';
import 'package:volume_controller/volume_controller.dart';

final player = AudioPlayer();
final volume = VolumeController();

class MainSong extends StatefulWidget {
  final Song song;

  const MainSong({super.key, required this.song});

  @override
  State<MainSong> createState() => _MainSongState();
}

class _MainSongState extends State<MainSong> {
  late StreamSubscription playerPositionSubscription;
  late Duration currentPosition = const Duration(seconds: 0);

  bool isPlaying = false;

  double sliderValue = 0.0;
  double secondsDuration = 1.0;

  @override
  void initState() {
    setSongDuration();
    createPlayerListener();
    super.initState();
  }

  void setSongDuration() async {
    final duration = await player.setUrl(widget.song.previewURL);
    if (duration is Duration) {
      setState(() {
        secondsDuration = duration.inSeconds.toDouble();
      });
    }
  }

  void createPlayerListener() {
    playerPositionSubscription = player.positionStream.listen((newPosition) {
      setState(() {
        if (newPosition.inSeconds >= secondsDuration) {
          player.pause();
          player.seek(const Duration(seconds: 0));
          currentPosition = const Duration(seconds: 0);
          isPlaying = false;
        } else {
          currentPosition = newPosition;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
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
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width * 0.90,
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "https://api.napster.com/imageserver/v2/albums/${widget.song.albumID}/images/500x500.jpg",
                  width: MediaQuery.of(context).size.width * 0.80,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.12,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(children: <Widget>[
            Text(
              widget.song.name,
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
                      "https://api.napster.com/imageserver/v2/artists/${widget.song.artistID}/images/300x300.jpg",
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
                      widget.song.artist,
                    ),
                    informationCard(
                      CupertinoIcons.music_albums,
                      "Album",
                      widget.song.album,
                    ),
                  ],
                ),
              ],
            )
          ]),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Text(
                getPlayerTime(currentPosition.inSeconds),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: CupertinoSlider(
                    min: 0.0,
                    value: currentPosition.inSeconds.toDouble(),
                    max: secondsDuration,
                    onChanged: (newValue) => {
                      updateSongPosition(newValue),
                    },
                  ),
                ),
              ),
              Text(
                getPlayerTime(secondsDuration.toInt()),
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: downVolume,
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.white10,
                    fixedSize: const Size(30, 30)),
                child: const Icon(
                  CupertinoIcons.volume_down,
                  size: 20,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(
                  onPressed: isPlaying ? pauseSong : playSong,
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.white,
                      fixedSize: const Size(70, 70)),
                  child: isPlaying
                      ? const Icon(
                          CupertinoIcons.pause,
                          size: 50,
                        )
                      : Container(
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            CupertinoIcons.play,
                            size: 50,
                          ),
                        ),
                ),
              ),
              TextButton(
                onPressed: upVolume,
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.white10,
                    fixedSize: const Size(30, 30)),
                child: const Icon(
                  CupertinoIcons.volume_up,
                  size: 20,
                ),
              ),
            ],
          ),
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

  void playSong() {
    player.play();
    setState(() {
      isPlaying = true;
    });
  }

  void pauseSong() {
    player.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void upVolume() async {
    final currentVolume = await volume.getVolume();
    if (currentVolume != 1.0) {
      volume.setVolume(currentVolume + 0.1);
    }
  }

  void downVolume() async {
    final currentVolume = await volume.getVolume();
    if (currentVolume != 0.0) {
      volume.setVolume(currentVolume - 0.1);
    }
  }

  String getPlayerTime(int totalSeconds) {
    String minutes = totalSeconds >= 60
        ? (totalSeconds ~/ 60).toString().length == 2
            ? (totalSeconds ~/ 60).toString()
            : "0${(totalSeconds ~/ 60).toString()}"
        : "00";
    String seconds = (totalSeconds % 60).toString().length == 2
        ? (totalSeconds % 60).toString()
        : "0${(totalSeconds % 60).toString()}";
    return "$minutes:$seconds";
  }

  void updateSongPosition(double newPosition) {
    player.seek(Duration(seconds: newPosition.toInt()));
  }
}
