import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/constants.dart';

class Gemini {
  late String _geminiApiKey;
  Future<Map> generateResponse(String prompt) async {
    _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? 'API key not found';
    if (_geminiApiKey == 'API key not found') {
      Future.error('Error in getting API key');
    }
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _geminiApiKey,
    );
    print(prompt);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    print(response.text);
    final answer;
    var generatedText = response.text;
    if (generatedText?[0] != '{') {
      generatedText = generatedText?.substring(7, generatedText.length - 3);
    }
    answer = jsonDecode(generatedText!);
    print(answer.runtimeType);
    return answer;
  }
}
