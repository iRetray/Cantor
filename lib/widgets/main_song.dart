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
  bool isPlaying = false;
  double sliderValue = 0.0;
  int secondsDuration = 0;

  @override
  void initState() {
    setSongDuration();
    super.initState();
  }

  void setSongDuration() async {
    final duration = await player.setUrl(widget.song.previewURL);
    setState(() {
      secondsDuration = duration!.inSeconds;
    });
  }

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
            "https://api.napster.com/imageserver/v2/albums/${widget.song.albumID}/images/500x500.jpg",
            width: 300,
          ),
        ),
        Container(
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
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            /* TODO: Implement the slider reactivity */
            children: <Widget>[
              Text(
                  "${(player.position.inSeconds / 60).floor().toString()}:${(player.position.inSeconds % 60).toString()}"),
              Expanded(
                child: CupertinoSlider(
                  min: 0.0,
                  max: 29.0,
                  value: 15.0,
                  onChanged: (newValue) => {},
                ),
              ),
              Text(
                "${(secondsDuration / 60).floor().toString()}:${(secondsDuration % 60).toString()}",
              )
            ],
          ),
        ),
        Row(
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
                    fixedSize: const Size(60, 60)),
                child: isPlaying
                    ? const Icon(
                        CupertinoIcons.pause,
                        size: 40,
                      )
                    : Container(
                        alignment: Alignment.topRight,
                        child: const Icon(
                          CupertinoIcons.play,
                          size: 40,
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

  void updateRangeValue(double newRangeValue) {}
}
