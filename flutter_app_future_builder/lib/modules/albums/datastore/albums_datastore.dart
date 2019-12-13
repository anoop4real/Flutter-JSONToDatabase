import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_app_future_builder/constants/api_constants.dart';
import 'package:flutter_app_future_builder/modules/albums/models/album.dart';
import 'package:http/http.dart' as http;

class AlbumsDataStore {
  AlbumsDataStore() {
    open().then((dynamic _) {
      _isDbCreated = true;
    });
  }

  /// Db Column names
  final String tableAlbums = 'albums';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnArtist = 'artist';
  final String columnImage = 'image';
  final String columnUrl = 'url';
  final String columnThumb = 'thumbnail_image';

  bool _isDbCreated = false;
  Database db;

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'albums.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        create table $tableAlbums ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnArtist text not null,
          $columnImage text not null,
          $columnUrl text not null,
          $columnThumb text not null
          )
          ''');
    });
  }

  Future<List<Album>> fetchAlbums() async {
    final String url = '$base_url$albums_route';
    final http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResult = json.decode(response.body);
      List<Album> albumList =
          jsonResult.map((dynamic item) => Album.fromJson(item)).toList();

      await insertAlbums(albumList);
      albumList = await getSavedAlbums();
      return albumList;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<void> insertAlbums(List<Album> albums) async {
    final Batch batch = db.batch();
    for (Album album in albums) {
      batch.insert(tableAlbums, album.toJson());
    }
    await batch.commit();
  }

  Future<List<Album>> getSavedAlbums() async {
    final List<Map> maps = await db.query(
      tableAlbums,
      columns: [
        columnId,
        columnTitle,
        columnArtist,
        columnImage,
        columnUrl,
        columnThumb
      ],
    );
    if (maps.isNotEmpty) {
      final List<Album> albumList =
          maps.map((dynamic item) => Album.fromJson(item)).toList();
      return albumList;
    }
    return List();
  }

  Future<int> delete(String title) async {
    return await db
        .delete(tableAlbums, where: '$columnId = ?', whereArgs: <String>[title]);
  }

  Future<int> update(Album album) async {
    return await db.update(tableAlbums, album.toJson(),
        where: '$columnTitle = ?', whereArgs: <String>[album.title]);
  }

  Future<int> deleteAll() async {
    return await db
        .delete(tableAlbums);
  }
}
