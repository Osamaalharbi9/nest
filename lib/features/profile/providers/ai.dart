import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nest/core/services.dart'; // Ensure this file handles the API key securely.

Future<String> getMovieNightRecommendation(List<String> movies) async {
  String prompt = "User's favorite movies are: ${movies.join(', ')}. "
      "Recommend one movie title only, without any additional context or explanation. "
      "Just return the title of the recommended movie.";

  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $gptApiKey', // Ensure the API key is passed correctly
    },
    body: jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': 20, // Keep the token limit small to reduce chances of additional text
    }),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    String movieTitle = data['choices'][0]['message']['content'].trim();

    // Ensure the response contains only the title without additional text
    if (movieTitle.contains(' ')) {
      // If there is more than one word, keep only the first part (likely the title)
      movieTitle = movieTitle.split('\n').first; // Remove everything after newline, just in case
    }

    return movieTitle;
  } else {
    print('Error: ${response.statusCode}, ${response.body}'); // Log the error
    throw Exception('Failed to get recommendation');
  }
}
