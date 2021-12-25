import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MyBottomSheet extends StatefulWidget {
  MyBottomSheet();
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  String showSearchValue = "Speak now";
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _listen();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
          debugLogging: true);
      print("hdjfhd=>" + available.toString());
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              showSearchValue = val.recognizedWords;
              print("show word=>" + showSearchValue);
              if (val.recognizedWords != null && !_speech.isListening) {
                Future.delayed(Duration(milliseconds: 1000), () {
                  if (mounted) Navigator.pop(context, showSearchValue);
                });
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            showSearchValue,
            style: TextStyle(fontSize: 26),
          ),
          Container(
            color: Colors.white,
            width: 100.0,
            height: 100.0,
            child: SpinKitWave(
              itemBuilder: (_, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                );
              },
              size: 60.0,
            ),
          )
        ],
      ),
    );
  }
}
