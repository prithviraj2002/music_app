// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:music_app/main.dart';
import 'package:music_app/model/song_item.dart';
import 'package:music_app/views/home.dart';
import 'package:music_app/views/login.dart';
import 'package:music_app/views/splash_screen.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  //Test of song item class
  test('SongItem should be correctly converted to Map<String, dynamic>', () {
    SongItem song = SongItem(title: "Kalank", artist: "Arijit Singh", id: "0");

    Map<String, dynamic> songJson = song.toJson();

    expect(songJson, {
      "title": "Kalank",
      "artist": "Arijit Singh",
      "id": "0"
    });
  });

  //Tests the animation of splash screen.
  testWidgets("Splash screen animation.", (WidgetTester tester) async{
    await tester.pumpWidget(GetMaterialApp(
      home: Splash(),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Beats'), findsOneWidget);
  });

}
