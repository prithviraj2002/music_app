import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/consts/colors.dart';
import 'package:music_app/consts/text_style.dart';
import 'package:music_app/controllers/favourite_controller.dart';
import 'package:music_app/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> songs; String? id;

  Player({required this.songs, this.id, super.key});

  var controller = Get.find<PlayerController>();
  var favouriteController = Get.find<FavouriteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back, color: whiteColor,))
      ),
      body: Obx(() {
        return Container(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 8.0, bottom: 0.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 300,
                      width: 300,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle
                      ),
                      child: Hero(
                        tag: "song-pic",
                        child: QueryArtworkWidget(
                          id: id == null ? songs[controller.playIndex.value].id : int.parse(id!),
                          type: ArtworkType.AUDIO,
                          artworkHeight: double.infinity,
                          artworkWidth: double.infinity,),
                      )
                  )
              ),
              const SizedBox(height: 12,),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(child: Container(),),
                          Text(
                            songs[controller.playIndex.value].displayNameWOExt.length > 10 ? songs[controller.playIndex.value].displayNameWOExt.substring(0, 10) : songs[controller.playIndex.value].displayNameWOExt,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: ourStyle(
                              color: bgDarkColor,
                              family: bold,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: Obx(() {
                              return favouriteController.favouriteSongs.contains(songs[controller.playIndex.value]) ?
                              IconButton(onPressed: () {
                                favouriteController.removeFromFavourites(songs[controller.playIndex.value]);
                              },
                                  icon: const Icon(Icons.favorite, color: Colors.red))
                                  : IconButton(onPressed: () {
                                favouriteController.addSongToFavourites(songs[controller.playIndex.value]);
                              },
                                  icon: const Icon(Icons.favorite_border, color: Colors.red,))
                              ;
                            }),
                          )
                        ],
                      ),
                      Text(
                        songs[controller.playIndex.value].artist ??
                            "Unknown Artist",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: bgDarkColor,
                          family: bold,
                          size: 16,
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Obx(() {
                        return Row(
                          children: <Widget>[
                            Text(controller.position.value,
                              style: ourStyle(color: bgDarkColor),),
                            Expanded(
                                child: Slider(
                                    thumbColor: sliderColor,
                                    inactiveColor: bgColor,
                                    min: const Duration(seconds: 0).inSeconds
                                        .toDouble(),
                                    max: controller.max.value,
                                    value: controller.value.value,
                                    activeColor: sliderColor,
                                    onChanged: (newValue) {
                                      controller.changeDurationToSeconds(
                                          newValue.toInt());
                                      newValue = newValue;
                                    }
                                )
                            ),
                            Text(
                              controller.duration.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(onPressed: () {
                            controller.playSong(
                                songs[controller.playIndex.value - 1].uri,
                                controller.playIndex - 1);
                          },
                              icon: const Icon(
                                Icons.skip_previous_rounded, size: 40,)),
                          Obx(() {
                            return CircleAvatar(
                                radius: 35,
                                backgroundColor: bgDarkColor,
                                child: Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                    onPressed: () {
                                      if (controller.isPlaying.value) {
                                        controller.audioPlayer.pause();
                                        controller.isPlaying(false);
                                      } else {
                                        controller.isPlaying(true);
                                        controller.playSong(
                                            songs[controller.playIndex.value]
                                                .uri,
                                            controller.playIndex.value);
                                      }
                                    },
                                    icon: controller.isPlaying.value
                                        ? const Icon(
                                      Icons.pause, color: whiteColor,)
                                        : const Icon(
                                      Icons.play_arrow_rounded,
                                      color: whiteColor,),
                                  ),
                                )
                            );
                          }),
                          IconButton(onPressed: () {
                            controller.playSong(
                                songs[controller.playIndex.value + 1].uri,
                                controller.playIndex + 1);
                          },
                              icon: const Icon(
                                Icons.skip_next_rounded, size: 40,)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
