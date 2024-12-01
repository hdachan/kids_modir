import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController nicknameController = TextEditingController(); // Child's Nickname
  final TextEditingController BirthDateController = TextEditingController(); // Gender
  final TextEditingController heightController = TextEditingController(); // Height
  final TextEditingController weightController = TextEditingController(); // Weight
  final TextEditingController qqqqController = TextEditingController(); // Weight


  bool isFemaleSelected = false; // 여자 버튼 선택 상태
  bool isMaleSelected = false; // 남자 버튼 선택 상태


  String loadedNickname = ''; // 로드한 닉네임
  String loadBirthDate ='';
  String loadedGender = ''; // 로드한 성별
  String loadedHeight = ''; // 로드한 키
  String loadedWeight = ''; // 로드한 몸무게


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loadBabyInfo(); // 사용자 데이터 불러오기
  }

  Future<void> saveBabyInfo() async {
    try {
      // 현재 사용자 ID 가져오기
      String userId = auth.currentUser?.uid ?? ''; // 현재 로그인한 사용자 UID

      if (userId.isEmpty) {
        print('User is not logged in');
        return; // 로그인이 되어 있지 않으면 함수 종료
      }

      String gender = isMaleSelected ? '남자' : '여자'; // 선택된 성별

      // Firestore에서 아기 정보 문서 참조 가져오기
      // 사용자 UID를 사용하여 문서 ID 생성
      DocumentReference babyDoc = firestore.collection('users').doc(userId).collection('baby').doc(userId); // 사용자 UID를 문서 ID로 사용

      // Firestore에 데이터 저장 (문서가 없으면 생성하고, 있으면 업데이트)
      await babyDoc.set({
        'nickname': nicknameController.text,
        'BirthDate': BirthDateController.text, // 생년월일
        'height': heightController.text,
        'weight': weightController.text,
        'gender': gender,
      }, SetOptions(merge: true)); // merge: true로 설정하여 기존 필드에 추가 및 업데이트

      print('Baby info saved successfully!');
    } catch (e) {
      print('Error saving baby info: $e');
    }
  }


  Future<void> loadBabyInfo() async {
    try {
      // 현재 사용자 ID 가져오기
      String userId = auth.currentUser?.uid ?? ''; // 현재 로그인한 사용자 UID

      if (userId.isEmpty) {
        print('User is not logged in');
        return; // 로그인이 되어 있지 않으면 함수 종료
      }

      // Firestore에서 아기 정보 불러오기
      DocumentSnapshot babyDoc = await firestore.collection('users').doc(userId).collection('baby').doc(userId).get();

      if (babyDoc.exists) {
        // 문서의 데이터를 가져와서 입력 필드에 설정
        var babyData = babyDoc.data() as Map<String, dynamic>;

        loadedNickname = babyData['nickname'] ?? '';
        loadBirthDate = babyData['BirthDate'] ?? ''; // 생년월일
        loadedHeight = babyData['height'] ?? '';
        loadedWeight = babyData['weight'] ?? '';
        loadedGender = babyData['gender'] ?? ''; // 성별 정보 로드

        // 입력 필드에 로드한 데이터 설정
        nicknameController.text = loadedNickname;
        BirthDateController.text = loadBirthDate;
        heightController.text = loadedHeight;
        weightController.text = loadedWeight;

        // 성별에 따라 버튼 선택 상태 업데이트
        if (loadedGender == '남자') {
          selectMale(); // 남자 선택
        } else if (loadedGender == '여자') {
          selectFemale(); // 여자 선택
        }

        print('Baby info loaded successfully!');
      } else {
        print('No baby info found for this user.');
      }
    } catch (e) {
      print('Error loading baby info: $e');
    }
  }




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
                            SubTitle('아이의 이름이나 별명을 입력해주세요'),
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
                            SubTitle('아이의 성별을 선택해주세요'),
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
                            SubTitle('아이의 생년월일을 입력해주세요'),
                            SizedBox(height: 12), // 사이즈 박스 8
                            inputField2(BirthDateController, '생년월일', (value) {
                              setState(() {}); // 텍스트 변화 시 상태 업데이트
                            }),
                          ],
                        ),
                      ),

                      // 키
                      Container(
                        height: 124,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Column(
                          children: [
                            SubTitle('키'),
                            SizedBox(height: 12), // 사이즈 박스 8
                            inputField3(heightController, 'cm', (value) {
                              setState(() {}); // 텍스트 변화 시 상태 업데이트
                            }),
                          ],
                        ),
                      ),
                      //몸무게
                      Container(
                        height: 124,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Column(
                          children: [
                            SubTitle('몸무게'),
                            SizedBox(height: 12), // 사이즈 박스 8
                            inputField3(weightController, '몸무게', (value) {
                              setState(() {}); // 텍스트 변화 시 상태 업데이트
                            }),
                          ],
                        ),
                      ),

                      //관심사
                      Container(
                        height: 200,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 24),
                        child: Column(
                          children: [
                            SubTitle('관심사'),
                            SizedBox(height: 12), // 사이즈 박스 8
                            inputField3(qqqqController, '현재 관심사 기능은 준비중입니다', (value) {
                              setState(() {}); // 텍스트 변화 시 상태 업데이트
                            }),
                            SizedBox(height: 12), // 사이즈 박스 8
                            Container(
                              width: 328,
                              height: 64,
                              child: Container(
                                width: 328,
                                height: 26,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start, // 가로 왼쪽 정렬
                                  children: [
                                    customTextContainer('레이싱카 X'),
                                    SizedBox(width: 12),
                                    customTextContainer('퍼즐 X'),
                                    SizedBox(width: 12),
                                    customTextContainer('보드게임 X'),
                                    SizedBox(width: 12),
                                    customTextContainer('보드게임 X'),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),



                      // 저장하기 삭제하기
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
                            ElevatedButton(
                              onPressed: () {
                                saveBabyInfo();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0095F6), // 배경색
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4), // 모서리 둥글게
                                ),
                                fixedSize: Size(162, 50), // 버튼 크기 설정
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
                      //아이 추가하기
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

// 관심사 버튼
Widget customTextContainer(String text) {
  return Container(
    height: 26,
    padding: EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 4.0, bottom: 4.0), // 좌우 8, 위아래 4 패딩 추가
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0xFF0095F6)),
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF0095F6),
        fontSize: 14,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: -0.35,
      ),
    ),
  );
}



//닉네임 위젯
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

//생년월일 위젯
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

//숫자 위젯
Widget inputField3(TextEditingController controller, String hintText,
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
      onChanged: onChanged,
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
      // 숫자만 입력 가능하게 하고 최대 3자리로 제한
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // 숫자만 허용
        LengthLimitingTextInputFormatter(3), // 최대 3자리 제한
      ],
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

// 제목
Widget SubTitle(String text) {
  return Container(
    width: 328,
    height: 22,
    child: Text(
      text,
      style: TextStyle(
        color: Color(0xFF3D3D3D),
        fontSize: 16,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: -0.40,
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


