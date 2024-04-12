import 'package:appwrite/appwrite.dart';
import 'package:music_app/appwrite/appwrite_consts.dart';
import 'package:music_app/model/song_item.dart';
import 'package:uuid/uuid.dart';

class MusicDatabase{
  static Client client = Client()
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId);

  static Databases databases = Databases(client);

  uploadSong(SongItem song) async{
    try{
      final response = databases.createDocument(
          databaseId: AppwriteConstants.musicDB,
          collectionId: AppwriteConstants.favMuisc,
          documentId: Uuid().v4(),
          data: song.toJson()
      );
      return response;
    } on Exception catch(e){
      print("An error occurred while trying to upload song!");
    }
  }
}