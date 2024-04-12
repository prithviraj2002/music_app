import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_app/appwrite/appwrite_consts.dart';
import 'package:music_app/appwrite/appwrite_db.dart';
import 'package:music_app/controllers/player_controller.dart';
import 'package:music_app/main.dart';
import 'package:music_app/model/song_item.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:uuid/uuid.dart';

class FavouriteController extends GetxController{
  RxList<SongModel> favouriteSongs = <SongModel>[].obs;

  var playIndex = 0.obs;

  var box;
  var userId;

  var playerController = Get.find<PlayerController>();

  @override
  void onInit(){
    super.onInit();
    box = GetStorage();
    userId = box.read("userId");
    getSongs();
  }

  Future<void> getSongs() async{
    try{
      final DocumentList response = await MusicDatabase.databases.listDocuments(
          databaseId: AppwriteConstants.musicDB, collectionId: AppwriteConstants.favMuisc);
      for(var song in response.documents){
        if(song.data["userId"] == userId){
          SongModel favSong = playerController.songs.firstWhere((element) => element.id == song.data["songId"]);
          favouriteSongs.add(favSong);
        }
      }
    } on Exception catch(e){
      print("An error occurred while trying to get songs from db!: $e");
    }
  }

  Future<void> addSongToFavourites(SongModel song) async{
    print("adding song ${song.title}");
    favouriteSongs.add(song);
    final uniqueId = Uuid().v4();
    SongItem favSong = SongItem(title: song.title, artist: song.artist ?? "", id: song.id.toString());
    try{
      await MusicDatabase.databases.createDocument(
          databaseId: AppwriteConstants.musicDB,
          collectionId: AppwriteConstants.favMuisc,
          documentId: uniqueId,
          data: {
            "title": favSong.title,
            "artist": favSong.artist,
            "userId": userId,
            "songId": favSong.id
          });
    } on Exception catch(e){
      print("An error occurred while trying to add fav song to db!:$e");
    }
  }

  void removeFromFavourites(SongModel song){
    favouriteSongs.remove(song);

  }
}