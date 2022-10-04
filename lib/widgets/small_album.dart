import 'package:cached_network_image/cached_network_image.dart';
import 'package:cantor/models/album.dart';
import 'package:flutter/widgets.dart';

class SmallAlbum extends StatelessWidget {
  final Album album;
  const SmallAlbum({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 100),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://api.napster.com/imageserver/v2/albums/${album.albumID}/images/300x300.jpg",
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              textAlign: TextAlign.center,
              album.name,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
