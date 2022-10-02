import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class SearchResult {
  final List<Album> albums;
  final List<Artist> artists;
  final List<Song> songs;

  const SearchResult({
    required this.albums,
    required this.artists,
    required this.songs,
  });
}

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

class Artist {
  final String name;
  final String id;

  const Artist({
    required this.name,
    required this.id,
  });
}

class Album {
  final String name;
  final String copyright;

  const Album({
    required this.name,
    required this.copyright,
  });
}

Future<SearchResult> getElementsByQuery(String query) async {
  if (query == "") {
    List<Song> songsList = [];
    List<Album> albumsList = [];
    List<Artist> artistsList = [];
    SearchResult newSearchResult = SearchResult(
      albums: albumsList,
      songs: songsList,
      artists: artistsList,
    );
    return newSearchResult;
  }
  final response = await http.get(Uri.parse(
      'http://api.napster.com/v2.2/search?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&per_type_limit=20&query=$query'));
  if (response.statusCode == 200) {
    var responseJSON = jsonDecode(response.body);
    List<Song> songsList = [];
    List<Album> albumsList = [];
    List<Artist> artistsList = [];
    for (var song in responseJSON["search"]["data"]["tracks"]) {
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
    for (var artist in responseJSON["search"]["data"]["artists"]) {
      log(artist["id"].toString());
      Artist newArtist = Artist(
        name: artist["name"],
        id: artist["id"],
      );
      artistsList.add(newArtist);
    }
    for (var album in responseJSON["search"]["data"]["albums"]) {
      Album newAlbum = Album(
        name: album["name"],
        copyright: album["copyright"],
      );
      albumsList.add(newAlbum);
    }
    SearchResult newSearchResult = SearchResult(
      albums: albumsList,
      songs: songsList,
      artists: artistsList,
    );
    return newSearchResult;
  } else {
    throw Exception('Failed to load search results');
  }
}

class Searcher extends StatefulWidget {
  const Searcher({super.key});

  @override
  State<Searcher> createState() => _SearcherState();
}

class _SearcherState extends State<Searcher> {
  late TextEditingController searchController = TextEditingController(text: '');
  late Future<SearchResult> resultsSearch;

  @override
  void initState() {
    super.initState();
    createSearchInputListener();
    resultsSearch = getElementsByQuery("");
  }

  void createSearchInputListener() {
    searchController.addListener(() {
      final searchValue = searchController.text.toLowerCase();
      resultsSearch = getElementsByQuery(searchValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: const Text(
              "Search",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CupertinoTextField(
              clearButtonMode: OverlayVisibilityMode.always,
              controller: searchController,
              placeholder: "Search by songs, artist or albums",
              prefix: Container(
                margin: const EdgeInsets.all(5),
                child: const Icon(CupertinoIcons.search),
              ),
            ),
          ),
          FutureBuilder<SearchResult>(
            future: resultsSearch,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Songs",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.songs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return smallSong(snapshot.data!.songs[index]);
                          },
                        ),
                      ),
                      const Text(
                        "Artists",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.artists.length,
                          itemBuilder: (BuildContext context, int index) {
                            return smallArtist(snapshot.data!.artists[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Widget smallSong(Song song) {
    return Container(
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
            child: Image.network(
              "https://api.napster.com/imageserver/v2/albums/${song.albumID}/images/300x300.jpg",
              height: 70,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
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
        ],
      ),
    );
  }

  Widget smallArtist(Artist artist) {
    return artist.id.length <= 8
        ? Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 10,
            ),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://api.napster.com/imageserver/v2/artists/${artist.id}/images/356x237.jpg",
                      ),
                    ),
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
          )
        : const SizedBox.shrink();
  }
}
