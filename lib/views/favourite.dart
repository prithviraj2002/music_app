import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/consts/colors.dart';
import 'package:music_app/consts/text_style.dart';
import 'package:music_app/controllers/favourite_controller.dart';
import 'package:music_app/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favourite extends StatelessWidget {
  Favourite({super.key});

  var controller = Get.find<FavouriteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        title: Text("Favourite Songs", style: ourStyle(
            family: bold,
            size: 18),),
        leading: IconButton(onPressed:() {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back, color: whiteColor),),
      ),
      body: Obx(() {
        if(controller.favouriteSongs.isEmpty){
          return Center(child: Text("No songs added to favourites yet!", style: ourStyle(),),);
        } else{
          return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Obx(() {
                    return ListTile(
                      tileColor: bgColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)
                      ),
                      leading: QueryArtworkWidget(
                        id: controller.favouriteSongs[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: whiteColor,
                          size: 32,
                        ),
                      ),
                      title: Text(
                        controller.favouriteSongs[index].displayNameWOExt,
                        style: ourStyle(family: bold, size: 14.0),),
                      subtitle: Text(
                        controller.favouriteSongs[index].artist ?? "Unknown Artist",
                        style: ourStyle(family: regular, size: 12.0),),
                      trailing: controller.playIndex == index ? const Icon(
                        Icons.play_arrow, color: whiteColor, size: 26,) : null,
                      onTap: () {
                        controller.playIndex.value = index;
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => Player(songs: controller.favouriteSongs)));
                      },
                    );
                  }),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(height: 4);
              },
              itemCount: controller.favouriteSongs.length);
        }
      }),
    );
  }
}
