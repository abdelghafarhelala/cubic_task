import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for managing offline map tile caching
/// 
/// Caches map tiles locally so they can be displayed when offline
class MapTileCacheService {
  static MapTileCacheService? _instance;
  Directory? _cacheDirectory;

  MapTileCacheService._internal();

  factory MapTileCacheService() {
    _instance ??= MapTileCacheService._internal();
    return _instance!;
  }

  /// Get cache directory for map tiles
  Future<Directory> getCacheDirectory() async {
    if (_cacheDirectory != null) {
      return _cacheDirectory!;
    }

    final appDir = await getApplicationDocumentsDirectory();
    _cacheDirectory = Directory(path.join(appDir.path, 'map_tiles'));
    
    if (!await _cacheDirectory!.exists()) {
      await _cacheDirectory!.create(recursive: true);
    }

    return _cacheDirectory!;
  }

  /// Get cached tile file path
  Future<File?> getCachedTile(String url) async {
    try {
      final cacheDir = await getCacheDirectory();
      final fileName = _getFileNameFromUrl(url);
      final file = File(path.join(cacheDir.path, fileName));
      
      if (await file.exists()) {
        return file;
      }
    } catch (e) {
      // Ignore errors, return null to indicate no cache
    }
    return null;
  }

  /// Cache a tile file
  Future<void> cacheTile(String url, List<int> data) async {
    try {
      final cacheDir = await getCacheDirectory();
      final fileName = _getFileNameFromUrl(url);
      final file = File(path.join(cacheDir.path, fileName));
      
      await file.writeAsBytes(data);
    } catch (e) {
      // Ignore caching errors
    }
  }

  /// Clear all cached tiles
  Future<void> clearCache() async {
    try {
      final cacheDir = await getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create(recursive: true);
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Get cache size in bytes
  Future<int> getCacheSize() async {
    try {
      final cacheDir = await getCacheDirectory();
      if (!await cacheDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Generate a safe filename from URL
  String _getFileNameFromUrl(String url) {
    // Replace invalid filename characters
    return url
        .replaceAll('https://', '')
        .replaceAll('http://', '')
        .replaceAll('/', '_')
        .replaceAll('?', '_')
        .replaceAll('&', '_')
        .replaceAll('=', '_')
        .replaceAll(':', '_');
  }
}

