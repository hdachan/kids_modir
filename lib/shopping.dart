import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '탭 네비게이션 예제',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage4(),
    );
  }
}

class MyHomePage4 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage4>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // TabController 초기화
  }

  @override
  void dispose() {
    _tabController.dispose(); // 메모리 누수 방지를 위해 dispose
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

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 360,
            child: Column(
              children: [
                Container(
                  width: 360,
                  height: 360,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/water img.png'), // 이미지 경로
                      fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                    ),
                  ),
                ),
                Container(
                  width: 360,
                  height: 106,
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 24),
                  child: Column(
                    children: [
                      Container(
                        width: 328,
                        height: 28,
                        child: Text(
                          '우리 집이 워터파크 ?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: 328,
                        height: 18,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '추천나이:', // 기본 텍스트
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              TextSpan(
                                text: ' 3세 이상', // 스타일을 변경할 텍스트
                                style: TextStyle(
                                  color: Color(0xFF0095F6),
                                  // 다른 색상
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              TextSpan(
                                text: '  추천장소:', // 기본 텍스트
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              TextSpan(
                                text: ' 실내외', // 스타일을 변경할 텍스트
                                style: TextStyle(
                                  color: Color(0xFF0095F6),
                                  // 다른 색상
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              TextSpan(
                                text: '  놀이:', // 기본 텍스트
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              TextSpan(
                                text: ' 다목적놀이', // 스타일을 변경할 텍스트
                                style: TextStyle(
                                  color: Color(0xFF0095F6),
                                  // 다른 색상
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 360,
                  height: 86,
                  padding:
                      EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 12),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        width: 360,
                        height: 28,
                        child: Text(
                          '물놀이의 영향',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 328,
                        height: 14,
                        child: Text(
                          '물놀이를 하면 아이게게 어떤 영향을 줄까요?',
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
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
                              '발달',
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
                              '유의사항',
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
                  height: 504,
                  child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    // 탭을 스와이프할 수 없도록 설정
                    children: [
                      // 각 탭에 대한 내용 추가
                      ScrollableContainer(),
                      ScrollableContainer1(),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // 수평 스크롤 설정
                  child: Row(
                    children: [
                      Container(
                        width: 360, // 전체 컨테이너 너비
                        height: 800,
                        color: Colors.white,
                        child: Container(
                          width: 360,
                          height: 70,
                          child: Column(
                            children: [
                              Container(
                                width: 328,
                                height: 28,
                                child: Text(
                                  '1. 미니 볼로 간단한 놀이',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 328,
                                height: 34,
                                child: Text(
                                  '발코니나 집 마당에서 간단하게 미니볼로 만들어서 색다른물놀이는 해보는건 어떤가요? ',
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 360,
                                height: 450,
                                child: Center(
                                  // 이미지를 중앙에 배치
                                  child: Image.asset(
                                    'assets/image/play_shop1.png', // 이미지 경로
                                    fit: BoxFit.cover,
                                    // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                                    width: 360,
                                    // 원하는 너비
                                    height: 450, // 원하는 높이
                                  ),
                                ),
                              ),
                              Container(
                                width: 360,
                                height: 176,
                                padding: EdgeInsets.only(
                                    left: 16, top: 12, right: 16, bottom: 12),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 328,
                                      height: 80,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            child: Center( // 이미지를 중앙에 배치
                                              child: Image.asset(
                                                'assets/image/play_shop4.png', // 이미지 경로
                                                fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                                                width: 80, // 원하는 너비
                                                height: 80, // 원하는 높이
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Container(
                                            width: 80,
                                            height: 80,
                                            child: Center( // 이미지를 중앙에 배치
                                              child: Image.asset(
                                                'assets/image/play_shop5.png', // 이미지 경로
                                                fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                                                width: 80, // 원하는 너비
                                                height: 80, // 원하는 높이
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    saveButton('태그된 상품 정보 >', () {
                                      _showPopup(context); // context를 전달
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 360, // 전체 컨테이너 너비
                        height: 800,
                        color: Colors.white,
                        child: Container(
                          width: 360,
                          height: 70,
                          child: Column(
                            children: [
                              Container(
                                width: 328,
                                height: 28,
                                child: Text(
                                  '2. 물놀이의 정석은 물총 싸움',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 328,
                                height: 34,
                                child: Text(
                                  '어른과 아이가 같이 재밌게 놀 수 있는 방법 중 하나는 어른들도동심으로 돌아가 물총 싸움을 하며 노는 것입니다.  ',
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 360,
                                height: 450,
                                color: Colors.cyanAccent,
                                child: Center(
                                  // 이미지를 중앙에 배치
                                  child: Image.asset(
                                    'assets/image/play_shop2.png', // 이미지 경로
                                    fit: BoxFit.cover,
                                    // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                                    width: 360,
                                    // 원하는 너비
                                    height: 450, // 원하는 높이
                                  ),
                                ),
                              ),
                              Container(
                                width: 360,
                                height: 176,
                                padding: EdgeInsets.only(
                                    left: 16, top: 12, right: 16, bottom: 12),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 328,
                                      height: 80,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            child: Center( // 이미지를 중앙에 배치
                                              child: Image.asset(
                                                'assets/image/play_shop6.png', // 이미지 경로
                                                fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                                                width: 80, // 원하는 너비
                                                height: 80, // 원하는 높이
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.cyan,
                                            child: Center( // 이미지를 중앙에 배치
                                              child: Image.asset(
                                                'assets/image/play_shop7.png', // 이미지 경로
                                                fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                                                width: 80, // 원하는 너비
                                                height: 80, // 원하는 높이
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    saveButton('태그된 상품 정보 >', () {
                                      _showPopup(context); // context를 전달
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 360, // 전체 컨테이너 너비
                        height: 800,
                        color: Colors.white,
                        child: Container(
                          width: 360,
                          height: 70,
                          child: Column(
                            children: [
                              Container(
                                width: 328,
                                height: 28,
                                child: Text(
                                  '3. 물 받아 놓고  비누방울 놀이하기',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 328,
                                height: 34,
                                child: Text(
                                  '미끄러져서 넘어지지 않도록 목욕신발을 신거나 아쿠아슈즈 신기.미끄럼방지 매트까는 것도 도움이 됩니다!  ',
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 360,
                                height: 450,
                                child: Center(
                                  // 이미지를 중앙에 배치
                                  child: Image.asset(
                                    'assets/image/play_shop3.png', // 이미지 경로
                                    fit: BoxFit.cover,
                                    // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                                    width: 360,
                                    // 원하는 너비
                                    height: 450, // 원하는 높이
                                  ),
                                ),
                              ),
                              Container(
                                width: 360,
                                height: 176,
                                padding: EdgeInsets.only(
                                    left: 16, top: 12, right: 16, bottom: 12),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 328,
                                      height: 80,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            child: Center( // 이미지를 중앙에 배치
                                              child: Image.asset(
                                                'assets/image/play_shop4.png', // 이미지 경로
                                                fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                                                width: 80, // 원하는 너비
                                                height: 80, // 원하는 높이
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Container(
                                            width: 80,
                                            height: 80,
                                            child: Center( // 이미지를 중앙에 배치
                                              child: Image.asset(
                                                'assets/image/play_shop5.png', // 이미지 경로
                                                fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                                                width: 80, // 원하는 너비
                                                height: 80, // 원하는 높이
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    saveButton('태그된 상품 정보 >', () {
                                      _showPopup(context); // context를 전달
                                    }),
                                  ],
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
      ),
    );
  }
}

class ScrollableContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 24),
          child: Row(
            children: [
              Container(
                height: 468,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/play img.png'), // 이미지 경로
                    fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                height: 468,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/play1 img.png'), // 이미지 경로
                    fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                height: 468,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/play2 img.png'), // 이미지 경로
                    fit: BoxFit.cover, // 이미지가 컨테이너에 맞춰 잘리거나 늘어나는 방식
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

class ScrollableContainer1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 360,
        height: 504,
        color: Colors.white,
        padding: EdgeInsets.only(top: 12, bottom: 48, left: 16, right: 16),
        child: Column(
          children: [
            iconCard(
              [
                'assets/image/icon_error7.png',
                'assets/image/icon_error8.png',
                'assets/image/icon_error6.png',
              ],
              [
                '안전 장비 착용',
                '수심 확인',
                '온도 체크',
              ],
            ),
            SizedBox(height: 20),
            iconCard(
              [
                'assets/image/icon_error4.png',
                'assets/image/icon_error5.png',
                'assets/image/icon_error9.png',
              ],
              [
                '시간 조절',
                '행동 주의',
                '응급 상황 대비',
              ],
            ),
            SizedBox(height: 20),
            iconCard(
              [
                'assets/image/icon_error1.png',
                'assets/image/icon_error2.png',
                'assets/image/icon_error3.png',
              ],
              [
                '자외선 차단',
                '수분 공급',
                '성인동반',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget iconCard(List<String> images, List<String> texts) {
  return Container(
    width: 328,
    height: 126,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(images.length, (index) {
        return Container(
          width: 96,
          height: 126,
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(images[index]), // 이미지 경로
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 96,
                height: 22,
                child: Text(
                  texts[index], // 텍스트
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF5D5D5D),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ),
  );
}

Widget saveButton(String label, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed, // 버튼 클릭 시 실행될 함수
    child: Container(
      height: 48,
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
