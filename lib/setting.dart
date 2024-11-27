import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Login.dart';

void main() {
  runApp(MaterialApp(
    home: Setting(), // Setting 위젯을 홈으로 설정
  ));
}


class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyProfileAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 360,
            color:Colors.white,
            child: Column(
              children: [
                memberInfoEditWidget('알림 설정'),
                memberInfoEditWidget2('이벤트 혜택 알림', () {}),
                SizedBox(height: 8),
                memberInfoEditWidget('서비스 동의'),
                memberInfoEditWidget2('약관 동의 및 개인정보 처리 동의', () {}),
                memberInfoEditWidget2('개인정보 처리 방침', () {}),
                memberInfoEditWidget2('오픈 소스 라이브러리', () {}),
                memberInfoEditWidget3('어플 버전', () {}),
                SizedBox(height: 230),

                logoutAndWithdrawalWidget(context, () {
                  // 회원탈퇴 기능을 추가하세요.
                }),


              ],
            ),
          ),
        ),
      ),
    );
  }


}


//로그아웃,회원탈퇴
Widget logoutAndWithdrawalWidget(BuildContext context, VoidCallback onWithdrawalTap) {
  return Container(
    width: 360,
    height: 98,
    padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 48),
    child: Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              // Firebase Auth 로그아웃
              await FirebaseAuth.instance.signOut();

              // 로그인 화면으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()), // Login 화면으로 이동
              );
            },
            child: Text(
              '로그아웃',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: -0.30,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Text(
          '|',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: -0.30,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: onWithdrawalTap,
            child: Text(
              '회원탈퇴',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: -0.30,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


// 설정 타이틀
Widget memberInfoEditWidget(String text) {
  return Container(
    width: 360,
    height: 57,
    padding: EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
    decoration: BoxDecoration(
      color: Colors.white, // 배경색 추가
      border: Border(
        bottom: BorderSide(width: 1, color: Color(0xFFE7E7E7)), // 아래쪽 테두리 설정
      ),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: -0.40,
      ),
    ),
  );
}

// 설정 부 타이틀
Widget memberInfoEditWidget2(String text, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 360,
      height: 56,
      padding: EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white, // 배경색 추가
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFE7E7E7), // 아래쪽 테두리 설정
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              height: 1.0,
              letterSpacing: -0.35,
            ),
          ),
          SizedBox(width: 8), // 텍스트와 아이콘 사이의 간격
          Icon(
            Icons.arrow_forward,
            size: 16, // 아이콘 크기
            color: Colors.black, // 아이콘 색상
          ),
        ],
      ),
    ),
  );
}

// 설정 어플 버전
Widget memberInfoEditWidget3(String text, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 360,
      height: 56,
      padding: EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white, // 배경색 추가
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFE7E7E7), // 아래쪽 테두리 설정
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              height: 1.0,
              letterSpacing: -0.35,
            ),
          ),
          SizedBox(width: 8), // 텍스트와 버전 텍스트 사이의 간격
          Text(
            'v.0.0.0',
            style: TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              height: 1.0,
              letterSpacing: -0.35,
            ),
          ),
        ],
      ),
    ),
  );
}


class MyProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyProfileAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // preferredSize 구현

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(left: 16),
          width: 360,
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context); // 뒤로가기
                },
                icon: Icon(Icons.arrow_back),
                iconSize: 24,
                color: Colors.black,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '설정',
                    style: TextStyle(
                      color: Color(0xFF3D3D3D),
                      fontSize: 18,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      letterSpacing: -0.45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

