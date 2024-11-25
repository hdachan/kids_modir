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
              label: '육아팁',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(Icons.favorite) // 선택된 상태에서 즐겨찾기 아이콘
                  : Icon(Icons.favorite_border), // 선택되지 않은 상태에서 즐겨찾기 아이콘
              label: '콘텐츠',
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
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 16),
                                  IconCard(
                                    imagePath: 'assets/image/card img (1).png',
                                    text: '육아용품',
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 16),
                                  IconCard(
                                    imagePath: 'assets/image/card img (2).png',
                                    text: '장난감',
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 16), // 사이즈 박스 추가
                                  IconCard(
                                    imagePath: 'assets/image/card img (3).png',
                                    text: '학용품',
                                    onPressed: () {},
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
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 16), // 사이즈 박스 추가
                                  IconCard(
                                    imagePath: 'assets/image/card img (5).png',
                                    // 이미지 경로
                                    text: '기획전',
                                    // 텍스트 내용
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 16), // 사이즈 박스 추가
                                  IconCard(
                                    imagePath: 'assets/image/card img (6).png',
                                    // 이미지 경로
                                    text: '이벤트',
                                    // 텍스트 내용
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 16), // 사이즈 박스 추가
                                  IconCard(
                                    imagePath: 'assets/image/card img (7).png',
                                    // 이미지 경로
                                    text: '쿠폰',
                                    // 텍스트 내용
                                    onPressed: () {},
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
                        '리뷰로 보는 상품',
                        '리뷰를 통해 아이에게 필요한 용품을 찾아 보세요',
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
                                height: 412,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 240,
                                      height: 52,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
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
                                      height: 60,
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          left: 4,
                                          right: 4,
                                          bottom: 8),
                                      child: Container(
                                        width: 232,
                                        height: 100,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 204,
                                              height: 40,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 204,
                                                    height: 18,
                                                    child: Text(
                                                      '육아하면서 가장 잘 산 육아템 중하나라고 생각해요!!',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF5D5D5D),
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1, // 최대 한 줄로 제한
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  // 사이 간격 8
                                                  Container(
                                                    width: 204,
                                                    height: 14,
                                                    child: Text(
                                                      '2세 87cm 13kg',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF888888),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Container(
                                              width: 24,
                                              height: 40,
                                              color: Colors.white, // 내부 박스 색상
                                              child: Center(
                                                child: Icon(
                                                  Icons.favorite_border,
                                                  size: 24, // 아이콘 크기 조정
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
                              SizedBox(width: 15),
                              // 2번째 위젯
                              Container(
                                width: 240,
                                height: 412,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 240,
                                      height: 52,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
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
                                      height: 60,
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          left: 4,
                                          right: 4,
                                          bottom: 8),
                                      child: Container(
                                        width: 232,
                                        height: 100,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 204,
                                              height: 40,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 204,
                                                    height: 18,
                                                    child: Text(
                                                      '육아하면서 가장 잘 산 육아템 중하나라고 생각해요!!',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF5D5D5D),
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // 텍스트가 넘칠 경우 ...으로 표시
                                                      maxLines: 1, // 최대 한 줄로 제한
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  // 사이 간격 8
                                                  Container(
                                                    width: 204,
                                                    height: 14,
                                                    child: Text(
                                                      '2세 87cm 13kg',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF888888),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(width: 4),
                                            // 내부 박스와 아래 박스 사이의 간격
                                            Container(
                                              width: 24,
                                              height: 40,
                                              color: Colors.white, // 내부 박스 색상
                                              child: Center(
                                                child: Icon(
                                                  Icons.favorite_border,
                                                  // 하트 아이콘
                                                  size: 24, // 아이콘 크기 조정
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
                      ),
                      // 모디랑 육아팁
                      createFeedWidget(
                        '모디랑 육아팁',
                        '모든 가정에 행복이 가득했으면 하는 맘으로 모아봤어요',
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
class _BookmarkScreenState extends State<CoreFunctionalityScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = '전체';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _names = [];
  List<String> _introductions = [];
  List<String> classification = [];
  List<String> _prices = [];
  List<String> _imageUrls = [];
  List<String> _designerIds = [];
  List<int> _reviewCounts = [];
  List<String> _titles = [];
  List<String> _gender = [];

  @override // 처음생성될때 위젯들을 불러옴
  void initState() {
    super.initState();
    _fetchDesignerData();
  }

  Future<void> _fetchDesignerData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('designer').get();
      print('Documents fetched: ${snapshot.docs.length}'); // 문서 수 로그

      setState(() {
        _designerIds = snapshot.docs.map((doc) => doc.id).toList();
        _names = snapshot.docs.map((doc) => doc['name'] as String).toList();
        _introductions =
            snapshot.docs.map((doc) => doc['introduction'] as String).toList();
        classification = snapshot.docs
            .map((doc) => doc['classification'] as String)
            .toList();
        _prices = snapshot.docs.map((doc) => doc['price'].toString()).toList();
        _imageUrls =
            snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
        _titles = snapshot.docs.map((doc) => doc['title'] as String).toList();
        _gender = snapshot.docs.map((doc) => doc['gender'] as String).toList();
        _reviewCounts = snapshot.docs.map((doc) {
          // reviewCount가 문자열일 경우 변환
          var reviewCountValue = doc['reviewCount'];
          if (reviewCountValue is String) {
            return int.tryParse(reviewCountValue) ?? 0; // 변환 실패 시 0 반환
          }
          return reviewCountValue as int; // int로 간주
        }).toList();
      });
    } catch (e) {
      print('Error fetching designer data: $e'); // 오류 로그
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                          height: 56,
                          width: 360,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 12, bottom: 12),
                            child: Row(
                              children: [
                                _buildButton(0, '전체', 48),
                                SizedBox(width: 8),
                                _buildButton(1, '인기순', 78),
                                SizedBox(width: 8),
                                _buildButton(2, '분야', 66),
                                SizedBox(width: 8),
                                _buildButton(3, '성별', 66),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 428,
                          child: _buildListView(),
                        ),
                      ],
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

  Widget _buildButton(int index, String text, double width) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 0) {
          _selectedCategory = '전체';
        }
        if (index == 2) {
          _showCategoryBottomSheet();
        }
        print('$text 버튼 클릭됨!');
      },
      borderRadius: BorderRadius.circular(100),
      splashColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.transparent,
      child: Container(
        height: 32,
        width: width,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF3D3D3D) : Colors.transparent,
          border: isSelected
              ? null
              : Border.all(width: 1, color: Color(0xFFE7E7E7)),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
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
              if (index > 0) ...[
                SizedBox(width: 2),
                Icon(
                  Icons.arrow_drop_down,
                  color: isSelected ? Colors.white : Colors.black,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '카테고리 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('전체'),
                onTap: () {
                  setState(() {
                    _selectedCategory = '전체';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('빈티지'),
                onTap: () {
                  setState(() {
                    _selectedCategory = '빈티지';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('아메카지'),
                onTap: () {
                  setState(() {
                    _selectedCategory = '아메카지';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('포멀'),
                onTap: () {
                  setState(() {
                    _selectedCategory = '포멀';
                  });
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    List<int> filteredIndices = [];
    for (int i = 0; i < classification.length; i++) {
      if (_selectedCategory == '전체' ||
          classification[i].contains(_selectedCategory)) {
        filteredIndices.add(i);
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFE7E7E7),
          ),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: filteredIndices.length,
        itemBuilder: (context, index) {
          final itemIndex = filteredIndices[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DesignerDetailScreen(
                    designerId: _designerIds[itemIndex],
                    name: _names[itemIndex],
                    introduction: _introductions[itemIndex],
                    classification: classification[itemIndex],
                    price: _prices[itemIndex],
                    imageUrl: _imageUrls[itemIndex],
                    reviewCount: _reviewCounts[itemIndex],
                    gender: _gender[itemIndex],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFE7E7E7)))),
              height: 128,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    margin: EdgeInsets.only(right: 16.0, left: 16.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_imageUrls[itemIndex]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titles[itemIndex],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: -0.35,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _names[itemIndex],
                          style: TextStyle(
                            color: Color(0xFF5D5D5D),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            letterSpacing: -0.30,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.yellow),
                            SizedBox(width: 4),
                            Text(
                              '4.9',
                              style: TextStyle(
                                color: Color(0xFF5D5D5D),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: -0.30,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '(${_reviewCounts[itemIndex]})',
                              style: TextStyle(
                                color: Color(0xFF5D5D5D),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: -0.30,
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              width: 1,
                              height: 12,
                              decoration:
                                  BoxDecoration(color: Color(0xFF888888)),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${classification[itemIndex]}',
                              style: TextStyle(
                                color: Color(0xFF5D5D5D),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: -0.30,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${_prices[itemIndex]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                                letterSpacing: -0.35,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '원',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////////

/* 커뮤/매거진 화면 관리 */
/////////////////////////////////////////////////////////////////////
// 커뮤/ 매거진 화면
class CommunityScreen extends StatelessWidget {
  // 클래스 이름 변경
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(), // 앱바
      body: Center(
        child: Text(
          '커뮤니티', // 텍스트 변경
          style: TextStyle(fontSize: 24),
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 탭의 개수 설정
  }

  @override
  void dispose() {
    _tabController.dispose(); // 리소스 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: HomeAppBar(),
          //AppBar(
          //   leading: IconButton(
          //     icon: Icon(Icons.arrow_back),
          //     onPressed: () => Navigator.of(context).pop(),
          //   ),
          //   title: Text(
          //     '스타일링 내역',
          //     style: TextStyle(
          //       color: Color(0xFF3D3D3D),
          //       fontSize: 18,
          //       fontFamily: 'Pretendard',
          //       fontWeight: FontWeight.w700,
          //       height: 1.4,
          //       letterSpacing: -0.45,
          //     ),
          //   ),
          //   actions: [
          //     Padding(
          //       padding: const EdgeInsets.only(right: 4),
          //       child: IconButton(
          //           onPressed: () {},
          //           icon: Icon(Icons.home_outlined),
          //           iconSize: 24),
          //     )
          //   ],
          // ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 360,
                      height: 120,
                      child: Column(
                        children: [
                          Container(
                            width: 360,
                            height: 44,
                          ),
                          Divider(
                            color: Color(0xFFF6F6F6),
                            height: 2.0,
                            thickness: 2.0,
                          ),
                          Container(
                            width: 360,
                            height: 66,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Center(
                              // 자식 컨테이너를 중앙 정렬
                              child: Container(
                                width: 328,
                                height: 42,
                                color: Color(0xFFF6F6F6),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      child: Icon(
                                        Icons.search,
                                        size: 18, // 아이콘 크기 설정
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      width: 274,
                                      height: 18,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: '제목 및 디자이너, 스타일로 검색해 보세요',
                                          hintStyle: TextStyle(
                                            color: Color(0xFF888888),
                                            // 힌트 텍스트
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
                                          border: InputBorder.none, // 밑줄 없애기
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 360,
                            height: 8,
                            color: Color(0xFFF6F6F6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 여기 아래에 TabBarView를 추가하여 탭에 따른 내용을 표시할 수 있습니다.
                  Container(
                    height: 540, // 적절한 높이 설정

                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        TabContent1(),
                        TabContent2(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
  String _babynickname = "";
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
          });
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
      appBar: MyProfileAppBar(),
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
                        decoration: BoxDecoration(
                          color: Colors.blue, // 원하는 색상으로 변경
                          borderRadius: BorderRadius.circular(100), // 둥글게 만들기
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
                      ProfileScreen(), // 프로필 화면 클래스 사용
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
              padding: EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 24),
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
                                  '하늘',
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
                                  '남아 / 2000. 08.16(25개월)',
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
                                  '87cm / 13kg',
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
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


//쇼핑 화면
class ShoppingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView();
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

/////////////////////////////////////////////////////////////////////

/* 공통 모듈 관리 */
/////////////////////////////////////////////////////////////////////
// 홈 / 기능 / 커뮤 / 예약 / 마이페이지 앱바
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
                  '대표이사  :  황대찬  |  사업자등록번호  :  123-45-67891',
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
                  '호스팅서비스제공자  :  (주)모디랑',
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
/////////////////////////////////////////////////////////////////////
