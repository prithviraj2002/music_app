import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:music_app/appwrite/appwrite_consts.dart';

class AuthProvider{
  static Client client = Client()
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId);

  static Account account = Account(client);

  static Future<User> signup(String email, String password) async{
    print('Entered appwrite auth');
    try{
      final response = await account.create(
        email: email,
        password: password,
        userId: ID.unique(),
      );
      return response;
    } on AppwriteException catch(e){
      if (kDebugMode) {
        print('An error occurred while signing up user!: $e');
      }
      rethrow;
    }
  }

  static Future<Session> signin(String email, String password) async{
    print('User was signed in!');
    try{
      final response = await account.createEmailPasswordSession(
          email: email, password: password);
      return response;
    } on AppwriteException catch(e){
      if (kDebugMode) {
        print('An error occurred while signing up user!: $e');
      }
      rethrow;
    }
  }

  static Future<User?> getUser() async{
    try{
      final User? response = await account.get();
      return response;
    } on AppwriteException catch(e){
      print('An error occurred while getting user email in appwrite auth: $e');
      return null;
    }
  }
}