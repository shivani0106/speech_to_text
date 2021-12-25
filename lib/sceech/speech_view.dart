import 'package:flutter/material.dart';
import 'package:flutter_speech/sceech/speech_view_model.dart';
import 'package:provider/provider.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechViewModel mViewModel;

  @override
  void initState() {
    mViewModel = Provider.of<SpeechViewModel>(context, listen: false);
    Future.delayed(Duration.zero, () {
      mViewModel.attachContext(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<SpeechViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Speech'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        margin: EdgeInsets.only(top: 35, bottom: 35, right: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              mViewModel.newSearchKeyword,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            ),
            mViewModel.apiResponse == null
                ? Container()
                : mViewModel.isAPILoading
                    ? CircularProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: Colors.black12.withOpacity(0.05)),
                            child: Column(
                              children: [
                                Text(
                                  "Meaning",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  mViewModel
                                      .apiResponse.definitions[0].definition,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: Colors.black12.withOpacity(0.05)),
                            child: Column(
                              children: [
                                Text(
                                  "Example",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  mViewModel.apiResponse.definitions[0].example,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.network(
                                mViewModel.apiResponse.definitions[0].imageUrl),
                          )
                        ],
                      ),
            FloatingActionButton(
              onPressed: () {
                mViewModel.listen();
              },
              child: Icon(Icons.mic),
            ),
          ],
        ),
      ),
    );
  }
}
