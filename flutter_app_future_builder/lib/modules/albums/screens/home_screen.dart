import 'package:flutter/material.dart';
import 'package:flutter_app_future_builder/modules/albums/datastore/albums_datastore.dart';
import 'package:flutter_app_future_builder/modules/albums/models/album.dart';

class AlbumsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Future Builder'),
      ),
      body: _buildAlbumsList(),
    );
  }

  Widget _buildAlbumsList() {
    return FutureBuilder(
      future: AlbumsDataStore().fetchAlbums(),
      builder: (context, albumsData) {
        if (albumsData.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (albumsData.connectionState == ConnectionState.done &&
            albumsData.hasData) {
          return _buildListWith(albumsData.data);
        } else if (albumsData.hasError) {
          return Center(
            child: Text('Error occured while loading albums'),
          );
        } else {
          return Center(
            child: Text('Error occured while loading albums'),
          );
        }
      },
    );
  }

  Widget _buildListWith(List<Album> albums) {
    return ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, int index) {
          final album = albums[index];
          return ListTile(
            title: Text(album.title),
            subtitle: Text(album.artist),
            leading: CircleAvatar(
              radius: 30.0,
              child: ClipOval(child: Image.network(album.image)),
            ),
          );
        });
  }
}
