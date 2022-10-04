import 'package:cached_network_image/cached_network_image.dart';
import 'package:cantor/models/artist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmallArtist extends StatelessWidget {
  final Artist artist;

  const SmallArtist({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(
              maxWidth: 120,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: CachedNetworkImage(
              imageUrl:
                  "https://api.napster.com/imageserver/v2/artists/${artist.id}/images/356x237.jpg",
              imageBuilder: (context, imageProvider) => Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(CupertinoIcons.wifi_slash),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 5,
            ),
            child: Text(
              artist.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
