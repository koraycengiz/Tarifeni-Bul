import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'TariffProvider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tariffProvider = Provider.of<TariffProvider>(context);
    final favorites = tariffProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Favorites',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: favorites.isEmpty
          ? Center(
        child: Text(
          'No favorite tariffs yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final tariff = favorites[index];

          return Card(
            color: Colors.indigo[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                tariff.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[800],
                ),
              ),
              subtitle: Text(
                '${tariff.gb} | ${tariff.minutes}',
                style: TextStyle(color: Colors.black87),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  tariffProvider.toggleFavorite(tariff);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
