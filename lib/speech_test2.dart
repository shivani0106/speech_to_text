import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'bottom_sheet.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  var newSearchKeyword = "";
  @override
  Widget build(BuildContext context) {
    showBottomSheet() async {
      var newKeyWord = await showModalBottomSheet(
          context: context,
          builder: (context) {
            return MyBottomSheet();
          });
      if (mounted) {
        setState(() {
          newSearchKeyword = newKeyWord;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Speech'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            FloatingActionButton(
              onPressed: () {
                showBottomSheet();
              },
              child: Icon(Icons.mic),
            ),
            Text(
              newSearchKeyword,
              style: TextStyle(fontSize: 26),
            )
          ],
        ),
      ),
    );
  }
}
