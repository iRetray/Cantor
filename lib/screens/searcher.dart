import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/album.dart';
import '../models/artist.dart';
import '../models/search_result.dart';
import '../models/song.dart';

import '../widgets/small_album.dart';
import '../widgets/small_artist.dart';
import '../widgets/small_song.dart';

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
      Artist newArtist = Artist(
        name: artist["name"],
        id: artist["id"],
      );
      artistsList.add(newArtist);
    }
    for (var album in responseJSON["search"]["data"]["albums"]) {
      Album newAlbum = Album(
        albumID: album["id"],
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
              if (snapshot.hasData &&
                  (snapshot.data!.songs.isNotEmpty ||
                      snapshot.data!.artists.isNotEmpty ||
                      snapshot.data!.albums.isNotEmpty)) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      if (snapshot.data!.songs.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SmallSong(
                                      song: snapshot.data!.songs[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (snapshot.data!.artists.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Artists",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 170,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.artists.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SmallArtist(
                                      artist: snapshot.data!.artists[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (snapshot.data!.albums.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Albums",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.artists.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SmallAlbum(
                                      album: snapshot.data!.albums[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.music_albums,
                      color: Colors.white24,
                      size: 80,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: const Text(
                        "Search something",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white24,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
