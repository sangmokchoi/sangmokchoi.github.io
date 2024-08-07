
import 'package:firebase_storage/firebase_storage.dart';

import '../Constant.dart';
import '../Model/Image.dart';

class FirebaseDS {

  static final FirebaseDS _instance = FirebaseDS._internal();
  FirebaseDS._internal();
  factory FirebaseDS() {
    return _instance;
  }

  Stream<List<ImageModel>> fetchAllImages(Reference ref, Set<String> imagePaths, List<ImageModel> images) async* {

    final FirebaseStorage storage = FirebaseStorage.instance;

    final Reference meJpegRef = storage.ref().child('me.jpeg');
    try {
      final String meJpegFullPath = meJpegRef.fullPath;
      // 중복 이미지 체크
      if (!imagePaths.contains(meJpegFullPath)) {
        String downloadURL = await meJpegRef.getDownloadURL();
        images.add(ImageModel('me.jpeg', meJpegFullPath, downloadURL));
        imagePaths.add(meJpegFullPath); // Set에 경로 추가
      }
      // 현재 폴더의 이미지 발행
      yield List.from(images);
    } catch (e) {
      print("me.jpeg 파일을 가져오는 중 오류 발생: $e");
    }

    for (var key in kAppNameList.keys) {

      final Reference folderRef = storage.ref().child(key);
      final ListResult result = await folderRef.listAll();

      // 현재 폴더의 모든 파일 처리
      for (var item in result.items) {
        final String fullPath = item.fullPath;
        print("fullPath: ${fullPath}");

        final String appName = fullPath
            .split('/')
            .first;
        // 중복 이미지 체크
        if (!imagePaths.contains(fullPath)) {
          String downloadURL = await item.getDownloadURL();
          images.add(ImageModel(appName, fullPath, downloadURL));
          imagePaths.add(fullPath); // Set에 경로 추가
        }
      }


      // 현재 폴더의 이미지 발행
      yield List.from(images);

      // 현재 폴더의 모든 하위 폴더 탐색
      for (var prefix in result.prefixes) {
        await for (var subImages in fetchAllImages(
            prefix, imagePaths, images)) {
          // 하위 폴더의 이미지 추가
          yield List.from(images);
        }
      }
    }
  }

}