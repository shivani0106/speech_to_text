import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_speech/model/respose_model.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechViewModel with ChangeNotifier {
  static final BASE_URL = "https://owlbot.info/api/v4/dictionary/";
  bool isAPILoading = false;
  BuildContext mContext;
  stt.SpeechToText _speech;
  bool _isListening = false;
  var newSearchKeyword = "Press the button to Start speaking";
  APIResponse apiResponse;
  bool apiResponseGet;

  attachContext(BuildContext context) {
    mContext = context;
    _speech = stt.SpeechToText();
  }

  Future<APIResponse> getResponse(String name) async {
    final http.Response response = await http.get(Uri.parse(BASE_URL + "$name"),
        headers: {
          "Authorization": "Token 08a5e3222b8be11a8bdcbaa455cb0f7ab1e7f608"
        });
    print(response.body.toString());
    if (response.statusCode == 200) {
      return APIResponse.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> getApiResponse(String name) async {
    isAPILoading = true;
    notifyListeners();
    apiResponse = await getResponse(name);
    isAPILoading = false;
    if (apiResponse != null) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  void listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
          debugLogging: true);
      print("World=>" + available.toString());
      if (available) {
        _speech.listen(onResult: (val) {
          newSearchKeyword = val.recognizedWords;
          print("show word=>" + newSearchKeyword);
          getApiResponse(newSearchKeyword).then((value) {
            if (value) {
              apiResponseGet = value;
            } else {
              apiResponseGet = false;
            }
            notifyListeners();
          });
        });
      }
      notifyListeners();
    } else {
      _isListening = false;
      _speech.stop();
      notifyListeners();
    }
  }
}
