import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ollama_chat/constants/ollama_constants.dart';

class OllamaResponseModel {
  final String model;
  final DateTime createdAt;
  final String response;
  final bool done;

  OllamaResponseModel({
    required this.model,
    required this.createdAt,
    required this.response,
    required this.done,
  });

  factory OllamaResponseModel.fromJson(Map<String, dynamic> json) {
    return OllamaResponseModel(
      model: json['model'],
      createdAt: DateTime.parse(json['created_at']),
      response: json['response'],
      done: json['done'],
    );
  }
}

class OllamaRequestModel {
  /// The modal (such as mistral) which should be used
  String model;

  OllamaRequestModel(this.model);

  /// Send message to AI
  Stream<OllamaResponseModel> sendMessage(String message) async* {
    final url = Uri.parse(OllamaConstants.url);
    final streamedResponse = http
        .post(
          url,
          body: json.encode({'model': model.toString(), 'prompt': message}),
        )
        .asStream();

    await for (final chunk in streamedResponse) {
      final lines = (utf8.decode(chunk.bodyBytes).split('\n'));

      for (final line in lines) {
        if (line.isNotEmpty) {
          final decodedChunk = OllamaResponseModel.fromJson(json.decode(line));
          yield decodedChunk;
        }
      }
    }

    // for (final line in responseLines) {
    //   if (line.isNotEmpty) {
    //     final decodedChunk = OllamaResponseModel.fromJson(json.decode(line));
    //     yield decodedChunk;
    //   }
    // }
  }
}
