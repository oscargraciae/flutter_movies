import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';

import 'package:movies/providers/movies_provider.dart';
import 'package:movies/widgets/card_swiper.dart';
import 'package:movies/widgets/horizontal_movies.dart';

class HomePage extends StatelessWidget {
  
  final _moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {
    
    _moviesProvider.getNowPlaying();
    _moviesProvider.getPopularMovies();
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FutureBuilder(
              future: _moviesProvider.getNowPlaying(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

                if (snapshot.hasData) {
                  return CardSwiper(movies: snapshot.data);
                } else {
                  return Container(
                    height: 400.0,
                    child: Center(
                      child: CircularProgressIndicator()
                    )
                  );
                }
              },
            ),
            _createFooter(context),
          ],
        )),
      );
  }

  Widget _createFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead)
          ),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: _moviesProvider.popularStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return HorizontalMovies(movies: snapshot.data, nextPage: _moviesProvider.getPopularMovies);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}