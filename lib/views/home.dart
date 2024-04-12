import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/appwrite/appwrite_auth.dart';
import 'package:music_app/consts/colors.dart';
import 'package:music_app/consts/text_style.dart';
import 'package:music_app/controllers/favourite_controller.dart';
import 'package:music_app/controllers/player_controller.dart';
import 'package:music_app/views/favourite.dart';
import 'package:music_app/views/login.dart';
import 'package:music_app/views/player.dart';
import 'package:music_app/views/search.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  Home({super.key});

  var controller = Get.put(PlayerController());
  var favouriteController = Get.put(FavouriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(context: context, builder: (ctx){
                    return AlertDialog(
                      surfaceTintColor: bgColor,
                      backgroundColor: bgColor,
                      title: Text("Logout", style: ourStyle(),),
                      content: Text("Are you sure you want to logout?", style: ourStyle(),),
                      actions: [
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text("No", style: ourStyle(),)),
                        TextButton(onPressed: () {
                          AuthProvider.account.deleteSession(sessionId: 'current');
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => AuthScreen()), (route) => false);
                        }, child: Text("Yes", style: ourStyle(),))
                      ],
                    );
                  });
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: whiteColor,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => Favourite()));
                },
                icon: const Icon(
                  Icons.favorite_outline,
                  color: whiteColor,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => Search()));
                },
                icon: Hero(
                  tag: "search",
                  child: const Icon(
                    Icons.search,
                    color: whiteColor,
                  ),
                )),
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
          title: Text(
            "Beats",
            style: ourStyle(family: bold, size: 18),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(8),
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.songs.isEmpty
                      ? Center(
                          child: Text(
                          "No songs here!",
                          style: ourStyle(),
                        ))
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: Obx(() {
                                return ListTile(
                                  tileColor: bgColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  leading: Hero(
                                    tag: "song-pic",
                                    child: QueryArtworkWidget(
                                      id: controller.songs[index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: const Icon(
                                        Icons.music_note,
                                        color: whiteColor,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    controller.songs[index].displayNameWOExt,
                                    style: ourStyle(family: bold, size: 14.0),
                                  ),
                                  subtitle: Text(
                                    controller.songs[index].artist ??
                                        "Unknown Artist",
                                    style:
                                        ourStyle(family: regular, size: 12.0),
                                  ),
                                  trailing: controller.playIndex == index
                                      ? const Icon(
                                          Icons.play_arrow,
                                          color: whiteColor,
                                          size: 26,
                                        )
                                      : null,
                                  onTap: () {
                                    controller.playIndex.value = index;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => Player(
                                                songs: controller.songs)));
                                  },
                                );
                              }),
                            );
                          },
                          separatorBuilder: (ctx, index) {
                            return const SizedBox(height: 4);
                          },
                          itemCount: controller.songs.length),
            )));
  }
}
