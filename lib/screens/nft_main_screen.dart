import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NftMainScreen extends ConsumerWidget {
  NftMainScreen({super.key});
  static String id = "NFT Main Screen";
  Uri url = Uri.parse('https://api.pinata.cloud');
  final apiKey = dotenv.env['INFURA_KEY'];
  final apiSecretKey = dotenv.env['INFURA_SECRET_KEY'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal : deviceWidth * 0.1, vertical: deviceHeight * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                height: deviceHeight / 4,
                width: deviceWidth * 0.8,
                child: ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.photo), label: Text("Upload a image"))),
            SizedBox(
              height: deviceHeight / 50,
            ),
            TextField(),
            TextField(),
            TextField(),
            
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        final filePath = result.files.single.path!;
                        final hash = await addFileToIPFS(filePath);
                        print('File uploaded to IPFS with hash: $hash');
                      }
                      print("aaaaa");
                    },
                    child: Text('Create NFT'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> addFileToIPFS(String filePath) async {
    final url = Uri.parse('https://ipfs.infura.io:5001/api/v0/add');
    final file = File(filePath);
    final auth = 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecretKey'))}';
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = auth
      ..files.add(await http.MultipartFile.fromPath('path', file.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(await response.stream.bytesToString());
      return jsonResponse['Hash'];
    } else {
      throw Exception('Failed to add file to IPFS');
    }
  }
}
