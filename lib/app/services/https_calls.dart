import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_urls.dart';
import '../config/global_variables.dart';
import '../mvvm/model/body_model/sign_up_body_model.dart';
import 'internet_service.dart';
import 'logger_service.dart';
import 'shared_preferences_service.dart';

/// Enum for HTTP methods supported by HttpsCalls.
enum HttpMethod { GET, POST, PUT, PATCH, DELETE }

/// Service for making HTTP requests with retry and multipart support.
class HttpsCalls {
  final _ongoingRequests = <String, Future<http.Response>>{};
  final Duration _timeoutDuration = const Duration(seconds: 60);
  final int _maxRetries = 3;

  Future<http.Response> _performRequest(String key, Future<http.Response> Function() request) async {
    final hasInternet = await InternetService.hasWorkingInternet();
    LoggerService.d('Internet status: $hasInternet');

    if (hasInternet == false) {
      GlobalVariables.errorMessages = ["No internet connection"];
      return http.Response('No internet connection', 503);
    } else {
      if (_ongoingRequests.containsKey(key)) {
        return _ongoingRequests[key]!;
      }

      for (int retryCount = 0; retryCount <= _maxRetries; retryCount++) {
        try {
          final responseFuture = request().timeout(_timeoutDuration);
          _ongoingRequests[key] = responseFuture;
          final response = await responseFuture;
          _ongoingRequests.remove(key);
          LoggerService.i('Request succeeded for $key');
          return response;
        } on TimeoutException catch (e) {
          if (retryCount == _maxRetries) {
            _ongoingRequests.remove(key);
            LoggerService.e('Request timed out after $_maxRetries retries: $e');
            throw Exception('Request timed out after $_maxRetries retries: $e');
          }
          await Future.delayed(Duration(seconds: 2 * retryCount));
        } catch (e, stackTrace) {
          if (retryCount == _maxRetries) {
            _ongoingRequests.remove(key);
            LoggerService.e('Request failed after $_maxRetries retries: $e', error: e, stackTrace: stackTrace);
            throw Exception('Request failed after $_maxRetries retries: $e\n$stackTrace');
          }
          await Future.delayed(Duration(seconds: 2 * retryCount));
        }
      }
      _ongoingRequests.remove(key);
      throw Exception('Failed to perform request');
    }
  }

  Future<Map<String, String>> _getDefaultHeaders() async {
    final token = await SharedPreferencesService().readToken();
    if (token != null) {
      print('Authorization: $token');
    }
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

  Future<http.Response> _sendRequest(HttpMethod method, String lControllerUrl, {List<int>? body}) async {
    final headers = await _getDefaultHeaders();
    final url = Uri.parse(AppUrls.baseAPIURL + lControllerUrl);
    // LoggerService.d('Sending $method request to $url');
    switch (method) {
      case HttpMethod.GET:
        return await http.get(url, headers: headers);
      case HttpMethod.POST:
        return await http.post(url, headers: headers, body: body);
      case HttpMethod.PUT:
        return await http.put(url, headers: headers, body: body);
      case HttpMethod.PATCH:
        return await http.patch(url, headers: headers, body: body);
      case HttpMethod.DELETE:
        return await http.delete(url, headers: headers, body: body);
    }
  }

  Future<http.Response> getApiHits(String lControllerUrl) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.GET, lControllerUrl));
  }

  Future<http.Response> postApiHits(String lControllerUrl, List<int>? lUtfContent) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.POST, lControllerUrl, body: lUtfContent));
  }

  Future<http.Response> putApiHits(String lControllerUrl, List<int> lUtfContent) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.PUT, lControllerUrl, body: lUtfContent));
  }

  Future<http.Response> patchApiHits(String lControllerUrl, List<int> lUtfContent) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.PATCH, lControllerUrl, body: lUtfContent));
  }

  Future<http.Response> deleteApiHits(String lControllerUrl, List<int>? lUtfContent) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.DELETE, lControllerUrl, body: lUtfContent));
  }

  Future<http.Response> _genericMultipartRequest(
    String endpointUrl,
    dynamic model, {
    Map<String, dynamic Function()>? fileExtractors,
  }) async {
    final token = await SharedPreferencesService().readToken();
    final url = Uri.parse(AppUrls.baseAPIURL + endpointUrl);
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.acceptHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    final json = model.toJson();
    json.forEach((key, value) {
      if (value != null) {
        if (value is String || value is num || value is bool) {
          request.fields[key] = value.toString();
        } else if (value is List) {
          for (int i = 0; i < value.length; i++) {
            request.fields['$key[$i]'] = value[i].toString();
          }
        } else {
          // Handle nested objects by converting them to JSON strings
          try {
            request.fields[key] = jsonEncode(value);
          } catch (e) {
            LoggerService.e('Failed to encode $key to JSON: $e');
          }
        }
      }
    });

    if (fileExtractors != null) {
      for (var entry in fileExtractors.entries) {
        final key = entry.key;
        final value = entry.value();
        if (value is File) {
          request.files.add(await http.MultipartFile.fromPath(key, value.path));
        } else if (value is List<File>) {
          for (int i = 0; i < value.length; i++) {
            request.files.add(await http.MultipartFile.fromPath('$key[$i]', value[i].path));
          }
        }
      }
    }

    LoggerService.d('Sending multipart request to $endpointUrl with fields: ${request.fields}');
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // Future<http.Response> addJobMultiPart(String lControllerUrl, AddNewJobBodyModel addJobBodyModel) {
  //   return _performRequest(
  //     lControllerUrl,
  //     () => _genericMultipartRequest(lControllerUrl, addJobBodyModel, fileExtractors: {'images': () => addJobBodyModel.images}),
  //   );
  // }
  //
  // Future<http.Response> addReportMultiPart(String lControllerUrl, AddReportBodyModel addReportBodyModel) {
  //   return _performRequest(
  //     lControllerUrl,
  //     () => _genericMultipartRequest(lControllerUrl, addReportBodyModel, fileExtractors: {'images': () => addReportBodyModel.images}),
  //   );
  // }

  // Future<http.Response> editJobMultiPart(String lControllerUrl, AddNewJobBodyModel addJobBodyModel) {
  //   return _performRequest(
  //     lControllerUrl,
  //     () => _genericMultipartRequest(
  //       lControllerUrl,
  //       addJobBodyModel,
  //       fileExtractors: {'video': () => addJobBodyModel.video, 'images': () => addJobBodyModel.images},
  //     ),
  //   );
  // }

  Future<http.Response> signUpMultiPart(String lControllerUrl, SignUpBodyModel signUpBodyModel) {
    return _performRequest(
      lControllerUrl,
      () => _genericMultipartRequest(
        lControllerUrl,
        signUpBodyModel,
        fileExtractors: {'profileImage': () => signUpBodyModel.profilePicture},
      ),
    );
  }

  Future<http.Response> updateProfileMultiPart(String controllerUrl, SignUpBodyModel updateBodyModel) {
    return _performRequest(
      controllerUrl,
      () => _genericMultipartRequest(
        controllerUrl,
        updateBodyModel,
        fileExtractors: {'profileImage': () => updateBodyModel.profilePicture},
      ),
    );
  }

  // Future<http.Response> completeJobByMechanicMultiPart(String lControllerUrl, CompleteJobByMechanicBodyModel bodyModel) {
  //   return _performRequest(
  //     lControllerUrl,
  //     () => _genericMultipartRequest(lControllerUrl, bodyModel, fileExtractors: {'image': () => bodyModel.image}),
  //   );
  // }
}
