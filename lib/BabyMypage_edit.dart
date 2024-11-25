import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '우리 아이 정보 등록',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BabymypageEdit(),
    );
  }
}

class BabymypageEdit extends StatefulWidget {
  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends State<BabymypageEdit> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

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

  int? selectedValue; // 선택된 값을 저장할 변수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('우리 아이 정보 등록'), // 제목을 설정합니다.
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
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0095F6),
                                    borderRadius: BorderRadius.circular(
                                        100), // 모든 모서리를 둥글게 설정
                                  ),
                                  padding: EdgeInsets.only(
                                      top: 8, left: 8, right: 8, bottom: 8),
                                  // 위쪽에 8px 패딩 추가
                                  child: Center(
                                    child: Icon(
                                      Icons.photo_camera, // 카메라 아이콘
                                      color: Colors.white, // 아이콘 색상
                                      size: 16, // 아이콘 크기
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 아이의 이름이나 별명을 입력해주세요
                      Container(
                        height: 124,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Column(
                          children: [
                            Container(
                              width: 328,
                              height: 22,
                              child: Text(
                                '아이의 이름이나 별명을 입력해주세요',
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
                            SizedBox(height: 8), // 사이즈 박스 8
                            inputField(nicknameController, '모디랑', (value) {
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
                            Container(
                              width: 328,
                              height: 22,
                              child: Text(
                                '아이의 성별을 선택해주세요',
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
                              child: Text(
                                '아이의 생년월일을 입력해주세요',
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
                            SizedBox(height: 12), // 사이즈 박스 8
                            inputField2(birthDateController, '생년월일', (value) {
                              setState(() {}); // 텍스트 변화 시 상태 업데이트
                            }),
                          ],
                        ),
                      ),

                      Container(
                        height: 124,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Column(
                          children: [
                            Container(
                              width: 328,
                              height: 22,
                              child: Text(
                                '키',
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
                            SizedBox(height: 12), // 사이즈 박스 8
                            inputField2(birthDateController, 'cm', (value) {
                              setState(() {}); // 텍스트 변화 시 상태 업데이트
                            }),
                          ],
                        ),
                      ),
                      Container(
                        height: 124,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Column(
                          children: [
                            Container(
                              width: 328,
                              height: 22,
                              child: Text(
                                '몸무게',
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
                            SizedBox(height: 12), // 사이즈 박스 8
                            inputField2(birthDateController, '몸무게', (value) {
                              setState(() {}); // 텍스트 변화 시 상태 업데이트
                            }),
                          ],
                        ),
                      ),
                      Container(
                        width: 360,
                        height: 86,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Row(
                          children: [
                            Container(
                              width: 162,
                              height: 50,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: Color(0xFFB0B0B0)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '삭제하기',
                                  style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                    letterSpacing: -0.35,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 4), // 박스 사이의 간격 조정
                            Container(
                              width: 162,
                              height: 50,
                              decoration: ShapeDecoration(
                                color: Color(0xFF0095F6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              child: Center(
                                child: Text(
                                  '저장하기',
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
                          ],
                        ),
                      ),

                      Container(
                        width: 360,
                        height: 90,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Container(
                          width: 328,
                          height: 54,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFF5D5D5D)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '아이 추가하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF3D3D3D),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                                letterSpacing: -0.40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 54),
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

Widget inputField(TextEditingController controller, String hintText,
    Function(String) onChanged) {
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

Widget inputField2(TextEditingController controller, String hintText,
    Function(String) onChanged) {
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
          formattedValue += filteredValue.substring(
              0, filteredValue.length > 4 ? 4 : filteredValue.length);
        }
        if (filteredValue.length > 4) {
          formattedValue += '.' +
              filteredValue.substring(
                  4, filteredValue.length > 6 ? 6 : filteredValue.length);
        }
        if (filteredValue.length > 6) {
          formattedValue += '.' + filteredValue.substring(6);
        }

        // 업데이트된 값을 텍스트 필드에 설정
        controller.value = TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(
              offset: formattedValue.length), // 커서를 맨 뒤로 이동
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
            color: isSelected
                ? Color(0xFF0095F6)
                : Color(0xFFB0B0B0), // 선택된 버튼 테두리 색상
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
            color: isSelected ? Colors.white : Color(0xFFB0B0B0),
            // 선택된 버튼 글자 색상
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

Widget genderrightButton(
    String label, VoidCallback onPressed, bool isSelected) {
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
            color: isSelected
                ? Color(0xFF0095F6)
                : Color(0xFFB0B0B0), // 선택된 버튼 테두리 색상
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
            color: isSelected ? Colors.white : Color(0xFFB0B0B0),
            // 선택된 버튼 글자 색상
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
