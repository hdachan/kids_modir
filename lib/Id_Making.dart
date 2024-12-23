import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

// 별명입력하기
void main() {
  runApp(MaterialApp(
    home: IdMaking(),
  ));
}

class IdMaking extends StatefulWidget {
  @override
  _IdMaking createState() => _IdMaking();
}

const List<Widget> gender = <Widget>[Text('남자'), Text('여자')];

class _IdMaking extends State<IdMaking> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String nicknameErrorMessage = ''; // 클래스 멤버 변수 이름 변경
  String birthDateErrorMexssage = '';

  Future<void> next() async {
    final String nickname = nicknameController.text;
    final String birthDate = birthDateController.text;

    if (nickname.trim().isEmpty) {
      setState(() {
        nicknameErrorMessage = '닉네임을 입력해주세요';
        birthDateErrorMexssage = '';
        _nicknameborderColor = Color(0xFFFF3333);
      });
      print('오류: 닉네임을 입력해주세요.');
      return;
    }

    if (birthDate.trim().isEmpty) {
      setState(() {
        nicknameErrorMessage = '';
        birthDateErrorMexssage = '생일을 입력해주세요';
        _nicknameborderColor = Color(0xFFFF3333);
      });
      print('오류: 생일을 입력해주세요');
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
          'createdAt': FieldValue.serverTimestamp(), // 가입 날짜 저장
        }, SetOptions(merge: true));

        print('사용자 정보가 성공적으로 업데이트되었습니다.');

        // Firestore에서 가입 날짜를 가져와서 출력
        DocumentSnapshot userSnapshot = await userDoc.get();
        if (userSnapshot.exists) {
          Timestamp createdAtTimestamp = userSnapshot['createdAt'];
          DateTime createdAt = createdAtTimestamp.toDate();
          print('가입 날짜: ${createdAt.toLocal()}');
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

  final FocusNode _focusNode = FocusNode();
  Color _nicknameborderColor = Color(0xFFD1D1D1); // 기본 테두리 색상

  final FocusNode _passwordFocusNode = FocusNode();
  Color _birthDateBorderColor = Color(0xFFD1D1D1); // 기본 테두리 색상

  final FocusNode _rePasswordFocusNode = FocusNode();
  Color _rePasswordBorderColor = Color(0xFFD1D1D1); // 기본 테두리 색상

  final List<bool> _selectedGender = <bool>[false, false];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onPasswordFocusChange);
    _rePasswordFocusNode.addListener(
        _onRePasswordFocusChange); // 비밀번호 재입력 필드의 FocusNode 상태 변화 감지
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _passwordFocusNode.removeListener(_onPasswordFocusChange);
    _passwordFocusNode.dispose();
    _rePasswordFocusNode.removeListener(_onRePasswordFocusChange); // 메서드 제거
    _rePasswordFocusNode.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _nicknameborderColor =
          _focusNode.hasFocus ? Color(0xFF4B0FFF) : Color(0xFFD1D1D1);
    });
  }

  void _onPasswordFocusChange() {
    setState(() {
      _birthDateBorderColor =
          _passwordFocusNode.hasFocus ? Color(0xFF4B0FFF) : Color(0xFFD1D1D1);
    });
  }

  void _onRePasswordFocusChange() {
    setState(() {
      _rePasswordBorderColor =
          _rePasswordFocusNode.hasFocus ? Color(0xFF4B0FFF) : Color(0xFFD1D1D1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // 앱 바 - 완
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      width: 1,
                      color: Color(0xFFE7E7E7),
                    )),
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 12, left: 12),
                      child: Row(
                        children: [
                          Container(
                            // 뒤로가기 버튼 - 완
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/image/back_icon.png'))),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      )),
                ),
                Center(
                  child: Container(
                    // 중간 패널
                    width: 428,
                    height: 592,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '계정을 생성해 볼까요?',
                            style: TextStyle(
                              color: Color(0xFF3D3D3D),
                              fontSize: 24,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              letterSpacing: -0.60,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '가입회원이 되면 원하는 커뮤니티 정보를 알 수 있어요.',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                              letterSpacing: -0.35,
                            ),
                          ),
                          SizedBox(height: 48),
                          Container(
                            height: 82,
                            width: 428,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Row(
                                    children: const [
                                      Text(
                                        '닉네임',
                                        style: TextStyle(
                                          color: Color(0xFF3D3D3D),
                                          fontSize: 14,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 1.0,
                                          letterSpacing: -0.35,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '*',
                                        style: TextStyle(
                                          color: Color(0xFFFF3333),
                                          fontSize: 14,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 1.0,
                                          letterSpacing: -0.35,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Column(
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 428,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 1,
                                              color: _nicknameborderColor),
                                          // 포커스 상태에 따른 테두리 색상 변경
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: nicknameController,
                                        focusNode: _focusNode,
                                        // 포커스 노드 사용
                                        style: TextStyle(
                                          color: Color(0xFF3D3D3D),
                                          fontSize: 16,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          height: 1.0,
                                          letterSpacing: -0.40,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(bottom: 10),
                                            hintText: '닉네임 입력',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF888888),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              height: 1.0,
                                              letterSpacing: -0.40,
                                            ),
                                            suffixIcon: nicknameController
                                                    .text.isNotEmpty
                                                ? IconButton(
                                                    onPressed: () {
                                                      nicknameController
                                                          .clear();
                                                      setState(() {});
                                                    },
                                                    padding: EdgeInsets.only(
                                                        bottom: 10, left: 60),
                                                    icon: Icon(Icons.cancel,
                                                        color: Color(
                                                            0xFF888888)))
                                                : null),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 4),
                                Container(
                                  height: 12,
                                  width: 428,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    nicknameErrorMessage,
                                    // 이전에 정의한 errorMessage 변수 사용
                                    style: TextStyle(
                                      color: Color(0xFFFF3333),
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                      letterSpacing: -0.30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            height: 82,
                            width: 428,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Row(
                                    children: const [
                                      Text(
                                        '생년월일',
                                        style: TextStyle(
                                          color: Color(0xFF3D3D3D),
                                          fontSize: 14,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 1.0,
                                          letterSpacing: -0.35,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '*',
                                        style: TextStyle(
                                          color: Color(0xFFFF3333),
                                          fontSize: 14,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 1.0,
                                          letterSpacing: -0.35,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Column(
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 428,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1,
                                            color: _birthDateBorderColor),
                                        // 포커스 상태에 따른 테두리 색상 변경
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      )),
                                      child: TextFormField(
                                        controller: birthDateController,
                                        focusNode: _passwordFocusNode,
                                        // 포커스 노드 사용
                                        style: TextStyle(
                                          color: Color(0xFF3D3D3D),
                                          fontSize: 16,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          height: 1.0,
                                          letterSpacing: -0.40,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(bottom: 10),
                                            hintText: '생년월일 입력',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF888888),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              height: 1.0,
                                              letterSpacing: -0.40,
                                            ),
                                            suffixIcon: birthDateController
                                                    .text.isNotEmpty
                                                ? IconButton(
                                                    onPressed: () {
                                                      birthDateController
                                                          .clear();
                                                      setState(() {});
                                                    },
                                                    padding: EdgeInsets.only(
                                                        bottom: 10, left: 60),
                                                    icon: Icon(Icons.cancel,
                                                        color: Color(
                                                            0xFF888888)))
                                                : null),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Container(
                                  height: 12,
                                  width: 428,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    birthDateErrorMexssage,
                                    style: TextStyle(
                                      color: Color(0xFFF72828),
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                      letterSpacing: -0.30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            height: 82,
                            width: 428,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Row(
                                    children: const [
                                      Text(
                                        '성별',
                                        style: TextStyle(
                                          color: Color(0xFF3D3D3D),
                                          fontSize: 14,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 1.0,
                                          letterSpacing: -0.35,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '*',
                                        style: TextStyle(
                                          color: Color(0xFFFF3333),
                                          fontSize: 14,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 1.0,
                                          letterSpacing: -0.35,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    width: 428,
                                    child: ToggleButtons(
                                      onPressed: (int index) {
                                        setState(() {
                                          for (int i = 0;
                                              i < _selectedGender.length;
                                              i++) {
                                            _selectedGender[i] = i == index;
                                          }
                                        });
                                      },
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                        height: 1.0,
                                        letterSpacing: -0.40,
                                      ),
                                      borderColor: Color(0xFFD1D1D1),
                                      color: Color(0xFF888888),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      selectedBorderColor: Color(0xFF4B0FFF),
                                      selectedColor: Color(0xFF4B0FFF),
                                      isSelected: _selectedGender,
                                      children: gender,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  height: 12,
                                  width: 426,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    '성별을 선택해 주세요',
                                    style: TextStyle(
                                      color: Color(0xFFB0B0B0),
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                      letterSpacing: -0.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    // 다음 버튼 - 버튼 기능 추가
                    padding: EdgeInsets.only(left: 24, right: 24, bottom: 48),
                    child: SizedBox(
                      height: 48,
                      width: 428,
                      child: MaterialButton(
                        onPressed: () {
                          next();
                        },
                        color: Color(0xFF4B0FFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          '다음',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: -0.50,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
