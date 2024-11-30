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
      home: MyHomePage1(),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage1>
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
      appBar: AppBar(
        title: Text('개그우먼 홍현희 아들 준범의 일상룩'),
      ),
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
                                child:Text(
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
                            labelPadding: EdgeInsets.symmetric(horizontal: 8), // 탭 간의 간격을 넓히기 위해 수정된 부분
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
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          color: Colors.red,
                          child: Row(
                            children: [
                              Container(
                                width: 51,
                                height: 18,
                                child: Text(
                                  '전체 놀이',
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
                              Container(
                                width: 273,
                                height: 18,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                                  children: [
                                    Text(
                                      '12,110개',
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
                      TabContent(tabIndex: 1),
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



class TabContent extends StatelessWidget {
  final int tabIndex;

  TabContent({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 360,
          child: Column(
            children: [
              Container(
                width: 360,
                height: 334,
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                color: Colors.cyan,
                child: Row(
                  children: [
                    Container(
                      width: 162,
                      height: 318,
                      color: Colors.cyanAccent,
                    ),
                    SizedBox(width: 4),
                    Container(
                      width: 162,
                      height: 318,
                      color: Colors.cyanAccent,
                    ),
                  ],
                ),
              ),
              Container(
                width: 360,
                height: 334,
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                color: Colors.cyan,
                child: Row(
                  children: [
                    Container(
                      width: 162,
                      height: 318,
                      color: Colors.cyanAccent,
                    ),
                    SizedBox(width: 4),
                    Container(
                      width: 162,
                      height: 318,
                      color: Colors.cyanAccent,
                    ),
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

Widget imageContainer(String imagePath) {
  return Container(
    width: 360,
    height: 438,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imagePath), // 이미지 경로
        fit: BoxFit.cover, // 이미지의 크기를 컨테이너에 맞춤
      ),
    ),
  );
}

// 매거진 위젯
Widget commentWidget({required IconData icon, required String text}) {
  return Container(
    width: 56,
    height: 48,
    child: Column(
      children: [
        Container(
          width: 56,
          height: 32,
          child: Center(
            child: Icon(
              icon, // 전달받은 아이콘
              size: 24, // 아이콘 크기 조정
              color: Colors.black, // 아이콘 색상 설정 (필요에 따라 변경)
            ),
          ),
        ),
        SizedBox(height: 4), // 사이즈박스 4
        Container(
          width: 56,
          height: 12,
          child: Center(
            child: Text(
              text, // 전달받은 텍스트
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF5D5D5D),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.0,
                letterSpacing: -0.30,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


// Container(
//   width: 360,
//   height: 438, // 높이 조정
//   decoration: BoxDecoration(
//     color: Colors.white, // 박스의 배경색
//   ),
//   child: PageView(
//     // PageView로 변경
//     scrollDirection: Axis.horizontal, // 수평 스크롤 방향 설정
//     children: [
//       imageContainer('assets/image/magazine img.png'),
//       imageContainer('assets/image/magazine img2.png'),
//       imageContainer('assets/image/magazine img3.png'),
//       imageContainer('assets/image/magazine img4.png'),
//       imageContainer('assets/image/magazine img5.png'),
//       imageContainer('assets/image/magazine img6.png'),
//     ],
//   ),
// ),
// Container(
//   width: 360,
//   height: 68,
//   color: Colors.white,
//   padding:
//       EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
//   // 패딩 설정
//   child: Row(
//     children: [
//       commentWidget(icon: Icons.comment, text: '댓글'),
//       SizedBox(width: 12),
//       commentWidget(icon: Icons.share, text: '공유'),
//       SizedBox(width: 12),
//       commentWidget(icon: Icons.article, text: '매거진'), // 매거진 아이콘 변경
//       SizedBox(width: 12),
//       commentWidget(icon: Icons.bookmark, text: '북마크'), // 북마크 아이콘 변경
//       SizedBox(width: 12),
//       commentWidget(icon: Icons.public, text: '관련 매거진'), // 관련 매거진 아이콘 변경
//     ],
//   ),
// ),
// Container(
//   width: 360,
//   padding: EdgeInsets.only(top: 24, bottom: 24, left: 16, right: 16), // 패딩 추가
//   color: Colors.white,
//   child: Column( // Column으로 감싸줌
//     children: [
//       Container(
//         width: 328,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
//           children: [
//             Container(
//               width: 35,
//               height: 36,
//               child: Text(
//                 'Modir',
//                 style: TextStyle(
//                   color: Color(0xFF3D3D3D),
//                   fontSize: 14,
//                   fontFamily: 'Pretendard',
//                   fontWeight: FontWeight.w400,
//                   height: 1.3,
//                   letterSpacing: -0.35,
//                 ),
//               ),
//             ),
//             SizedBox(height: 8), // 수직 간격 추가
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 // 동일한 텍스트를 사용
//                 final String longText = '개그우먼 홍현희의 아들 준범이는 평소에 어떻게 입을까요? 저희 모디랑이 찾아 봤습니다.관련매거진랑 똑같이'
//                     '개그우먼 홍현희의 아들 준범이는 평소에 어떻게 입을까요? 저희 모디랑이 찾아 봤습니다.관련매거진랑 똑같이'
//                     '개그우먼 홍현희의 아들 준범이는 평소에 어떻게 입을까요? 저희 모디랑이 찾아 봤습니다.관련매거진랑 똑같이'
//                 ;
//
//                 // TextPainter를 사용하여 텍스트 높이 계산
//                 final textPainter = TextPainter(
//                   text: TextSpan(
//                     text: longText,
//                     style: TextStyle(
//                       color: Color(0xFF3D3D3D),
//                       fontSize: 14,
//                       fontFamily: 'Pretendard',
//                       fontWeight: FontWeight.w400,
//                       height: 1.3,
//                       letterSpacing: -0.35,
//                     ),
//                   ),
//                   maxLines: 2, // 최대 줄 수 제한
//                   textDirection: TextDirection.ltr,
//                 );
//
//                 textPainter.layout(maxWidth: constraints.maxWidth);
//                 bool isTextOverflowing = textPainter.didExceedMaxLines;
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
//                   children: [
//                     Text(
//                       longText, // 동일한 텍스트를 사용
//                       style: TextStyle(
//                         color: Color(0xFF3D3D3D),
//                         fontSize: 14,
//                         fontFamily: 'Pretendard',
//                         fontWeight: FontWeight.w400,
//                         height: 1.3,
//                         letterSpacing: -0.35,
//                       ),
//                       maxLines: _isExpanded ? null : 2, // 상태에 따라 최대 줄 수 변경
//                       overflow: _isExpanded ? null : TextOverflow.ellipsis, // 줄 수가 초과할 때 생략 기호 표시
//                     ),
//                     SizedBox(height: 8), // 수직 간격 추가
//                     // 텍스트가 생략될 때만 확인
//                     if (!_isExpanded && isTextOverflowing) ...[
//                       SizedBox(height: 4), // 간격 추가
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _isExpanded = !_isExpanded; // 클릭 시 상태 변경
//                           });
//                         },
//                         child: Container(
//                           width: 36,
//                           child: Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Text(
//                               _isExpanded ? '접기' : '더보기',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Color(0xFFB0B0B0),
//                                 fontSize: 14,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.3,
//                                 letterSpacing: -0.35,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 12), // 높이 기준으로 SizedBox 사용
//       Container(
//         width: 328,
//         child: Text(
//           '2024. 11. 27',
//           style: TextStyle(
//             color: Color(0xFF3D3D3D),
//             fontSize: 14,
//             fontFamily: 'Pretendard',
//             fontWeight: FontWeight.w400,
//             height: 1.3,
//             letterSpacing: -0.35,
//           ),
//         ),
//       ),
//     ],
//   ),
// ),
//