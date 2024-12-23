import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 인증메일 받기
void main() {
  runApp(MaterialApp(
    home: NewPassword(),
  ));
}

class NewPassword extends StatefulWidget {
  @override
  _NewPassword createState() => _NewPassword();
}

class _NewPassword extends State<NewPassword> {
  final TextEditingController emailController = TextEditingController();
  String emailErrorMessage = ''; // 클래스 멤버 변수 이름 변경

  final FocusNode _focusNode = FocusNode();
  Color _emailborderColor = Color(0xFFD1D1D1); // 기본 테두리 색상

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _emailborderColor =
          _focusNode.hasFocus ? Color(0xFF4B0FFF) : Color(0xFFD1D1D1);
    });
  }

  Future<void> sendPasswordResetEmail() async {
    try {
      if (emailController.text.trim().isEmpty) {
        setState(() {
          _emailborderColor = Color(0xFFFF3333);
          emailErrorMessage = '이메일을 입력해주세요.';
          print('오류: 이메일을 입력해주세요.');
        });
        return;
      }

      String email = emailController.text.trim();

      // Firestore에서 이메일 존재 여부 확인
      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        setState(() {
          emailErrorMessage = '해당 이메일로 등록된 계정이 없습니다.';
          _emailborderColor = Color(0xFFFF3333);
          print('해당 이메일로 등록된 계정이 없습니다.');
        });
        return;
      }

      // 비밀번호 재설정 이메일 전송
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('비밀번호 재설정 이메일이 전송되었습니다.');

      // 팝업창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              width: 280,
              height: 150,
              padding: const EdgeInsets.only(top: 32),
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          '이메일 전송',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF3D3D3D),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          '입력하신 이메일로 인증번호를 전송했습니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF3D3D3D),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            letterSpacing: -0.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: Color(0xFFE7E7E7),
                            ),
                          )),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.zero,
                        ),
                        child: Text('확인',
                            style: TextStyle(color: Color(0xFF4B0FFF))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'unknown') {
          if ((e.message ?? '').contains(
              'An unknown error occurred: FirebaseError: Firebase: The email address is badly formatted. (auth/invalid-email).')) {
            emailErrorMessage = '이메일 형식이 알맞지 않습니다.';
            _emailborderColor = Color(0xFFFF3333);
            print('이메일 형식이 알맞지 않습니다.');
          } else if ((e.message ?? '').contains(
              'An unknown error occurred: FirebaseError: Firebase: Error (auth/missing-email).')) {
            emailErrorMessage = '이메일을 입력해주세요.';
            _emailborderColor = Color(0xFFFF3333);
            print('이메일을 입력해주세요.');
          }
        }
      });
      print('오류 코드: ${e.code}');
      print('오류 메시지: ${e.message}');
    } catch (e) {
      print('비밀번호 재설정 이메일 전송 실패: $e');
    }
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
                      padding: EdgeInsets.only(left: 24, right: 24, top: 57),
                      child: Container(
                        height: 95,
                        width: 428,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '비밀번호 찾기',
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
                              '로그인에 사용하려는 이메일을 입력해 주세요.\n'
                              '작성하신 이메일 주소로 비밀번호 재설정을 위한\n'
                              '인증 메일이 발송됩니다.',
                              textAlign: TextAlign.center,
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
                                          '이메일',
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
                                                color: _emailborderColor),
                                            // 포커스 상태에 따른 테두리 색상 변경
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: emailController,
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
                                              hintText: '이메일 입력',
                                              hintStyle: TextStyle(
                                                color: Color(0xFF888888),
                                                fontSize: 16,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                                height: 1.0,
                                                letterSpacing: -0.40,
                                              ),
                                              suffixIcon: emailController
                                                      .text.isNotEmpty
                                                  ? IconButton(
                                                      onPressed: () {
                                                        emailController.clear();
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
                                  if (emailErrorMessage.isNotEmpty)
                                    Container(
                                      height: 12,
                                      width: 428,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(
                                        emailErrorMessage,
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
                          ],
                        ),
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
                          sendPasswordResetEmail();
                        },
                        color: Color(0xFF4B0FFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          '인증 메일 받기',
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
