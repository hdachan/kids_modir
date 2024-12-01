import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:holyhabits_modirapp/BabyMypage_edit.dart';
import 'package:holyhabits_modirapp/Login.dart';
import 'package:intl/intl.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'DesignerCollection.dart';
import 'MyStyleInfo.dart';
import 'Mypage_edit.dart';
import 'heeeee.dart';
import 'qqqqqqqq2.dart';
import 'qqqqqqqqqq3.dart';
import 'qqqqqqqqqqqqq.dart';
import 'setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDogzalL_f-tEOiqOrBSfN8Amzc64l_nLw',
      appId: '1:531305378076:android:31a98cc7b8d92f337b4ad9',
      messagingSenderId: '531305378076',
      projectId: 'modir-d8182',
      storageBucket: 'modir-d8182.appspot.com',
    ),
  );
  runApp(MaterialApp(
    home: Home_Screen(),
  ));
}

/* 전체 화면 관리 */
/////////////////////////////////////////////////////////////////////
// 전체화면 상태관리
class Home_Screen extends StatefulWidget {
  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}

//전체 화면 (하단바 이동)
class _Home_ScreenState extends State<Home_Screen> {
  int _currentIndex = 0; // 현재 선택된 인덱스
  final List<Widget> _pages = [
    _HomePage(),
    CoreFunctionalityScreen(),
    CommunityScreen(),
    QuotationPage(),
    MyPageScreen(),
  ]; // 각 페이지 위젯들

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // 현재 선택된 페이지를 표시
      bottomNavigationBar: Container(
        height: 68, // 높이를 68로 설정
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          // 라벨 항상 표시
          currentIndex: _currentIndex,
          // 현재 선택된 인덱스
          onTap: (index) {
            setState(() {
              _currentIndex = index; // 인덱스 변경 시 상태 갱신
            });
          },
          // 선택된 아이템 색상
          selectedItemColor: Color(0xFF0095F6),
          // 선택되지 않은 아이템 색상
          unselectedItemColor: Color(0xFF3D3D3D),

          items: [
            BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(Icons.home)
                  : Icon(Icons.home_outlined), // 홈 아이콘 변경
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(Icons.lightbulb) // 선택된 상태에서 전구 아이콘
                  : Icon(Icons.lightbulb_outline), // 선택되지 않은 상태에서 전구 아이콘
              label: '놀이정보',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(Icons.article) // 선택된 상태에서 즐겨찾기 아이콘
                  : Icon(Icons.article), // 선택되지 않은 상태에서 즐겨찾기 아이콘
              label: '매거진',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Icon(Icons.shopping_cart) // 선택된 상태에서 쇼핑 카트 아이콘
                  : Icon(Icons.shopping_cart_outlined),
              // 선택되지 않은 상태에서 쇼핑 카트 아이콘
              label: '쇼핑',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 4
                  ? Icon(Icons.person)
                  : Icon(Icons.person_outline), // 마이페이지 아이콘 변경
              label: '마이',
            ),
          ],
        ),
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////////

/* 홈 화면 관리 */
/////////////////////////////////////////////////////////////////////
// 홈 화면 상태 관리
class _HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// 홈 화면
class _HomePageState extends State<_HomePage> {
  int _selectedIndex = 0;
  int _selectedIndex2 = 0;

