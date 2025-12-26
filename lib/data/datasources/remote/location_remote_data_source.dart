import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/utils/data_parsing_isolate.dart';
import '../../models/branch_atm_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<BranchAtmModel>> getBranchesAndAtms();
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio dio;

  LocationRemoteDataSourceImpl({Dio? dio}) : dio = dio ?? DioHelper.dio;

  @override
  Future<List<BranchAtmModel>> getBranchesAndAtms() async {
    try {
      final response = await dio.get(
        AppConstants.branchesAtmsUrl,
        options: Options(
          responseType: ResponseType.json,
          headers: {'Accept': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final parsedData = await compute(
          parseBranchesAtmsData,
          response.data,
        );

        return parsedData;
      } else {
        throw const NetworkFailure('Failed to fetch branches and ATMs');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure(
            'Connection timeout. Please check your internet.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure('No internet connection');
      } else {
        throw NetworkFailure('Failed to fetch locations: ${e.message}');
      }
    } catch (e) {
      if (e is NetworkFailure) {
        rethrow;
      }
      if (e.toString().contains('Failed to parse data')) {
        throw NetworkFailure('Failed to parse response data: ${e.toString()}');
      }
      throw NetworkFailure('An unexpected error occurred: ${e.toString()}');
    }
  }
}
