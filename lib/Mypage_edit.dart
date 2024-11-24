import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html' as html; // 웹에서 파일 처리
import 'dart:typed_data'; // Uint8List 사용을 위한 import

import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyPageEdit(),
    );
  }
}

class MyPageEdit extends StatefulWidget {
  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends State<MyPageEdit> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  final ImagePicker _picker = ImagePicker(); // 필드로 정의
  final FirebaseAuth _auth = FirebaseAuth.instance;


  bool isFemaleSelected = false; // 여자 버튼 선택 상태
  bool isMaleSelected = false; // 남자 버튼 선택 상태

  void selectFemale() {
    setState(() {
      isFemaleSelected = true;
      isMaleSelected = false; // 남자 버튼 비선택
    });
  }

  void selectMale() {
    setState(() {
      isMaleSelected = true;
      isFemaleSelected = false; // 여자 버튼 비선택
    });
  }

  Future<void> _pickAndUploadImage() async {
    // 갤러리에서 이미지 선택
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        String fileName = image.name;

        // 현재 플랫폼이 웹인지 확인
        if (html.window.navigator.userAgent.contains('Chrome')) {
          // 웹에서 이미지 업로드
          final reader = html.FileReader();
          final file = html.File([await html.HttpRequest.request(image.path)], fileName); // Blob 생성

          reader.readAsArrayBuffer(file); // ArrayBuffer로 읽기
          reader.onLoadEnd.listen((e) async {
            // Firebase Storage에 업로드
            Uint8List fileData = reader.result as Uint8List; // Uint8List로 변환
            await FirebaseStorage.instance.ref('profile_pictures/$fileName').putData(fileData);

            // 업로드 완료 후 URL 가져오기
            String downloadURL = await FirebaseStorage.instance.ref('profile_pictures/$fileName').getDownloadURL();
            print('프로필 사진 URL: $downloadURL');
            await _saveProfilePictureURL(downloadURL); // Firestore에 URL 저장
          });
        } else {
          // 모바일 플랫폼에서 처리
          final file = File(image.path); // 모바일에서는 File 사용 가능
          await FirebaseStorage.instance.ref('profile_pictures/$fileName').putFile(file);

          // 업로드 완료 후 URL 가져오기
          String downloadURL = await FirebaseStorage.instance.ref('profile_pictures/$fileName').getDownloadURL();
          print('프로필 사진 URL: $downloadURL');
          await _saveProfilePictureURL(downloadURL); // Firestore에 URL 저장
        }
      } catch (e) {
        print('업로드 중 오류 발생: $e');
      }
    }
  }

  Future<void> _saveProfilePictureURL(String url) async {
    User? user = _auth.currentUser; // 현재 사용자 가져오기
    if (user != null) {
      String email = user.email!; // 사용자 이메일 가져오기
      await FirebaseFirestore.instance.collection('users').doc(email).update({
        'profile_picture': url,
      });
    } else {
      print('사용자가 로그인하지 않았습니다.');
    }
  }

  Future<void> next() async {
    final String nickname = nicknameController.text;
    final String birthDate = birthDateController.text;

    if (nickname.trim().isEmpty) {
      print('오류: 닉네임을 입력해주세요.');
      return;
    }

    if (birthDate.trim().isEmpty) {
      print('오류:생년월일을 입력해주세요.');
      return;
    }

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // 가입 날짜를 Firestore에 저장
        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDoc.set({
          'nickname': nickname,
          'birthDate': birthDate,
          'editData': FieldValue.serverTimestamp(), // 가입 날짜 저장
        }, SetOptions(merge: true));

        print('사용자 정보가 성공적으로 업데이트되었습니다.');

        // Firestore에서 가입 날짜를 가져와서 출력
        DocumentSnapshot userSnapshot = await userDoc.get();
        if (userSnapshot.exists) {
          Timestamp createdAtTimestamp = userSnapshot['editData'];
          DateTime editData = createdAtTimestamp.toDate();
          print('가입 날짜: ${editData.toLocal()}');
        } else {
          print('오류: 사용자 정보를 가져올 수 없습니다.');
        }
      } else {
        print('오류: 사용자가 로그인되어 있지 않습니다.');
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Home_Screen()),
      );
    } catch (e) {
      print('오류: 사용자 정보를 업데이트하는 데 실패했습니다. ${e.toString()}');
    }
  }


  @override
  void initState() {
    super.initState();
    loadUserData(); // 사용자 데이터 불러오기
  }

  Future<void> loadUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        DocumentSnapshot userSnapshot = await userDoc.get();

        if (userSnapshot.exists) {
          String nickname = userSnapshot['nickname'] ?? '';
          String birthDate = userSnapshot['birthDate'] ?? '';

          nicknameController.text = nickname;
          birthDateController.text = birthDate;

          print('사용자 정보가 성공적으로 로드되었습니다.');
        } else {
          print('오류: 사용자 문서가 존재하지 않습니다.');
        }
      } else {
        print('오류: 사용자가 로그인되어 있지 않습니다.');
      }
    } catch (e) {
      print('오류: 사용자 정보를 로드하는 데 실패했습니다. ${e.toString()}');
    }
  }

  int? selectedValue; // 선택된 값을 저장할 변수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 수정하기'), // 제목을 설정합니다.
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 360,
                  color: Colors.white,
                  child: Column(
                    children: [
                      // 사진
                      Container(
                        height: 226,
                        width: 360,
                        padding: EdgeInsets.fromLTRB(16, 36, 16, 24),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.bottomRight, // 오른쪽 하단에 정렬
                            children: [
                              Stack(
                                alignment: Alignment.center, // 이미지를 중앙에 배치
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black, // 내부 박스 색상
                                      borderRadius: BorderRadius.circular(
                                          100), // 모든 모서리를 둥글게 설정
                                    ),
                                  ),
                                  ClipOval(
                                    // 이미지를 둥글게 잘라내기 위해 ClipOval 사용
                                    child: Image.asset(
                                      // 또는 Image.network() 사용 가능
                                      'assets/image/profile img.png',
                                      // 여기에 프로필 이미지 경로를 입력하세요
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 자르기
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 0, // 오른쪽 위치
                                bottom: 0, // 아래 위치
                                child: InkWell(
                                  onTap: () {
                                    // 버튼 클릭 시 실행할 코드
                                    _pickAndUploadImage();
                                  },
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0095F6),
                                      borderRadius: BorderRadius.circular(100), // 모든 모서리를 둥글게 설정
                                    ),
                                    padding: EdgeInsets.only(
                                      top: 8, left: 8, right: 8, bottom: 8,
                                    ), // 위쪽에 8px 패딩 추가
                                    child: Center(
                                      child: Icon(
                                        Icons.photo_camera, // 카메라 아이콘
                                        color: Colors.white, // 아이콘 색상
                                        size: 16, // 아이콘 크기
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 닉네임
                      Container(
                        height: 149,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 328,
                              height: 47,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 41,
                                        height: 22,
                                        child: Text(
                                          '닉네임',
                                          style: TextStyle(
                                            color: Color(0xFF3D3D3D),
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                            letterSpacing: -0.40,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 287,
                                        height: 22,
                                        child: Text(
                                          '*',
                                          style: TextStyle(
                                            color: Color(0xFFFF3333),
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                            letterSpacing: -0.40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8), // 사이즈 박스 8
                                  Container(
                                    width: 328,
                                    height: 17,
                                    child: Text(
                                      '닉네임은 한 달에 한번 변경이 가능합니다',
                                      style: TextStyle(
                                        color: Color(0xFF888888),
                                        fontSize: 12,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12), // 사이즈 박스 8
                            inputField(nicknameController, '닉네임', (value) {
                              setState(() {}); // 텍스트 변화 시 상태 업데이트
                            }),
                          ],
                        ),
                      ),

                      // 성별을 선택하세요
                      Container(
                        height: 124,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 22,
                                  child: Text(
                                    '성별',
                                    style: TextStyle(
                                      color: Color(0xFF3D3D3D),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                      letterSpacing: -0.40,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 300,
                                  height: 22,
                                  child: Text(
                                    '*',
                                    style: TextStyle(
                                      color: Color(0xFFFF3333),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                      letterSpacing: -0.40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Container(
                              width: 328,
                              height: 54,
                              child: Row(
                                children: [
                                  genderleftButton(
                                    '여아',
                                    selectFemale, // 여자 버튼 클릭 시 selectFemale 호출
                                    isFemaleSelected, // 선택 상태 전달
                                  ),
                                  genderrightButton(
                                    '남자',
                                    selectMale, // 남자 버튼 클릭 시 selectMale 호출
                                    isMaleSelected, // 선택 상태 전달
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 생년월일
                      Container(
                        height: 124,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 328,
                              height: 22,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 22,
                                        child: Text(
                                          '생년월일',
                                          style: TextStyle(
                                            color: Color(0xFF3D3D3D),
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                            letterSpacing: -0.40,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 273,
                                        height: 22,
                                        child: Text(
                                          '*',
                                          style: TextStyle(
                                            color: Color(0xFFFF3333),
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                            letterSpacing: -0.40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12), // 사이즈 박스 8
                            inputField2(birthDateController, '생년월일', (value) {
                              setState(() {}); // 텍스트 변화 시 상태 업데이트
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 54),
                      saveButton(
                        '저장하기',
                            () {
                          next();
                        },
                        (nicknameController.text.trim().isNotEmpty && birthDateController.text.trim().isNotEmpty)
                            ? Color(0xFF0095F6) // 입력이 모두 있을 때의 색상
                            : Color(0xFFB0B0B0), // 입력이 없을 때의 색상
                      ),
                    ],
                  ),
                ),
              ),
              // 추가적인 위젯들을 여기에 추가할 수 있습니다.
            ],
          ),
        ),
      ),
    );
  }
}



// 닉네임 인풋필드
Widget inputField(TextEditingController controller, String hintText, Function(String) onChanged) {
  return Container(
    width: 328,
    height: 54,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0xFF888888)),
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    child: TextField(
      controller: controller,
      onChanged: onChanged, // 부모에서 전달된 콜백 사용
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFFB0B0B0),
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 2.7,
          letterSpacing: -0.35,
        ),
        border: InputBorder.none, // 테두리 없음
      ),
      style: TextStyle(
        color: Color(0xFF3D3D3D),
        fontSize: 14,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        height: 2.7,
        letterSpacing: -0.35,
      ),
    ),
  );
}

// 생년월일 인풋필드
Widget inputField2(TextEditingController controller, String hintText, Function(String) onChanged) {
  return Container(
    width: 328,
    height: 54,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0xFF888888)),
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    child: TextField(
      controller: controller,
      onChanged: (value) {
        // 숫자만 필터링
        String filteredValue = value.replaceAll(RegExp(r'[^0-9]'), '');

        // 최대 길이 제한 (8글자)
        if (filteredValue.length > 8) {
          filteredValue = filteredValue.substring(0, 8);
        }

        // 생년월일 형식으로 변환
        String formattedValue = '';
        if (filteredValue.length > 0) {
          formattedValue += filteredValue.substring(0, filteredValue.length > 4 ? 4 : filteredValue.length);
        }
        if (filteredValue.length > 4) {
          formattedValue += '.' + filteredValue.substring(4, filteredValue.length > 6 ? 6 : filteredValue.length);
        }
        if (filteredValue.length > 6) {
          formattedValue += '.' + filteredValue.substring(6);
        }

        // 업데이트된 값을 텍스트 필드에 설정
        controller.value = TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length), // 커서를 맨 뒤로 이동
        );

        // 부모에서 전달된 콜백 호출
        onChanged(formattedValue);
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFFB0B0B0),
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 2.7,
          letterSpacing: -0.35,
        ),
        border: InputBorder.none, // 테두리 없음
      ),
      style: TextStyle(
        color: Color(0xFF3D3D3D),
        fontSize: 14,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        height: 2.7,
        letterSpacing: -0.35,
      ),
      keyboardType: TextInputType.number, // 숫자 키패드
    ),
  );
}

// 성별 여자버튼
Widget genderleftButton(String label, VoidCallback onPressed, bool isSelected) {
  return InkWell(
    onTap: onPressed, // 버튼 클릭 시 실행될 함수
    child: Container(
      width: 164,
      height: 54,
      decoration: ShapeDecoration(
        color: isSelected ? Color(0xFF0095F6) : Colors.white, // 선택된 버튼 색상
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: isSelected ? Color(0xFF0095F6) : Color(0xFFB0B0B0), // 선택된 버튼 테두리 색상
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
        ),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFFB0B0B0), // 선택된 버튼 글자 색상
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: -0.40,
          ),
        ),
      ),
    ),
  );
}

// 성별 남자버튼
Widget genderrightButton(String label, VoidCallback onPressed, bool isSelected) {
  return InkWell(
    onTap: onPressed, // 버튼 클릭 시 실행될 함수
    child: Container(
      width: 164,
      height: 54,
      decoration: ShapeDecoration(
        color: isSelected ? Color(0xFF0095F6) : Colors.white, // 선택된 버튼 색상
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: isSelected ? Color(0xFF0095F6) : Color(0xFFB0B0B0), // 선택된 버튼 테두리 색상
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(4), // 오른쪽 상단을 둥글게
            bottomRight: Radius.circular(4), // 오른쪽 하단을 둥글게
          ),
        ),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFFB0B0B0), // 선택된 버튼 글자 색상
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: -0.40,
          ),
        ),
      ),
    ),
  );
}

// 저장하기 버튼
Widget saveButton(String label, VoidCallback onPressed, Color backgroundColor) {
  return InkWell(
    onTap: onPressed, // 버튼 클릭 시 실행될 함수
    child: Container(
      height: 50,
      width: 328,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor, // 배경색 지정
        borderRadius: BorderRadius.circular(4), // 모서리 둥글게
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.3,
            letterSpacing: -0.35,
          ),
        ),
      ),
    ),
  );
}

