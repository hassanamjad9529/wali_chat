import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class FavoritesController extends GetxController {
  final RxList<Map<String, dynamic>> likedProfiles =
      <Map<String, dynamic>>[].obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    List<dynamic>? stored = storage.read('likedProfiles');
    if (stored != null) {
      try {
        likedProfiles.value = stored
            .whereType<String>()
            .map((e) => jsonDecode(e))
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
      } catch (e) {
        print("Failed to decode favorites: $e");
      }
    }
  }

  void saveFavorites() {
    List<String> encoded = likedProfiles.map((e) => jsonEncode(e)).toList();
    storage.write('likedProfiles', encoded);
  }

  bool isFavorite(String id) {
    return likedProfiles.any((profile) => profile['id'] == id);
  }

  void removeFavorite(String id) {
    likedProfiles.removeWhere((profile) => profile['id'] == id);
    saveFavorites();
  }
}
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class FavoritesController extends GetxController {
  final RxList<Map<String, dynamic>> likedProfiles =
      <Map<String, dynamic>>[].obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    List<dynamic>? stored = storage.read('likedProfiles');
    if (stored != null) {
      try {
        likedProfiles.value = stored
            .whereType<String>()
            .map((e) => jsonDecode(e))
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
      } catch (e) {
        print("Failed to decode favorites: $e");
      }
    }
  }

  void saveFavorites() {
    List<String> encoded = likedProfiles.map((e) => jsonEncode(e)).toList();
    storage.write('likedProfiles', encoded);
  }

  bool isFavorite(String id) {
    return likedProfiles.any((profile) => profile['id'] == id);
  }

  void removeFavorite(String id) {
    likedProfiles.removeWhere((profile) => profile['id'] == id);
    saveFavorites();
  }
}
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class FavoritesController extends GetxController {
  final RxList<Map<String, dynamic>> likedProfiles =
      <Map<String, dynamic>>[].obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    List<dynamic>? stored = storage.read('likedProfiles');
    if (stored != null) {
      try {
        likedProfiles.value = stored
            .whereType<String>()
            .map((e) => jsonDecode(e))
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
      } catch (e) {
        print("Failed to decode favorites: $e");
      }
    }
  }

  void saveFavorites() {
    List<String> encoded = likedProfiles.map((e) => jsonEncode(e)).toList();
    storage.write('likedProfiles', encoded);
  }

  bool isFavorite(String id) {
    return likedProfiles.any((profile) => profile['id'] == id);
  }

  void removeFavorite(String id) {
    likedProfiles.removeWhere((profile) => profile['id'] == id);
    saveFavorites();
  }
}
