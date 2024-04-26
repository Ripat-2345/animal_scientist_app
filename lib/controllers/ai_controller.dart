// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AiController extends GetxController {
  bool _bahasaPromnt = true;
  String _myResult = '';

  bool get bahasaPromnt => _bahasaPromnt;
  String get myResult => _myResult;

  set bahasaPromnt(bool newBahasaPromnt) {
    _bahasaPromnt = newBahasaPromnt;
    update();
  }

  Future getdata(image, promptValue) async {
    try {
      const apiUrl =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=AIzaSyC2cZoe_jDJyyjOb_NC6XsZVMHOkNiQ_zg';

      List<int> imageBytes = File(image.path).readAsBytesSync();
      String base64File = base64.encode(imageBytes);

      final data = {
        "contents": [
          {
            "parts": [
              {"text": promptValue},
              {
                "inlineData": {
                  "mimeType": "image/jpeg",
                  "data": base64File,
                }
              }
            ]
          }
        ],
      };

      await http
          .post(Uri.parse(apiUrl),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(data))
          .then((response) {
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          _myResult = result['candidates'][0]['content']['parts'][0]['text'];
          update();
        } else {
          _myResult = 'Response status : ${response.statusCode}';
          update();
        }
      }).catchError((error) {
        print('Error occored ${error}');
      });
    } catch (e) {
      print('Error occured ${e}');
    }
  }
}
