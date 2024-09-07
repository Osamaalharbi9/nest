import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nest/core/services.dart';

Future<String> getMovieNightRecommendation(List<String> movies) async {
  String prompt = "Based on the user's favorite movies: ${movies.join(', ')}, "
      "recommend a movie night theme and suggest three movies that would be great to watch together.";

  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization':
          '$gptApiKey', // Replace with your API key
    },
    body: jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': 150,
    }),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'].trim();
  } else {
    print('Error: ${response.body}');
    throw Exception('Failed to get recommendation');
  }
}
