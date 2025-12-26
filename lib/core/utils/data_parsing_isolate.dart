import 'dart:convert';

import '../../data/models/branch_atm_model.dart';

/// Isolate function to parse JSON data in the background
///
/// **Performance Optimization for 60fps:**
/// This function runs in a separate isolate, completely offloading
/// JSON parsing from the main UI thread. This ensures smooth 60fps
/// performance even when processing large datasets (10,000+ items).
///
/// The main UI thread remains free to handle:
/// - User interactions
/// - Smooth animations
/// - Loading indicators
/// - Frame rendering
List<BranchAtmModel> parseBranchesAtmsData(dynamic responseData) {
  try {
    dynamic parsedData = responseData;
    if (responseData is String) {
      parsedData = jsonDecode(responseData);
    }

    List<dynamic> data;
    if (parsedData is List) {
      data = parsedData;
    } else if (parsedData is Map) {
      data = parsedData['data'] as List? ?? [];
    } else {
      throw Exception('Unexpected response format');
    }

    return data.map((json) {
      if (json is Map<String, dynamic>) {
        return BranchAtmModel.fromJson(json);
      } else if (json is Map) {
        return BranchAtmModel.fromJson(Map<String, dynamic>.from(json));
      } else {
        throw Exception('Invalid item format in response');
      }
    }).toList();
  } catch (e) {
    throw Exception('Failed to parse data: ${e.toString()}');
  }
}
