import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar produtos favoritos com persistência em SharedPreferences
class FavoritesService {
  static const String _favoritesKey = "favorited_products";

  /// Adiciona um produto aos favoritos
  Future<void> addFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    if (!favorites.contains(productId.toString())) {
      favorites.add(productId.toString());
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /// Remove um produto dos favoritos
  Future<void> removeFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    favorites.removeWhere((id) => id == productId.toString());
    await prefs.setStringList(_favoritesKey, favorites);
  }

  /// Verifica se um produto está nos favoritos
  Future<bool> isFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    return favorites.contains(productId.toString());
  }

  /// Retorna a lista de IDs de produtos favoritos
  Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    return favorites.map((id) => int.parse(id)).toList();
  }

  /// Limpa todos os favoritos
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
}
