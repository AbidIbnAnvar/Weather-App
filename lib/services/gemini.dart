import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class Gemini {
  final String _apiKey = 'AIzaSyDilZOKzLkQQyu0_GQllyl3hgYuKdm2aH8';

  Future<Map> generateResponse(String prompt) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey,
    );
    print(prompt);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    var generatedText = response.text;
    generatedText = generatedText?.substring(7, generatedText.length - 3);
    final answer = jsonDecode(generatedText!);
    print(answer);
    return answer;
  }
}
