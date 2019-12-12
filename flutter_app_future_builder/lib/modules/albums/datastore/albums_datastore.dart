import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_app_future_builder/constants/api_constants.dart';
import 'package:flutter_app_future_builder/modules/albums/models/album.dart';
import 'package:http/http.dart' as http;

class AlbumsDataStore {
  final String tableAlbums = 'albums';
  final String columnId = '_id';
  final String columnTitle = 'title';
  final String columnArtist = 'artist';
  final String columnImage = 'image';
  final String columnUrl = 'url';
  final String columnThumb = 'thumbImage';
  Database db;

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'albums.db'), version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableAlbums ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnArtist text not null,
  $columnImage text not null,
  $columnUrl text not null,
  $columnThumb text not null,)
''');
        });
  }

  Future<List<Album>> fetchAlbums() async {
    var url = '$base_url$albums_route';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      //List<Album> albumList = List<Album>();
      final List<dynamic> jsonResult = json.decode(response.body);
      List<Album> albumList =
          jsonResult.map((dynamic item) => Album.fromJson(item)).toList();
      // If server returns an OK response, parse the JSON.
      return albumList;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
