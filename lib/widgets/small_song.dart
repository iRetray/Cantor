import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/song.dart';

class SmallSong extends StatelessWidget {
  final Song song;

  const SmallSong({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        clipBehavior: Clip.hardEdge,
        constraints: const BoxConstraints(maxWidth: 200),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    "https://api.napster.com/imageserver/v2/albums/${song.albumID}/images/300x300.jpg",
                height: 70,
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      song.artist,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
