import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImgbbController  extends ChangeNotifier{
  static final String _apiKey = 'b8c205b3a397fdf1cd2b547a0731e074';

  Future<String?> uploadImage(XFile image)async{
    final bytes = image.readAsBytes();
    final base64Image = base64Encode(await bytes);

    final url = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
    final response = await http.post(url, body: {"image": base64Image});

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data['data']['url'];
    }
    return null;
  }
}