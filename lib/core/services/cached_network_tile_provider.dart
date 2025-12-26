import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'map_tile_cache_service.dart';

/// Custom tile provider that caches tiles locally for offline viewing
///
/// This provider:
/// 1. Checks cache first (works offline)
/// 2. If not in cache and online, downloads and caches the tile
/// 3. If not in cache and offline, returns null (no error)
class CachedNetworkTileProvider extends TileProvider {
  final MapTileCacheService _cacheService = MapTileCacheService();
  final Duration cacheValidDuration;

  CachedNetworkTileProvider({
    this.cacheValidDuration = const Duration(days: 30),
  });

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final x = coordinates.x;
    final y = coordinates.y;
    final z = coordinates.z;

    final urlTemplate = options.urlTemplate ?? '';
    final url = urlTemplate
        .replaceAll('{z}', z.toString())
        .replaceAll('{x}', x.toString())
        .replaceAll('{y}', y.toString());

    return _CachedNetworkImage(
      url: url,
      x: x,
      y: y,
      z: z,
      cacheService: _cacheService,
      cacheValidDuration: cacheValidDuration,
      userAgent: 'com.example.cubic_task',
    );
  }
}

/// Custom ImageProvider that loads tiles from cache or network
class _CachedNetworkImage extends ImageProvider<_CachedNetworkImage> {
  final String url;
  final int x;
  final int y;
  final int z;
  final MapTileCacheService cacheService;
  final Duration cacheValidDuration;
  final String userAgent;

  _CachedNetworkImage({
    required this.url,
    required this.x,
    required this.y,
    required this.z,
    required this.cacheService,
    required this.cacheValidDuration,
    required this.userAgent,
  });

  @override
  Future<_CachedNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<_CachedNetworkImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _CachedNetworkImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
    );
  }

  Future<ui.Codec> _loadAsync(
    _CachedNetworkImage key,
    ImageDecoderCallback decode,
  ) async {
    try {
      final cacheDir = await cacheService.getCacheDirectory();
      final fileName = 'tile_${key.z}_${key.x}_${key.y}.png';
      final cachedFile = File(path.join(cacheDir.path, fileName));

      if (await cachedFile.exists()) {
        final stat = await cachedFile.stat();
        final age = DateTime.now().difference(stat.modified);
        if (age < cacheValidDuration) {
          final bytes = await cachedFile.readAsBytes();
          return decode(await ui.ImmutableBuffer.fromUint8List(
              Uint8List.fromList(bytes)));
        } else {
          await cachedFile.delete();
        }
      }

      try {
        final response = await http.get(
          Uri.parse(key.url),
          headers: {'User-Agent': key.userAgent},
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          await cachedFile.writeAsBytes(bytes);
          return decode(await ui.ImmutableBuffer.fromUint8List(
              Uint8List.fromList(bytes)));
        }
      } catch (e) {
        if (await cachedFile.exists()) {
          final bytes = await cachedFile.readAsBytes();
          return decode(await ui.ImmutableBuffer.fromUint8List(
              Uint8List.fromList(bytes)));
        }
        return decode(await ui.ImmutableBuffer.fromUint8List(
            Uint8List.fromList(_getTransparentTile())));
      }
    } catch (e) {
      return decode(await ui.ImmutableBuffer.fromUint8List(
          Uint8List.fromList(_getTransparentTile())));
    }

    throw Exception('Failed to load tile');
  }

  List<int> _getTransparentTile() {
    return [
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0A,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82,
    ];
  }
}
