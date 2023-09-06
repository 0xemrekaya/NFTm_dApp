import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class NftMainScreen extends ConsumerStatefulWidget {
  static String id = "NFT Main Screen";
  const NftMainScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NftMainScreenState();
}

class _NftMainScreenState extends ConsumerState<NftMainScreen> {
  Uri url = Uri.parse('https://api.pinata.cloud');
  final apiKey = dotenv.env['INFURA_KEY'];
  final apiSecretKey = dotenv.env['INFURA_SECRET_KEY'];
  final imagePicker = ImagePicker();
  Uint8List? selectedFileBytes;
  File? filePath;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.1, vertical: deviceHeight * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imgPicker(deviceWidth),
            SizedBox(
              height: deviceHeight / 50,
            ),
            const TextField(),
            const TextField(),
            const TextField(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                        final hash = await addFileToIPFS(filePath!.path);
                        print('File uploaded to IPFS with hash: $hash');
                      
                    },
                    child: const Text(
                      'Create NFT',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector imgPicker(double deviceWidth) {
    return GestureDetector(
      onTap: () async {
        await imgFromGallery();
      },
      child: Container(
        color: filePath == null ? Colors.white : Colors.white,
        child: filePath != null
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
                child: Image.file(
                  width: deviceWidth / 1,
                  height: deviceWidth / 2,
                  fit: BoxFit.cover,
                  filePath!,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey[300],
                    borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ]),
                width: deviceWidth / 1,
                height: deviceWidth / 2,
                child: const Icon(
                  Icons.photo,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }

  Future<void> imgFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() async{
      if (pickedFile != null) {
        filePath = File(pickedFile.path);
        selectedFileBytes = await pickedFile.readAsBytes();
      } else {
        print('No image selected.');
      }
    });
  }
          // const AlertDialog(
          // title: Text('No image selected.'),
          // icon: Icon(Icons.add_alert_sharp),

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
  // Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 color: Colors.grey[300],
  //               ),
  //               height: deviceHeight / 4,
  //               width: deviceWidth * 0.8,
  //               child: filePath != null
  //                   ? Image.file(filePath!)
  //                   : ElevatedButton.icon(
  //                       onPressed: () async {
  //                         imgFromGallery();
  //                       },
  //                       icon: const Icon(Icons.photo),
  //                       label: Text(
  //                         "Upload a image",
  //                         style: textStyle.titleMedium,
  //                       )))
}
