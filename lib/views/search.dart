import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/consts/text_style.dart';
import 'package:music_app/controllers/player_controller.dart';
import 'package:music_app/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../consts/colors.dart';

class Search extends StatefulWidget {
  Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late List<SongModel> searchResults = [];
  TextEditingController searchController = TextEditingController();
  var searchText = "";

  var playerController = Get.find<PlayerController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchResults = playerController.songs;
  }

  void _updateSearchResults(String query) {
    setState(() {
      searchResults = playerController.songs.where((song) =>
      song.title.toLowerCase().contains(query.toLowerCase()) ||
          song.artist!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        title: Text(
          "Search",
          style: ourStyle(family: bold, size: 18, color: whiteColor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            controller: searchController,
              style: const TextStyle(
                color: whiteColor, // Set the text color
              ),
              cursorColor: whiteColor,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: whiteColor)),
              prefixIcon: Hero(
                tag: "search",
                  child: Icon(Icons.search, color: whiteColor,))
            ),
            onChanged: _updateSearchResults
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Obx(() {
                      return ListTile(
                        tileColor: bgColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)
                        ),
                        leading: Hero(
                          tag: "song-pic",
                          child: QueryArtworkWidget(
                            id: searchResults[index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: whiteColor,
                              size: 32,
                            ),
                          ),
                        ),
                        title: Text(
                          searchResults[index].displayNameWOExt,
                          style: ourStyle(family: bold, size: 14.0),),
                        subtitle: Text(
                          searchResults[index].artist ?? "Unknown Artist",
                          style: ourStyle(family: regular, size: 12.0),),
                        trailing: playerController.playIndex == index ? const Icon(
                          Icons.play_arrow, color: whiteColor, size: 26,) : null,
                        onTap: () {
                          playerController.playIndex.value = index;
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => Player(songs: searchResults)));
                        },
                      );
                    }),
                  );
                },
                separatorBuilder: (ctx, index){
                  return const SizedBox(height: 4,);
                },
                itemCount: searchResults.length),
          )
        ],
      ),
    );
  }
}