  final PageController _controller = PageController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      int nextPage = (_controller.page!.toInt() + 1) % 3; // 페이지 수가 3인 경우
      _controller.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('현재 상품 기능은 준비 중입니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 360,
                  child: Column(
                    children: [
                      Container(
                        height: 420,
                        width: 360,
                        child: PageView(
                          controller: _controller,
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/image/carousel_home.png', // 첫 번째 이미지
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              child: Image.asset(
                                'assets/image/carousel_home2.png', // 두 번째 이미지
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              child: Image.asset(
                                'assets/image/carousel_home3.png', // 두 번째 이미지
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      announcement('쿠폰 받으러 가기'),

                      Container(
                        height: 240,
                        width: 360,
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            top: 16, bottom: 24, left: 16, right: 16),
                        child: Column(
                          children: [
                            Container(
                              height: 94,
                              width: 328,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  IconCard(
                                    imagePath: 'assets/image/card img.png',
                                    text: '패션용품',
                                    onPressed: () => _showPopup(context), // context를 전달
                                  ),
                                  SizedBox(width: 16),
                                  IconCard(
                                    imagePath: 'assets/image/card img (1).png',
                                    text: '육아용품',
                                    onPressed: () => _showPopup(context),
                                  ),
                                  SizedBox(width: 16),
                                  IconCard(
                                    imagePath: 'assets/image/card img (2).png',
                                    text: '장난감',
                                    onPressed: () => _showPopup(context),
                                  ),
                                  SizedBox(width: 16), // 사이즈 박스 추가
                                  IconCard(
                                    imagePath: 'assets/image/card img (3).png',
                                    text: '학용품',
                                    onPressed: () => _showPopup(context),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 12), // 사이즈 박스 추가
                            Container(
                              height: 94,
                              width: 328,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  IconCard(
                                    imagePath: 'assets/image/card img (4).png',
                                    // 이미지 경로
                                    text: '스킨케어',
                                    // 텍스트 내용
                                    onPressed: () => _showPopup(context),
                                  ),
                                  SizedBox(width: 16), // 사이즈 박스 추가
                                  IconCard(
                                    imagePath: 'assets/image/card img (5).png',
                                    // 이미지 경로
                                    text: '기획전',
                                    // 텍스트 내용
                                    onPressed: () => _showPopup(context),
                                  ),
                                  SizedBox(width: 16), // 사이즈 박스 추가
                                  IconCard(
                                    imagePath: 'assets/image/card img (6).png',
                                    // 이미지 경로
                                    text: '이벤트',
                                    // 텍스트 내용
                                    onPressed: () => _showPopup(context),
                                  ),
                                  SizedBox(width: 16), // 사이즈 박스 추가
                                  IconCard(
                                    imagePath: 'assets/image/card img (7).png',
                                    // 이미지 경로
                                    text: '쿠폰',
                                    // 텍스트 내용
                                    onPressed: () => _showPopup(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //                   onPressed: () {
                      //                     // HomeScreen의 인덱스를 업데이트
                      //                     final homeScreenState =
                      //                         context.findAncestorStateOfType<
                      //                             _Home_ScreenState>();
                      //                     if (homeScreenState != null) {
                      //                       homeScreenState
                      //                           .updateIndex(1); // 기능 화면으로 이동
                      //                     }
                      //                   },
                      SizedBox(height: 8),

                      // 모디랑 피드글씨
                      createFeedWidget(
                        '모디랑 놀이',
                        '다양한 놀이 방법을 통해 아이와 즐거운 추억을 만드세요',
                      ),
                      // 모디랑 피드 그림
                      Container(
                        width: 360,
                        decoration: BoxDecoration(
                          color: Colors.white, // 박스의 배경색 (원하는 색상으로 변경 가능)
                        ),
                        padding: EdgeInsets.only(
                            top: 12, bottom: 24, right: 16, left: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // 수평 스크롤 방향 설정
                          child: Row(
                            children: [
                              // 1번째 위젯
                              Container(
                                width: 240,
                                height: 430,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 240,
                                      height: 44,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              // 원하는 색상으로 변경 가능
                                              shape:
                                                  BoxShape.circle, // 동그란 형태로 설정
                                            ),
                                            child: ClipOval(
                                              child: Image.asset(
                                                'assets/image/titie img.png',
                                                // 이미지 경로
                                                fit: BoxFit.cover, // 이미지 비율 유지
                                                width: 36,
                                                height: 36,
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 8), // 사이즈 박스 8 추가
                                          Container(
                                            width: 180,
                                            height: 36,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 180,
                                                  height: 18,
                                                  child: Text(
                                                    '무호흡 이유식 딜링',
                                                    style: TextStyle(
                                                      color: Color(0xFF3D3D3D),
                                                      fontSize: 14,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                // 사이즈 박스 4 추가
                                                Container(
                                                  width: 180,
                                                  height: 14,
                                                  child: Text(
                                                    '클린바이브하우스',
                                                    style: TextStyle(
                                                      color: Color(0xFF3D3D3D),
                                                      fontSize: 12,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 240,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/content.png'),
                                          // 이미지 경로
                                          fit: BoxFit.cover, // 이미지 꽉 차게
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 240,
                                      height: 86,
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 8,
                                          right: 4,
                                          left: 4),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 232,
                                            height: 18,
                                            child: Text(
                                              '우리집이 워터파크 ?',
                                              style: TextStyle(
                                                color: Color(0xFF3D3D3D),
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 12), // 사이즈 박스
                                          Container(
                                            width: 232,
                                            height: 36,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 200,
                                                  height: 36,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start, // 위쪽 정렬
                                                    children: [
                                                      Container(
                                                        width: 200,
                                                        height: 14,
                                                        child: Text(
                                                          '추천 나이 : 3세 이상',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF5D5D5D),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.2,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      // 사이즈 박스
                                                      Container(
                                                        width: 200,
                                                        height: 14,
                                                        child: Text(
                                                          '종류 : 물놀이',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF5D5D5D),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(width: 8),
                                                // 사이즈 박스 (가로 간격)
                                                Container(
                                                  width: 24,
                                                  height: 36,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.favorite, // 하트 아이콘
                                                      size: 24, // 아이콘 크기
                                                      color:
                                                          Colors.red, // 아이콘 색상
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 15),
                              // 2번째 위젯
                              Container(
                                width: 240,
                                height: 430,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 240,
                                      height: 44,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              // 원하는 색상으로 변경 가능
                                              shape:
                                                  BoxShape.circle, // 동그란 형태로 설정
                                            ),
                                            child: ClipOval(
                                              child: Image.asset(
                                                'assets/image/titie img.png',
                                                // 이미지 경로
                                                fit: BoxFit.cover, // 이미지 비율 유지
                                                width: 36,
                                                height: 36,
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 8), // 사이즈 박스 8 추가
                                          Container(
                                            width: 180,
                                            height: 36,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 180,
                                                  height: 18,
                                                  child: Text(
                                                    '무호흡 이유식 딜링',
                                                    style: TextStyle(
                                                      color: Color(0xFF3D3D3D),
                                                      fontSize: 14,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                // 사이즈 박스 4 추가
                                                Container(
                                                  width: 180,
                                                  height: 14,
                                                  child: Text(
                                                    '클린바이브하우스',
                                                    style: TextStyle(
                                                      color: Color(0xFF3D3D3D),
                                                      fontSize: 12,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 240,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/content.png'),
                                          // 이미지 경로
                                          fit: BoxFit.cover, // 이미지 꽉 차게
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 240,
                                      height: 86,
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 8,
                                          right: 4,
                                          left: 4),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 232,
                                            height: 18,
                                            child: Text(
                                              '우리집이 워터파크 ?',
                                              style: TextStyle(
                                                color: Color(0xFF3D3D3D),
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 12), // 사이즈 박스
                                          Container(
                                            width: 232,
                                            height: 36,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 200,
                                                  height: 36,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start, // 위쪽 정렬
                                                    children: [
                                                      Container(
                                                        width: 200,
                                                        height: 14,
                                                        child: Text(
                                                          '추천 나이 : 3세 이상',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF5D5D5D),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.2,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      // 사이즈 박스
                                                      Container(
                                                        width: 200,
                                                        height: 14,
                                                        child: Text(
                                                          '종류 : 물놀이',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF5D5D5D),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(width: 8),
                                                // 사이즈 박스 (가로 간격)
                                                Container(
                                                  width: 24,
                                                  height: 36,
                                                  color:
                                                      Colors.grey, // 두 번째 박스 색상
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 모디랑 육아팁
                      createFeedWidget(
                        '모디랑 매거진',
                        '육아에 대한 최신 트렌드 자료를 모았어요',
                      ),
                      // 모디랑 육아팁 그림
                      Container(
                        height: 336,
                        decoration: BoxDecoration(color: Colors.white),
                        padding: EdgeInsets.only(
                            top: 12, bottom: 24, right: 16, left: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // 수평 스크롤 방향 설정
                          child: Row(
                            children: [
                              // 1컨텐츠
                              Container(
                                width: 240, // 너비 240
                                height: 300, // 높이 300
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/image/content.png'), // 이미지 경로
                                    fit: BoxFit.cover, // 이미지의 크기를 컨테이너에 맞춤
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  // 맨 바닥에 위치
                                  children: [
                                    Container(
                                      width: 240,
                                      // 너비 240
                                      height: 140,
                                      // 높이 140
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(0.00, -1.00),
                                          end: Alignment(0, 1),
                                          colors: [
                                            Colors.white.withOpacity(0),
                                            Colors.white.withOpacity(
                                                0.6000000238418579),
                                            Colors.white
                                          ],
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                          top: 48,
                                          bottom: 12,
                                          left: 16,
                                          right: 8),
                                      // 패딩값 설정
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 216, // 너비 216
                                            height: 24, // 높이 24
                                            child: Text(
                                              '김나영의 자랑스런 두아들, 신우 · 이준',
                                              style: TextStyle(
                                                color: Color(0xFF3D3D3D),
                                                fontSize: 20,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                                height: 1.2,
                                              ),
                                              overflow: TextOverflow
                                                  .ellipsis, // 텍스트가 넘칠 경우 ...으로 표시
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            width: 216,
                                            height: 48,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 168,
                                                  height: 48,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 168,
                                                        height: 20,
                                                        child: Text(
                                                          '아기가 평소 잠을 안자나요? 그럼 이렇게 해보세요',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF3D3D3D),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.4,
                                                            letterSpacing:
                                                                -0.35,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Container(
                                                        width: 168, // 너비 168
                                                        height: 20, // 높이 20
                                                        child: Text(
                                                          '2024. 11. 16',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF888888),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.7,
                                                            letterSpacing:
                                                                -0.30,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis, // 텍스트가 넘칠 경우 ...으로 표시
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 48,
                                                  height: 48,
                                                  padding: EdgeInsets.all(8),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.bookmark_border,
                                                      size: 32, // 아이콘 크기
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              // 2컨텐츠
                              Container(
                                width: 240, // 너비 240
                                height: 300, // 높이 300
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/image/content.png'), // 이미지 경로
                                    fit: BoxFit.cover, // 이미지의 크기를 컨테이너에 맞춤
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  // 맨 바닥에 위치
                                  children: [
                                    Container(
                                      width: 240,
                                      // 너비 240
                                      height: 140,
                                      // 높이 140
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(0.00, -1.00),
                                          end: Alignment(0, 1),
                                          colors: [
                                            Colors.white.withOpacity(0),
                                            Colors.white.withOpacity(
                                                0.6000000238418579),
                                            Colors.white
                                          ],
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                          top: 48,
                                          bottom: 12,
                                          left: 16,
                                          right: 8),
                                      // 패딩값 설정
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 216, // 너비 216
                                            height: 24, // 높이 24
                                            child: Text(
                                              '아이가 잠을 안자요',
                                              style: TextStyle(
                                                color: Color(0xFF3D3D3D),
                                                fontSize: 20,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                                height: 1.2,
                                              ),
                                              overflow: TextOverflow
                                                  .ellipsis, // 텍스트가 넘칠 경우 ...으로 표시
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            width: 216,
                                            height: 48,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 168,
                                                  height: 48,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 168,
                                                        height: 20,
                                                        child: Text(
                                                          '아기가 평소 잠을 안자나요? 그럼 이렇게 해보세요',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF3D3D3D),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.4,
                                                            letterSpacing:
                                                                -0.35,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Container(
                                                        width: 168, // 너비 168
                                                        height: 20, // 높이 20
                                                        child: Text(
                                                          '2024. 11. 16',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF888888),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.7,
                                                            letterSpacing:
                                                                -0.30,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis, // 텍스트가 넘칠 경우 ...으로 표시
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 48,
                                                  height: 48,
                                                  padding: EdgeInsets.all(8),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.bookmark_border,
                                                      size: 32, // 아이콘 크기
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 모디랑 상품 글씨
                      Container(
                        height: 88,
                        padding: EdgeInsets.only(
                            top: 24, bottom: 11, right: 8, left: 16),
                        decoration: BoxDecoration(
                          color: Colors.white, // 원하는 색상으로 변경
                          border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color(0xFFE7E7E7)), // 아래쪽 테두리 추가
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 300,
                              height: 52,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // 중앙 정렬
                                children: [
                                  Container(
                                    width: 300,
                                    height: 24,
                                    child: Text(
                                      '모디랑 상품',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width: 300,
                                    height: 20,
                                    child: Text(
                                      '우리 아이에게 딱 맞는 상품들로 준비했어요!!',
                                      style: TextStyle(
                                        color: Color(0xFF888888),
                                        fontSize: 14,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // 텍스트가 넘칠 경우 생략 기호 표시
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              width: 32,
                              height: 52,
                              child: Center(
                                // 아이콘을 중앙에 배치
                                child: Icon(
                                  Icons.chevron_right, // '>' 아이콘
                                  size: 20, // 아이콘 크기
                                  color:
                                      Colors.black, // 아이콘 색상 (원하는 색상으로 변경 가능)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 모디랑 상품 -버튼
                      Container(
                        height: 46,
                        width: 360,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        decoration: BoxDecoration(color: Colors.white),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildButton2(0, '3~5살'),
                              SizedBox(width: 8),
                              _buildButton2(1, '5~7살'),
                              SizedBox(width: 8),
                              _buildButton2(2, '7~9살'),
                              SizedBox(width: 8),
                              _buildButton2(3, '9~11살'),
                              SizedBox(width: 8),
                              _buildButton2(4, '11~12살'),
                            ],
                          ),
                        ),
                      ),
                      // 모디랑 상품 사진
                      Container(
                        width: 360,
                        height: 256,
                        padding: EdgeInsets.only(
                            top: 12, bottom: 24, right: 16, left: 16),
                        decoration: BoxDecoration(color: Colors.white),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              //1번컨텐츠
                              Container(
                                height: 220,
                                width: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // 위에서부터 쌓기
                                  children: [
                                    Container(
                                      height: 140,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/content.png'),
                                          // 이미지 경로
                                          fit: BoxFit
                                              .cover, // 이미지가 컨테이너 크기에 맞추도록 조정
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            4), // 모서리를 4픽셀로 둥글게 설정
                                      ),
                                    ),

                                    SizedBox(height: 12), // 12픽셀 간격
                                    Container(
                                      height: 68,
                                      width: 140,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start, // 위에서부터 쌓기
                                        children: [
                                          Container(
                                            height: 17,
                                            width: 140,
                                            child: Text(
                                              'Hang Dea Chan',
                                              style: TextStyle(
                                                color: Color(0xFF3D3D3D),
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8), // 8픽셀 간격
                                          Container(
                                            height: 17,
                                            width: 140,
                                            child: Text(
                                              '9월 15일 생',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8), // 8픽셀 간격
                                          Container(
                                            height: 18,
                                            width: 140,
                                            // 원하는 색상으로 변경 가능
                                            child: Text(
                                              '25,000 원',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w600,
                                                height: 1.3,
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
                              SizedBox(width: 12),
                              //2번컨텐츠
                              Container(
                                height: 220,
                                width: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // 위에서부터 쌓기
                                  children: [
                                    Container(
                                      height: 140,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/content.png'),
                                          // 이미지 경로
                                          fit: BoxFit
                                              .cover, // 이미지가 컨테이너 크기에 맞추도록 조정
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            4), // 모서리를 4픽셀로 둥글게 설정
                                      ),
                                    ),

                                    SizedBox(height: 12), // 12픽셀 간격
                                    Container(
                                      height: 68,
                                      width: 140,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start, // 위에서부터 쌓기
                                        children: [
                                          Container(
                                            height: 17,
                                            width: 140,
                                            child: Text(
                                              'Hang Dea Chan',
                                              style: TextStyle(
                                                color: Color(0xFF3D3D3D),
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8), // 8픽셀 간격
                                          Container(
                                            height: 17,
                                            width: 140,
                                            child: Text(
                                              '9월 15일 생',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8), // 8픽셀 간격
                                          Container(
                                            height: 18,
                                            width: 140,
                                            // 원하는 색상으로 변경 가능
                                            child: Text(
                                              '25,000 원',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w600,
                                                height: 1.3,
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
                              SizedBox(width: 12),
                              //3번컨텐츠
                              Container(
                                height: 220,
                                width: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // 위에서부터 쌓기
                                  children: [
                                    Container(
                                      height: 140,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/content.png'),
                                          // 이미지 경로
                                          fit: BoxFit
                                              .cover, // 이미지가 컨테이너 크기에 맞추도록 조정
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            4), // 모서리를 4픽셀로 둥글게 설정
                                      ),
                                    ),

                                    SizedBox(height: 12), // 12픽셀 간격
                                    Container(
                                      height: 68,
                                      width: 140,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start, // 위에서부터 쌓기
                                        children: [
                                          Container(
                                            height: 17,
                                            width: 140,
                                            child: Text(
                                              'Hang Dea Chan',
                                              style: TextStyle(
                                                color: Color(0xFF3D3D3D),
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8), // 8픽셀 간격
                                          Container(
                                            height: 17,
                                            width: 140,
                                            child: Text(
                                              '9월 15일 생',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8), // 8픽셀 간격
                                          Container(
                                            height: 18,
                                            width: 140,
                                            // 원하는 색상으로 변경 가능
                                            child: Text(
                                              '25,000 원',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w600,
                                                height: 1.3,
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
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),

                      //하단 (주) 모디랑 법적 고지사항
                      CompanyInfo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton2(int index2, String text) {
    // 계절 별 코디 카테고리
    bool isSelected = _selectedIndex2 == index2;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex2 = index2;
        });
        print('$text 버튼 클릭됨!');
      },
      highlightColor: Colors.transparent,
      child: Container(
        height: 32,
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF0095F6) : Colors.transparent,
          border: isSelected
              ? null
              : Border.all(width: 1, color: Color(0xFFE7E7E7)),
          borderRadius: BorderRadius.circular(4), // 모서리를 4로 둥글게 설정
        ),
        child: SizedBox(
          height: 14,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: -0.35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 홈 화면 공지사항
Widget announcement(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    height: 42,
    width: 360,
    decoration: BoxDecoration(color: Colors.black),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 1.3,
          letterSpacing: -0.35,
        ),
      ),
    ),
  );
} // 공지사항 (ex: 쿠폰 받으러가기)

// 홈 화면 카드 아이콘
Widget IconCard({
  required String imagePath, // 이미지 경로
  required String text, // 텍스트 내용
  required VoidCallback onPressed, // 버튼 클릭 시 동작
}) {
  return TextButton(
    onPressed: onPressed, // 버튼 클릭 시 동작
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero, // 패딩 제거
      backgroundColor: Colors.transparent, // 배경색 투명
    ),
    child: Container(
      height: 94,
      width: 70,
      color: Colors.white, // 박스 색상
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // 모서리를 둥글게 만들기
              child: Image.asset(
                imagePath, // 이미지 경로
                fit: BoxFit.cover, // 이미지가 Container를 꽉 차게 조정
              ),
            ),
          ),
          SizedBox(height: 4), // 사이즈 박스 추가
          Container(
            height: 16,
            width: 70,
            color: Colors.white, // 텍스트 박스 색상
            child: Center(
              // 텍스트를 중앙에 배치
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF3D3D3D),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// 홈화면 각 콘텐트별 제목
Widget createFeedWidget(String title, String subtitle) {
  return Container(
    height: 88,
    padding: EdgeInsets.only(top: 24, bottom: 11, right: 8, left: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 1, color: Color(0xFFE7E7E7)),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 300,
          height: 52,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 24,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 300,
                height: 20,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4),
        Container(
          width: 32,
          height: 52,
          child: Center(
            child: Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}

/////////////////////////////////////////////////////////////////////

/* 기능 화면 관리 */
/////////////////////////////////////////////////////////////////////
// 기능화면 상태관리
class CoreFunctionalityScreen extends StatefulWidget {
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

// 기능화면
class _BookmarkScreenState extends State<CoreFunctionalityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // 탭의 개수 설정
  }

  @override
  void dispose() {
    _tabController.dispose(); // 리소스 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 360,
                  height: 94,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        width: 360,
                        height: 44,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          tabs: [
                            Tab(
                              child: Text(
                                '전체',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0095F6),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                  letterSpacing: -0.40,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                '야외활동',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0095F6),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                  letterSpacing: -0.40,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                '실내활동',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0095F6),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                  letterSpacing: -0.40,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                '장난감',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0095F6),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                  letterSpacing: -0.40,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                '시설/행사',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0095F6),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                  letterSpacing: -0.40,
                                ),
                              ),
                            ),
                          ],
                          indicatorColor: Color(0xFF0095F6),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorPadding: EdgeInsets.only(top: 12, bottom: 0),
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 8), // 탭 간의 간격을 넓히기 위해 수정된 부분
                        ),
                      ),
                      Divider(
                        color: Color(0xFFF6F6F6),
                        height: 2.0,
                        thickness: 2.0,
                      ),
                      Container(
                        width: 360,
                        height: 48,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 81,
                              height: 18,
                              child: Text(
                                '전체 놀이 1건',
                                style: TextStyle(
                                  color: Color(0xFF3D3D3D),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                  letterSpacing: -0.35,
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // TabBarView를 추가하여 탭에 따른 내용을 표시
              Container(
                height: 540, // 적절한 높이 설정
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TabContent(),
                    Center(child: Text('2')),
                    Center(child: Text('3')), // 실내활동 탭 내용
                    Center(child: Text('장난감 탭 내용')), // 장난감 탭 내용
                    Center(child: Text('시설/행사 탭 내용')), // 시설/행사 탭 내용
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////////

/* 커뮤/매거진 화면 관리 */
/////////////////////////////////////////////////////////////////////
// 커뮤/ 매거진 화면

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this); // 탭의 개수 설정
  }

  @override
  void dispose() {
    _tabController.dispose(); // 리소스 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 360,
                  height: 94,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        width: 360,
                        height: 44,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          tabs: [
                            Tab(
                              child: Text(
                                '전체',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0095F6),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                  letterSpacing: -0.40,
                                ),
                              ),
                            ),
                          ],
                          indicatorColor: Color(0xFF0095F6),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorPadding: EdgeInsets.only(top: 12, bottom: 0),
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 8), // 탭 간의 간격을 넓히기 위해 수정된 부분
                        ),
                      ),
                      Divider(
                        color: Color(0xFFF6F6F6),
                        height: 2.0,
                        thickness: 2.0,
                      ),
                      Container(
                        width: 360,
                        height: 48,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              width: 71,
                              height: 18,
                              child: Text(
                                '총 2건',
                                style: TextStyle(
                                  color: Color(0xFF3D3D3D),
                                  fontSize: 14,
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
              // TabBarView를 추가하여 탭에 따른 내용을 표시
              Container(
                height: 540, // 적절한 높이 설정
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TabContent111(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabContent111 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 360,
            height: 740,
            color: Colors.white,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage2()),
                    );
                  },
                  child: Container(
                    width: 328,
                    height: 180,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                      child: Image.asset(
                        'assets/image/joonbam111 img.png', // 이미지 경로
                        fit: BoxFit.cover, // 이미지를 Container에 맞게 조절
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage3()),
                    );
                  },
                  child: Container(
                    width: 328,
                    height: 180,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                      child: Image.asset(
                        'assets/image/joonbam222 img.png', // 이미지 경로
                        fit: BoxFit.cover, // 이미지를 Container에 맞게 조절
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////////

/* 예약화면 화면 관리 */
/////////////////////////////////////////////////////////////////////
// 예약화면 상태관리
class QuotationPage extends StatefulWidget {
  @override
  _QuotationPageState createState() => _QuotationPageState();
}

// 예약화면
class _QuotationPageState extends State<QuotationPage>
    with SingleTickerProviderStateMixin {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: HomeAppBar(),
        ),
      ),
    );
  }
}

// 예약화면 - 첫번째 탭 내용
class TabContent1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: buildDesignerAnalysisContainer(),
            ),
          ],
        ),
      ),
    );
  }
}

//  예약화면 - 두번째 탭 내용
class TabContent2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                // 여러 자식을 담기 위해 Column 사용
                children: [
                  buildDesignerAnalysisContainer2(),
                  buildDesignerAnalysisContainer(),
                  buildDesignerAnalysisContainer(),
                  buildDesignerAnalysisContainer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 예약화면 모듈 - 분석중
Widget buildDesignerAnalysisContainer() {
  return Container(
    // 중간 패널
    width: 360,
    height: 276,
    padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
    child: Column(
      children: [
        Container(
          width: 328,
          height: 22,
          child: Row(
            children: [
              Container(
                width: 260,
                height: 22,
                child: Text(
                  '2024. 08. 09',
                  style: TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    letterSpacing: -0.40, // 글자 사이 간격
                  ),
                ),
              ),
              Container(
                width: 68,
                height: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                  children: [
                    Text(
                      '상세내역',
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: -0.35, // 글자 사이 간격
                      ),
                    ),
                    SizedBox(width: 2), // 텍스트와 아이콘 사이에 2의 간격 추가
                    Icon(
                      Icons.arrow_forward, // 아이콘 설정
                      size: 18, // 아이콘 크기
                      color: Color(0xFF888888), // 아이콘 색상 (원하는 경우 조정 가능)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8), // 두 컨테이너 사이의 간격을 조정
        Container(
          width: 328,
          height: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), // 둥근 모서리 설정
            border: Border.all(
              color: Color(0xFFE7E7E7),
              width: 1, // 테두리 두께
            ),
          ),
          padding: EdgeInsets.only(top: 11, bottom: 11, left: 15, right: 15),
          child: Column(
            children: [
              Container(
                width: 296,
                height: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 요소 정렬
                  children: [
                    Container(
                      width: 41,
                      height: 22,
                      child: Text(
                        '분석중',
                        style: TextStyle(
                          color: Color(0xFF3D3D3D),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          letterSpacing: -0.40,
                        ),
                      ),
                    ),

                    SizedBox(width: 8), // 사이의 간격을 위한 SizedBox
                    Container(
                      width: 2,
                      height: 2,
                      color: Colors.green, // 사이즈 박스 2x2 색상
                    ),
                    SizedBox(width: 8), // 사이의 간격을 위한 SizedBox
                    Container(
                      width: 237,
                      height: 22,
                      child: Text(
                        'D-3',
                        style: TextStyle(
                          color: Color(0xFFEA186D),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          letterSpacing: -0.40,
                        ),
                        textAlign: TextAlign.left, // 기본 왼쪽 정렬
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: 296,
                height: 98,
                child: Row(
                  children: [
                    Container(
                      width: 98,
                      height: 98,
                      child: Image.asset(
                        'assets/image/1111.png',
                        fit: BoxFit.cover, // 이미지 크기 조정 방식 (필요에 따라 조정 가능)
                      ),
                    ),
                    SizedBox(width: 16), // 컨테이너 사이의 간격
                    Container(
                      width: 182,
                      height: 98,
                      child: Column(
                        children: [
                          Container(
                            width: 182,
                            height: 20,
                            child: Text(
                              '코디 맛있게 해드려요!',
                              style: TextStyle(
                                color: Color(0xFF3D3D3D),
                                // 텍스트 색상
                                fontSize: 14,
                                // 글자 크기
                                fontFamily: 'Pretendard',
                                // 폰트 패밀리
                                fontWeight: FontWeight.w600,
                                // 글자 두께
                                height: 1.4,
                                // 줄 높이
                                letterSpacing: -0.35, // 글자 사이 간격
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 182,
                            height: 17,
                            child: Text(
                              '인혜엄',
                              style: TextStyle(
                                color: Color(0xFF3D3D3D),
                                // 텍스트 색상
                                fontSize: 14,
                                // 글자 크기
                                fontFamily: 'Pretendard',
                                // 폰트 패밀리
                                fontWeight: FontWeight.w400,
                                // 글자 두께
                                height: 1.2,
                                // 줄 높이
                                letterSpacing: -0.35, // 글자 사이 간격
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 182,
                            height: 17,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // 요소 정렬
                              children: [
                                Container(
                                  width: 48,
                                  height: 17,
                                  child: Text(
                                    '아메카지',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      letterSpacing: -0.35,
                                    ),
                                    textAlign: TextAlign.left, // 기본 왼쪽 정렬
                                  ),
                                ),
                                SizedBox(width: 4), // 사이의 간격을 위한 SizedBox
                                Container(
                                  width: 2,
                                  height: 2,
                                  color: Colors.black, // 세 번째 내부 컨테이너 색상
                                ),
                                SizedBox(width: 4), // 사이의 간격을 위한 SizedBox
                                Container(
                                  width: 124,
                                  height: 17,
                                  child: Text(
                                    '아우터 외2',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      letterSpacing: -0.35,
                                    ),
                                    textAlign: TextAlign.left, // 기본 왼쪽 정렬
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 182,
                            height: 20,
                            child: Text(
                              '20,000원',
                              style: TextStyle(
                                color: Color(0xFF3D3D3D),
                                // 텍스트 색상
                                fontSize: 14,
                                // 글자 크기
                                fontFamily: 'Pretendard',
                                // 폰트 패밀리
                                fontWeight: FontWeight.w600,
                                // 글자 두께
                                height: 1.4,
                                // 줄 높이
                                letterSpacing: -0.35, // 글자 사이 간격
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: 296,
                height: 42,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4), // 둥근 모서리 설정
                  border: Border.all(
                    color: Color(0xFFE7E7E7), // 테두리 색상 설정
                    width: 1, // 테두리 두께
                  ),
                ),
                child: Center(
                  child: Text(
                    '분석취소',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3D3D3D),
                      // 텍스트 색상
                      fontSize: 14,
                      // 글자 크기
                      fontFamily: 'Pretendard',
                      // 폰트 패밀리
                      fontWeight: FontWeight.w500,
                      // 글자 두께
                      height: 1.4,
                      // 줄 높이
                      letterSpacing: -0.35, // 글자 사이 간격
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// 예약화면 모듈 - 수락대기화면
Widget buildDesignerAnalysisContainer2() {
  return Container(
    // 중간 패널
    width: 360,
    height: 276,
    padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
    child: Column(
      children: [
        Container(
          width: 328,
          height: 22,
          child: Row(
            children: [
              Container(
                width: 260,
                height: 22,
                child: Text(
                  '2024. 08. 09',
                  style: TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    letterSpacing: -0.40, // 글자 사이 간격
                  ),
                ),
              ),
              Container(
                width: 68,
                height: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                  children: [
                    Text(
                      '상세내역',
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: -0.35,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward, // 아이콘 설정
                      size: 18, // 아이콘 크기
                      color: Color(0xFF888888), // 아이콘 색상 (원하는 경우 조정 가능)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8), // 두 컨테이너 사이의 간격을 조정
        Container(
          width: 328,
          height: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), // 둥근 모서리 설정
            border: Border.all(
              color: Color(0xFFE7E7E7),
              width: 1, // 테두리 두께
            ),
          ),
          padding: EdgeInsets.only(top: 11, bottom: 11, left: 15, right: 15),
          child: Column(
            children: [
              Container(
                width: 296,
                height: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 요소 정렬
                  children: [
                    Container(
                      width: 55,
                      height: 22,
                      child: Text(
                        '수락대기',
                        style: TextStyle(
                          color: Color(0xFF3D3D3D),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          letterSpacing: -0.40,
                        ),
                      ),
                    ),

                    SizedBox(width: 8), // 사이의 간격을 위한 SizedBox
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: 296,
                height: 98,
                child: Row(
                  children: [
                    Container(
                      width: 98,
                      height: 98,
                      child: Image.asset(
                        'assets/image/1111.png',
                        fit: BoxFit.cover, // 이미지 크기 조정 방식 (필요에 따라 조정 가능)
                      ),
                    ),
                    SizedBox(width: 16), // 컨테이너 사이의 간격
                    Container(
                      width: 182,
                      height: 98,
                      child: Column(
                        children: [
                          Container(
                            width: 182,
                            height: 20,
                            child: Text(
                              '코디 맛있게 해드려요!',
                              style: TextStyle(
                                color: Color(0xFF3D3D3D),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                                letterSpacing: -0.35, // 글자 사이 간격
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 182,
                            height: 17,
                            child: Text(
                              '줏댔어',
                              style: TextStyle(
                                color: Color(0xFF3D3D3D),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: -0.35, // 글자 사이 간격
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 182,
                            height: 17,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // 요소 정렬
                              children: [
                                Container(
                                  width: 48,
                                  height: 17,
                                  child: Text(
                                    '아메카지',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      letterSpacing: -0.35,
                                    ),
                                    textAlign: TextAlign.left, // 기본 왼쪽 정렬
                                  ),
                                ),
                                SizedBox(width: 4), // 사이의 간격을 위한 SizedBox
                                Container(
                                  width: 2,
                                  height: 2,
                                  color: Colors.black, // 세 번째 내부 컨테이너 색상
                                ),
                                SizedBox(width: 4), // 사이의 간격을 위한 SizedBox
                                Container(
                                  width: 124,
                                  height: 17,
                                  child: Text(
                                    '아우터 외2',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      letterSpacing: -0.35,
                                    ),
                                    textAlign: TextAlign.left, // 기본 왼쪽 정렬
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 182,
                            height: 20,
                            child: Text(
                              '20,000원',
                              style: TextStyle(
                                color: Color(0xFF3D3D3D),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                                letterSpacing: -0.35, // 글자 사이 간격
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: 296,
                height: 42,
                child: Row(
                  children: [
                    Container(
                      width: 138,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4), // 둥근 모서리 설정
                        border: Border.all(
                          color: Color(0xFFE7E7E7), // 테두리 색상 설정
                          width: 1, // 테두리 두께
                        ),
                      ),
                      child: Center(
                        // 텍스트를 중앙에 배치하기 위해 Center 위젯 사용
                        child: Text(
                          '분석취소',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF3D3D3D),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            letterSpacing: -0.35,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // 사이의 간격을 위한 SizedBox
                    Container(
                      width: 138,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4), // 둥근 모서리 설정
                        border: Border.all(
                          color: Color(0xFFE7E7E7), // 테두리 색상 설정
                          width: 1, // 테두리 두께
                        ),
                      ),
                      child: Center(
                        // 텍스트를 중앙에 배치하기 위해 Center 위젯 사용
                        child: Text(
                          '분석취소',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF3D3D3D),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            letterSpacing: -0.35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
/////////////////////////////////////////////////////////////////////

/* 마이페이지 화면 관리 */
/////////////////////////////////////////////////////////////////////
// 마이페이지 상태관리
class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

// 마이페이지 화면 위젯
class _MyPageScreenState extends State<MyPageScreen>
    with SingleTickerProviderStateMixin {
  String _nickname = "로그인이 되어있지 않습니다";
  String _babyNickname = "";
  String _babyBirthDate = "";
  String _babygender = "";
  double _babyweight = 0.0;
  double _babyheight = 0.0;
  String _imgUrl = ''; // imgUPL을 저장할 변수 추가

  String _formattedDate = "아직 작성된 스타일 정보가 없어요";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 사용자 데이터 로드
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // 사용자 정보 로드
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>?; // Map으로 캐스팅
          setState(() {
            _nickname = (data?['nickname'] ?? "").isNotEmpty
                ? data!['nickname']
                : "로그인이 되어있지 않습니다";

            Timestamp? time = data?['time'];
            if (time != null) {
              _formattedDate =
                  '작성일: ${DateFormat('yyyy.MM.dd').format(time.toDate())}';
            }

            // imgUPL 가져오기
            _imgUrl = data?['imgUPL'] ?? ''; // imgUPL을 가져와서 저장
          });
        }

        // 아기 정보 불러오기
        QuerySnapshot babySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('baby')
            .get();

        if (babySnapshot.docs.isNotEmpty) {
          // 첫 번째 아기 문서의 데이터를 가져와서 설정
          var babyData = babySnapshot.docs.first.data() as Map<String, dynamic>;

          // 디버깅: babyData의 내용을 출력
          print("Baby Data: $babyData");

          String babyNickname = babyData['nickname'] ?? '아기 정보 없음';
          String babyBirthDate =
              babyData['BirthDate'] ?? '생일 정보 없음'; // BirthDate 추가
          String babygender = babyData['gender'] ?? ''; // 수정된 부분

          // 체중 및 키 정보 가져오기
          double babyWeight = (babyData['weight'] is num)
              ? (babyData['weight'] as num).toDouble()
              : (babyData['weight'] is String)
                  ? double.tryParse(babyData['weight']) ?? 0.0
                  : 0.0; // 체중 정보 추가
          double babyHeight = (babyData['height'] is num)
              ? (babyData['height'] as num).toDouble()
              : (babyData['height'] is String)
                  ? double.tryParse(babyData['height']) ?? 0.0
                  : 0.0; // 키 정보 추가

          // 디버깅: babyWeight와 babyHeight 값을 출력
          print("Weight: $babyWeight, Height: $babyHeight");

          setState(() {
            // 아기 닉네임과 생일 저장
            _babyNickname = babyNickname;
            _babyBirthDate = babyBirthDate;
            _babygender = babygender;
            _babyweight = babyWeight; // 체중 저장
            _babyheight = babyHeight; // 키 저장
          });
        } else {
          print('No baby info found for this user.');
        }
      } catch (e) {
        // 예외 처리
        print("Error loading user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar1(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 360,
            child: Column(
              children: [
                Container(
                  width: 360,
                  height: 108,
                  padding:
                      EdgeInsets.only(top: 24, bottom: 24, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white, // 원하는 색상으로 변경
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        child: ClipOval(
                          child: Image.network(
                            _imgUrl.isNotEmpty
                                ? _imgUrl
                                : 'assets/image/profile img.png', // 기본 이미지 경로
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ),

                      SizedBox(width: 12), // 사이 간격 설정
                      Container(
                        width: 256,
                        height: 52,
                        child: Column(
                          children: [
                            Container(
                              width: 256,
                              height: 24,
                              child: Text(
                                _nickname,
                                style: TextStyle(
                                  color: Color(0xFF3D3D3D),
                                  fontSize: 20,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),

                            SizedBox(height: 8), // 사이 간격 설정
                            InkWell(
                              onTap: () {
                                // 버튼 클릭 시 MyPageEdit으로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyPageEdit()),
                                );
                              },
                              child: Container(
                                width: 256,
                                height: 20,
                                child: Row(
                                  children: [
                                    UserInfoButton(),
                                    SizedBox(width: 2), // 두 사이즈 박스 사이의 간격
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Container(
                                        alignment: Alignment.center,
                                        // 아이콘을 중앙에 배치
                                        child: Icon(
                                          Icons.chevron_right, // 오른쪽 화살표 아이콘
                                          color: Colors.black,
                                          // 아이콘 색상 (필요에 따라 변경)
                                          size: 18, // 아이콘 크기 조정 (필요에 따라 변경)
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 50, // 인디케이터 높이 설정
                  child: TabBar(
                    controller: _tabController,

                    labelColor: Color(0xFF0095F6),
                    // 선택된 탭 색상
                    unselectedLabelColor: Color(0xFFB0B0B0),
                    // 선택되지 않은 탭 색상
                    tabs: [
                      Tab(
                        child: Container(
                          child: Center(
                            child: Text(
                              '프로필',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ), // 텍스트 중앙 정렬
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Center(
                            child: Text(
                              '쇼핑',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ), // 텍스트 중앙 정렬
                        ),
                      ),
                    ],
                    indicatorSize:
                        TabBarIndicatorSize.tab, // 인디케이터의 너비를 탭의 너비로 설정
                  ),
                ),
                Container(
                  height: 328,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // 아기 정보가 있을 경우
                      if (_babyNickname.isNotEmpty)
                        ProfileScreen(
                          babyNickname: _babyNickname ?? '아기 정보 없음',
                          babyBirthDate: _babyBirthDate ?? '아기 생일 정보 없음',
                          babyGender: _babygender ?? '아기 성별 정보 없음',
                          babyWeight: _babyweight,
                          babyHeight: _babyheight,
                        )
                      // 아기 정보가 없을 경우
                      else
                        NoBabyInfoScreen(), // 아기 정보가 없을 때 보여줄 화면
                      ShoppingScreen(), // 쇼핑 화면 클래스 사용
                    ],
                  ),
                ),
                middleLine,
                Container(
                  width: 360,
                  padding:
                      EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      title('관심목록'),
                      MyProfileButton(
                        text: '관심상품',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DesignerCollection()), // 관심 디자이너 화면으로 이동
                          );
                        },
                      ),
                      MyProfileButton(text: '관심 육아 꿀팁', onPressed: () {}),
                      MyProfileButton(text: '좋아요한 리뷰', onPressed: () {}),
                    ],
                  ),
                ),
                middleLine,
                Container(
                  width: 360,
                  padding:
                      EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      title('나의 쇼핑 정보'),
                      MyProfileButton(text: '나의 주문/배송 내역', onPressed: () {}),
                      MyProfileButton(text: '취소/반품/교환 내역', onPressed: () {}),
                      MyProfileButton(text: '이벤트 참여 내역', onPressed: () {}),
                      MyProfileButton(text: '환불계좌 관리', onPressed: () {}),
                    ],
                  ),
                ),
                middleLine,
                Container(
                  width: 360,
                  padding:
                      EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      title('고객센터'),
                      MyProfileButton(text: '공지사항', onPressed: () {}),
                      MyProfileButton(text: 'FAQ', onPressed: () {}),
                      MyProfileButton(text: '1:1 문의하기', onPressed: () {})
                    ],
                  ),
                ),
                CompanyInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 관심사 위젯
Widget customTextContainer(String text) {
  return Container(
    height: 26,
    padding: EdgeInsets.symmetric(horizontal: 8.0)
        .copyWith(top: 4.0, bottom: 4.0), // 좌우 8, 위아래 4 패딩 추가
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

//마이페이지 - 설정버튼
class MyProfileButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyProfileButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 48,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 1.4,
              letterSpacing: -0.35,
            ),
          ),
          Icon(
            Icons.navigate_next,
            size: 16,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}

Widget middleLine = Container(
  width: 360,
  height: 8, // 원하는 높이 설정
  decoration: BoxDecoration(color: Color(0xFFF6F6F6)), // 색상 설정
);

Widget title(String text) {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF0095F6),
          fontSize: 20,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          height: 1,
          letterSpacing: -0.50,
        ),
      ),
    ),
  );
}

// 프로필 화면
class ProfileScreen extends StatelessWidget {
  final String babyNickname; // 아기 닉네임을 위한 변수
  final String babyBirthDate; // 아기 닉네임을 위한 변수
  final String babyGender; // 추가된 부분
  final double babyWeight; // 추가된 부분
  final double babyHeight; // 추가된 부분

  ProfileScreen({
    required this.babyNickname,
    required this.babyBirthDate,
    required this.babyGender,
    required this.babyWeight, // 추가된 부분
    required this.babyHeight, // 추가된 부분
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 수평 스크롤 가능하게 설정
        child: Row(
          children: [
            Container(
              width: 360,
              height: 328,
              padding:
                  EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 24),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: 328,
                    height: 22,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // 양쪽 끝으로 배치
                      children: [
                        Container(
                          width: 277,
                          height: 22,
                          child: Text(
                            '우리 아이 정보',
                            style: TextStyle(
                              color: Color(0xFF5D5D5D),
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              letterSpacing: -0.40,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.refresh, // 새로고침 아이콘
                              size: 16, // 아이콘 크기
                              color: Color(0xFFB0B0B0), // 아이콘 색상
                            ),
                            SizedBox(width: 4), // 아이콘과 텍스트 사이의 간격
                            Text(
                              '초기화',
                              style: TextStyle(
                                color: Color(0xFFB0B0B0),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: -0.30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: 328,
                    height: 80,
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: Image.asset(
                            'assets/image/baby img.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12), // 박스 사이의 간격 (필요시 조정)
                        Container(
                          width: 236,
                          height: 74,
                          child: Column(
                            children: [
                              Container(
                                width: 236,
                                height: 22,
                                child: Text(
                                  babyNickname,
                                  style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                    letterSpacing: -0.40,
                                  ),
                                ),
                              ),

                              SizedBox(height: 8), // 사이 간격
                              Container(
                                width: 236,
                                height: 18,
                                child: Text(
                                  '$babyGender / $babyBirthDate',
                                  // 아기 생일 정보를 포함
                                  style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                    letterSpacing: -0.35,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8), // 사이 간격
                              Container(
                                width: 236,
                                height: 18,
                                child: Text(
                                  '$babyHeight cm / $babyWeight kg', // 순서를 수정
                                  style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
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
                  SizedBox(height: 12),
                  Container(
                    width: 328,
                    height: 56,
                    child: Column(
                      children: [
                        Container(
                          width: 328,
                          height: 22,
                          child: Text(
                            '관심사',
                            style: TextStyle(
                              color: Color(0xFF3D3D3D),
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              letterSpacing: -0.40,
                            ),
                          ),
                        ),

                        SizedBox(height: 8), // 사이 간격
                        Container(
                          width: 328,
                          height: 26,
                          color: Colors.white, // 두 번째 박스 색상
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // 가로 왼쪽 정렬
                            children: [
                              customTextContainer('레이싱카'),
                              SizedBox(width: 12),
                              customTextContainer('퍼즐'),
                              SizedBox(width: 12),
                              customTextContainer('보드게임'),
                              SizedBox(width: 12),
                              customTextContainer('보드게임'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  saveButton('수정하기', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              BabymypageEdit()), // LoginPage는 본인의 로그인 페이지로 교체
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//쇼핑 화면
class ShoppingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 수평 스크롤 가능하게 설정
        child: Column(
          children: [
            Container(
              width: 360,
              height: 128,
              color: Colors.white,
              padding: EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Column(
                children: [
                  Container(
                    width: 328,
                    height: 18,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // 양쪽 끝 정렬
                      children: [
                        Text(
                          '내 주문/배송 진행상황',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            letterSpacing: -0.35,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time, // 시계 아이콘
                              size: 14, // 아이콘 크기
                              color: Color(0xFFB0B0B0), // 아이콘 색상
                            ),
                            SizedBox(width: 4), // 아이콘과 텍스트 간격
                            Text(
                              '(최근 1개월)',
                              style: TextStyle(
                                color: Color(0xFFB0B0B0),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                letterSpacing: -0.30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8), // 사이즈박스
                  Container(
                    width: 328,
                    height: 78,
                    color: Colors.white,
                    // 박스 색상
                    padding: EdgeInsets.only(top: 12, bottom: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 46,
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 24,
                                child: Center(
                                  child: Text(
                                    '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0095F6),
                                      fontSize: 20,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                      letterSpacing: -0.50,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 56,
                                height: 14,
                                child: Text(
                                  '입금대기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                    letterSpacing: -0.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        arrowIcon(),
                        Container(
                          width: 56,
                          height: 46,
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 24,
                                child: Center(
                                  child: Text(
                                    '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0095F6),
                                      fontSize: 20,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                      letterSpacing: -0.50,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 56,
                                height: 14,
                                child: Text(
                                  '입금대기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                    letterSpacing: -0.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        arrowIcon(),
                        Container(
                          width: 56,
                          height: 46,
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 24,
                                child: Center(
                                  child: Text(
                                    '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0095F6),
                                      fontSize: 20,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                      letterSpacing: -0.50,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 56,
                                height: 14,
                                child: Text(
                                  '입금대기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                    letterSpacing: -0.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        arrowIcon(),
                        Container(
                          width: 56,
                          height: 46,
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 24,
                                child: Center(
                                  child: Text(
                                    '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0095F6),
                                      fontSize: 20,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                      letterSpacing: -0.50,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 56,
                                height: 14,
                                child: Text(
                                  '입금대기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                    letterSpacing: -0.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        arrowIcon(),
                        Container(
                          width: 56,
                          height: 46,
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 24,
                                child: Center(
                                  child: Text(
                                    '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0095F6),
                                      fontSize: 20,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                      letterSpacing: -0.50,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 56,
                                height: 14,
                                child: Text(
                                  '입금대기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                    letterSpacing: -0.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 360,
              height: 128,
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // 박스들 사이의 간격 조정
                children: [
                  card_widget(
                    'assets/image/Mypage_iocn1 img.png', // 이미지 경로
                    '주문/배송 주문 내역', // 제목
                    '주문내역을 빠르고 간편하게', // 설명
                  ),
                  SizedBox(width: 12), // 사이즈 박스 12
                  card_widget(
                    'assets/image/Mypage_iocn2 img.png', // 이미지 경로
                    '취소/반품/교환 내역', // 제목
                    '제대로 됐는지 불안하다면?', // 설명
                  ),
                ],
              ),
            ),
            reviewContainer(),
          ],
        ),
      ),
    );
  }
}

// 프로필 없을때 홤녀
class NoBabyInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 수평 스크롤 가능하게 설정
        child: Row(
          children: [
            Container(
              width: 360,
              height: 328,
              padding:
                  EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 24),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: 328,
                    height: 22,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // 양쪽 끝으로 배치
                      children: [
                        Container(
                          width: 277,
                          height: 22,
                          child: Text(
                            '우리 아이 정보',
                            style: TextStyle(
                              color: Color(0xFF5D5D5D),
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              letterSpacing: -0.40,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.refresh, // 새로고침 아이콘
                              size: 16, // 아이콘 크기
                              color: Color(0xFFB0B0B0), // 아이콘 색상
                            ),
                            SizedBox(width: 4), // 아이콘과 텍스트 사이의 간격
                            Text(
                              '초기화',
                              style: TextStyle(
                                color: Color(0xFFB0B0B0),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: -0.30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: 328,
                    height: 148,
                    color: Colors.red,
                    child: Image.asset(
                      'assets/image/noinformation img.png',
                      fit: BoxFit.cover, // 이미지 크기를 컨테이너에 맞게 조절
                    ),
                  ),
                  saveButton('등록하기', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              BabymypageEdit()), // LoginPage는 본인의 로그인 페이지로 교체
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//유저 버튼
class UserInfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; // 현재 사용자 확인

    return GestureDetector(
      onTap: () {
        if (user == null) {
          // 로그인 페이지로 이동하는 로직 추가
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Login()), // LoginPage는 본인의 로그인 페이지로 교체
          );
        } else {
          // 정보 수정 페이지로 이동하는 로직 추가
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    MyPageEdit()), // EditProfilePage는 본인의 정보 수정 페이지로 교체
          );
        }
      },
      child: Container(
        width: 89,
        height: 18,
        child: Text(
          user != null ? '내 정보 수정하기' : '로그인 하러 가기',
          style: TextStyle(
            color: Color(0xFF5D5D5D),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            height: 1.3,
            letterSpacing: -0.35,
          ),
          overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 처리
        ),
      ),
    );
  }
}

Widget saveButton(String label, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed, // 버튼 클릭 시 실행될 함수
    child: Container(
      height: 50,
      width: 328,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4), // 모서리 둥글게
        color: Color(0xFF0095F6),
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

Widget arrowIcon() {
  return Center(
    child: Container(
      width: 12,
      height: 12,
      child: Icon(
        Icons.chevron_right, // '>' 모양의 아이콘
        size: 12, // 아이콘 크기
        color: Colors.black, // 아이콘 색상
      ),
    ),
  );
}

Widget card_widget(String imagePath, String title, String subtitle) {
  return Container(
    width: 158,
    height: 96,
    padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
    // 패딩 추가
    decoration: ShapeDecoration(
      color: Color(0xFFF6F6F6), // 배경 색상
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0xFFE7E7E7)), // 경계선
        borderRadius: BorderRadius.circular(8), // 둥근 모서리
      ),
      shadows: [
        BoxShadow(
          color: Color(0x3FF6F6F6), // 그림자 색상
          blurRadius: 12, // 흐림 반경
          offset: Offset(0, 0), // 그림자 위치
          spreadRadius: 0, // 그림자 확장
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          width: 126,
          height: 20,
          child: Text(
            title, // 제목을 매개변수로 사용
            style: TextStyle(
              color: Color(0xFF3D3D3D),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.4,
              letterSpacing: -0.35,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 127,
          height: 12,
          child: Text(
            subtitle, // 설명을 매개변수로 사용
            style: TextStyle(
              color: Color(0xFF888888),
              fontSize: 11,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              height: 1.0,
              letterSpacing: -0.30,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 126,
          height: 32,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 32,
                child: Image.asset(
                  imagePath, // 이미지 경로를 매개변수로 사용
                  fit: BoxFit.cover, // 이미지의 크기를 컨테이너에 맞게 조정
                ),
              ),
              SizedBox(width: 12),
              Center(
                child: Container(
                  width: 71,
                  height: 20,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(1.00, -0.08),
                      end: Alignment(-1, 0.08),
                      colors: [
                        Color(0xFF0095F6),
                        Color(0xFF0091F0),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFF0095F6)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x330095F6),
                        blurRadius: 8,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '확인하기 >',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                        letterSpacing: -0.30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget reviewContainer() {
  return Container(
    width: 360,
    height: 66,
    color: Colors.white,
    child: Center(
      // 버튼을 중앙에 배치
      child: Container(
        width: 328,
        height: 42,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: ShapeDecoration(
          color: Color(0xFF0095F6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '지금 ',
                    style: TextStyle(
                      color: Color(0xFFF6F6F6),
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      letterSpacing: -0.35,
                    ),
                  ),
                  TextSpan(
                    text: '리뷰',
                    style: TextStyle(
                      color: Color(0xFFFFD51B),
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      letterSpacing: -0.35,
                    ),
                  ),
                  TextSpan(
                    text: '를 관리해보세요',
                    style: TextStyle(
                      color: Color(0xFFF6F6F6),
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
            Text(
              '0건', // 오른쪽 텍스트 추가
              style: TextStyle(
                color: Color(0xFFF6F6F6),
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
    ),
  );
}

/////////////////////////////////////////////////////////////////////

/* 공통 모듈 관리 */
/////////////////////////////////////////////////////////////////////
// 홈 / 기능 / 커뮤 / 예약
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(left: 16),
          width: 360,
          color: Colors.white,
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 232,
                height: 56,
                child: Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: Image.asset(
                    'assets/image/logo_modi.png', // 실제 로고 이미지
                    width: 34,
                    height: 34,
                  ),
                ),
              ),
              SizedBox(
                width: 56,
                height: 56,
                child: Padding(
                  padding: EdgeInsets.all(16), // 패딩 값 설정
                  child: Icon(
                    Icons.search, // 검색 아이콘
                    size: 24, // 아이콘 크기
                  ),
                ),
              ),
              SizedBox(
                width: 56,
                height: 56,
                child: Padding(
                  padding: EdgeInsets.all(16), // 패딩 값 설정
                  child: Icon(
                    Icons.notifications, // 검색 아이콘
                    size: 24, // 아이콘 크기
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(360, kToolbarHeight);
}

//마이페이지 - 앱바
class MyProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyProfileAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(left: 16),
          color: Color(0xFF4F4F4F),
          width: 360,
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 222,
                  height: 25,
                  child: Text(
                    '마이프로필',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      letterSpacing: -0.45,
                    ),
                  )),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none),
                iconSize: 24,
                color: Colors.white,
                style: OutlinedButton.styleFrom(minimumSize: Size.zero),
              ),
              SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Setting()), // Test3 화면으로 이동
                  );
                },
                icon: Icon(Icons.settings_outlined),
                iconSize: 24,
                color: Colors.white,
                style: OutlinedButton.styleFrom(minimumSize: Size.zero),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(360, kToolbarHeight);
}

Widget CompanyInfo() {
  return Container(
    width: 360,
    padding: const EdgeInsets.only(
      top: 24,
      left: 16,
      right: 16,
      bottom: 48,
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 16,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/image/logo_modi.png'),
                fit: BoxFit.cover,
              )),
            ),
            SizedBox(width: 4),
            Text(
              '(주)모디랑',
              style: TextStyle(
                color: Color(0xFF3D3D3D),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.3,
                letterSpacing: -0.30,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          width: 328,
          height: 178,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Color(0xFFE7E7E7), width: 1)),
          child: Column(
            children: const [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '대표이사  :  황대찬  |  사업자등록번호  :  비공개',
                  style: TextStyle(
                    color: Color(0xFF5D5D5D),
                    fontSize: 11,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '주소  :  경북 경산시 하양읍 문화로4길 18-15 샹그릴라A 306호',
                  style: TextStyle(
                    color: Color(0xFF5D5D5D),
                    fontSize: 11,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '전화번호  :  010-3009-5596',
                  style: TextStyle(
                    color: Color(0xFF5D5D5D),
                    fontSize: 11,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '이메일 주소  :  holyhabits915@gmail.com',
                  style: TextStyle(
                    color: Color(0xFF5D5D5D),
                    fontSize: 11,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '호스팅서비스제공자  : Firebase Hosting - Google  ',
                  style: TextStyle(
                    color: Color(0xFF5D5D5D),
                    fontSize: 11,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '통신판매업신고  :  2024-대구경북-00336호',
                  style: TextStyle(
                    color: Color(0xFF5D5D5D),
                    fontSize: 11,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            TextButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.zero),
              child: Text(
                "사업자정보확인",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5D5D5D),
                  fontSize: 11,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  letterSpacing: -0.28,
                ),
              ),
            ),
            SizedBox(width: 4),
            Container(
              width: 1,
              height: 11,
              decoration: BoxDecoration(color: Color(0xFF5D5D5D)),
            ),
            SizedBox(width: 4),
            TextButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.zero),
              child: Text(
                "전자금융거래이용약관",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5D5D5D),
                  fontSize: 11,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  letterSpacing: -0.28,
                ),
              ),
            ),
            SizedBox(width: 4),
            Container(
              width: 1,
              height: 11,
              decoration: BoxDecoration(color: Color(0xFF5D5D5D)),
            ),
            SizedBox(width: 4),
            TextButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.zero),
              child: Text(
                "전자금융거래이용약관",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5114FF),
                  fontSize: 11,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  letterSpacing: -0.28,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            TextButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.zero),
              child: Text(
                "리뷰운영정책",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5D5D5D),
                  fontSize: 11,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  letterSpacing: -0.28,
                ),
              ),
            ),
            SizedBox(width: 4),
            Container(
              width: 1,
              height: 11,
              decoration: BoxDecoration(color: Color(0xFF5D5D5D)),
            ),
            SizedBox(width: 4),
            TextButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.zero),
              child: Text(
                "데이터제공정책",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5D5D5D),
                  fontSize: 11,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  letterSpacing: -0.28,
                ),
              ),
            ),
            SizedBox(width: 4),
            Container(
              width: 1,
              height: 11,
              decoration: BoxDecoration(color: Color(0xFF5D5D5D)),
            ),
            SizedBox(width: 4),
            TextButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.zero),
              child: Text(
                "소비자분쟁해결기준",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5D5D5D),
                  fontSize: 11,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  letterSpacing: -0.28,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 164,
              height: 84,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      topLeft: Radius.circular(4)),
                  border: Border.all(color: Color(0xFFE7E7E7), width: 1)),
              child: Column(
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '고객센터(대표)',
                      style: TextStyle(
                        color: Color(0xFF5D5D5D),
                        fontSize: 11,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '010-3009-5596',
                      style: TextStyle(
                        color: Color(0xFF5D5D5D),
                        fontSize: 11,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '24시간 운영, 연중무휴',
                      style: TextStyle(
                        color: Color(0xFF5D5D5D),
                        fontSize: 11,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 164,
              height: 84,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(4),
                      topRight: Radius.circular(4)),
                  border: Border(
                      top: BorderSide(color: Color(0xFFE7E7E7), width: 1),
                      bottom: BorderSide(color: Color(0xFFE7E7E7), width: 1),
                      right: BorderSide(color: Color(0xFFE7E7E7), width: 1))),
              child: Column(
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '고객센터',
                      style: TextStyle(
                        color: Color(0xFF5D5D5D),
                        fontSize: 11,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '010-4172-4515',
                      style: TextStyle(
                        color: Color(0xFF5D5D5D),
                        fontSize: 11,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '오전 09:00 ~ 익일 18:00',
                      style: TextStyle(
                        color: Color(0xFF5D5D5D),
                        fontSize: 11,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '(주)모디랑은 통신판매중개자로 거래 당사자가 아니므로, 판매자가 등록한 \n상품정보 및 거래 등에 대해 책임을 지지 않습니다. \n단, (주)모디랑이 판매자로 등록 판매한 상품은 판매자로서 책임을 부담합니다.',
            style: TextStyle(
              color: Color(0xFF5D5D5D),
              fontSize: 11,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.5,
              letterSpacing: -0.28,
            ),
          ),
        )
      ],
    ),
  );
}

// 마이페이지 앱바
class HomeAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar1({Key? key}) : super(key: key);

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
              SizedBox(
                width: 232,
                height: 56,
                child: Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: Image.asset(
                    'assets/image/logo_modi.png', // 실제 로고 이미지
                    width: 34,
                    height: 34,
                  ),
                ),
              ),
              SizedBox(
                width: 56,
                height: 56,
                child: IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    size: 24,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Setting(),
                      ),
                    );
                  },
                  padding: EdgeInsets.zero, // 패딩을 0으로 설정하여 아이콘을 중앙에 맞춤
                  constraints: BoxConstraints(), // 기본 constraints 제거
                ),
              ),
              SizedBox(
                width: 56,
                height: 56,
                child: Padding(
                  padding: EdgeInsets.all(16), // 패딩 값 설정
                  child: Icon(
                    Icons.notifications, // 검색 아이콘
                    size: 24, // 아이콘 크기
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(360, kToolbarHeight);
}
/////////////////////////////////////////////////////////////////////
