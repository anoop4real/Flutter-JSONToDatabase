import 'package:flutter/material.dart';
import 'package:flutter_app_future_builder/modules/albums/datastore/albums_datastore.dart';
import 'package:flutter_app_future_builder/modules/albums/models/album.dart';

class AlbumsListScreen extends StatefulWidget {
  @override
  _AlbumsListScreenState createState() => _AlbumsListScreenState();
}

class _AlbumsListScreenState extends State<AlbumsListScreen> {
  final AlbumsDataStore dataStore = AlbumsDataStore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future Builder'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              dataStore.deleteAll().then((_){
                setState(() {

                });
              });
            },
          )
        ],
      ),
      body: _buildAlbumsList(),
    );
  }

  Widget _buildAlbumsList() {
    return FutureBuilder<List<Album>>(
      future: dataStore.fetchAlbums(),
      builder: (BuildContext context, AsyncSnapshot<List<Album>> albumsData) {
        if (albumsData.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (albumsData.connectionState == ConnectionState.done &&
            albumsData.hasData) {
          return _buildListWith(albumsData.data);
        } else if (albumsData.hasError) {
          return const Center(
            child: Text('Error occured while loading albums'),
          );
        } else {
          return const Center(
            child: Text('Error occured while loading albums'),
          );
        }
      },
    );
  }

  Widget _buildListWith(List<Album> albums) {
    return ListView.builder(
        itemCount: albums.length,
        itemBuilder: (BuildContext context, int index) {
          final Album album = albums[index];
          return ListTile(
            title: Text(album.title),
            subtitle: Text(album.artist),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                  deleteItemWith(album.title);
              },
            ),
            leading: CircleAvatar(
              radius: 30.0,
              child: ClipOval(child: Image.network(album.image)),
            ),
          );
        });
  }

  void deleteItemWith(String title){
    dataStore.delete(title).then((_){
      setState(() {
      });
    });
  }
}
