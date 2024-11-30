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

class _MyHomePageState extends State<MyHomePage1> {
  bool _isExpanded = false; // 텍스트가 확장되었는지 여부
  int? _selectedIndex= 2; // 현재 선택된 버튼의 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개그우먼 홍현희 아들 준범의 일상룩'), // 앱바 제목 설정
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 360,
            child: Column(
              children: [
                Container(
                  width: 360,
                  height: 438, // 높이 조정
                  decoration: BoxDecoration(
                    color: Colors.white, // 박스의 배경색
                  ),
                  child: PageView(
                    // PageView로 변경
                    scrollDirection: Axis.horizontal, // 수평 스크롤 방향 설정
                    children: [
                      imageContainer('assets/image/magazine img.png'),
                      imageContainer('assets/image/magazine img2.png'),
                      imageContainer('assets/image/magazine img3.png'),
                      imageContainer('assets/image/magazine img4.png'),
                      imageContainer('assets/image/magazine img5.png'),
                      imageContainer('assets/image/magazine img6.png'),
                    ],
                  ),
                ),
                Container(
                  width: 360,
                  height: 68,
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
                  // 패딩 설정
                  child: Row(
                    children: [
                      commentWidget(
                        icon: Icons.comment,
                        text: '댓글',
                        isSelected: _selectedIndex == 0, // 선택된 인덱스 비교
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0; // 선택된 인덱스 업데이트
                          });
                          print('댓글 버튼이 클릭되었습니다!');
                        },
                      ),
                      SizedBox(width: 12),
                      commentWidget(
                        icon: Icons.share,
                        text: '공유',
                        isSelected: _selectedIndex == 1, // 선택된 인덱스 비교
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1; // 선택된 인덱스 업데이트
                          });
                          print('공유 버튼이 클릭되었습니다!');
                        },
                      ),
                      SizedBox(width: 12),
                      commentWidget(
                        icon: Icons.article,
                        text: '매거진',
                        isSelected: _selectedIndex == 2, // 선택된 인덱스 비교
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2; // 선택된 인덱스 업데이트
                          });
                          print('매거진 버튼이 클릭되었습니다!');
                        },
                      ),
                      SizedBox(width: 12),
                      commentWidget(
                        icon: Icons.bookmark,
                        text: '북마크',
                        isSelected: _selectedIndex == 3, // 선택된 인덱스 비교
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 3; // 선택된 인덱스 업데이트
                          });
                          print('북마크 버튼이 클릭되었습니다!');
                        },
                      ),
                      SizedBox(width: 12),
                      commentWidget(
                        icon: Icons.public,
                        text: '관련 매거진',
                        isSelected: _selectedIndex == 4, // 선택된 인덱스 비교
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 4; // 선택된 인덱스 업데이트
                          });
                          print('관련 매거진 버튼이 클릭되었습니다!');
                        },
                      ),
                    ],
                  ),
                ),
                if (_selectedIndex == 0) ...[
                  PostCard(
                    author: 'Modir',
                    content: '개그우먼 홍현희의 아들 준범이는 평소에 어떻게 입을까요? 저희 모디랑이 찾아 봤습니다. 관련 매거진랑 똑같이...',
                    date: '2024. 11. 27',
                  ),
                ] else if (_selectedIndex == 1) ...[
                  PostCard(
                    author: 'Commenter',
                    content: '댓글 내용 예시입니다. 다른 사용자들이 남긴 댓글을 보여줍니다.',
                    date: '2024. 11. 28',
                  ),
                ] else if (_selectedIndex == 2) ...[
                  PostCard(
                    author: 'Sharer',
                    content: '공유된 내용입니다. 다른 사용자와의 공유 내용을 보여줍니다.',
                    date: '2024. 11. 29',
                  ),
                ] else if (_selectedIndex == 3) ...[
                  PostCard(
                    author: 'gggg',
                    content: '공유된 내용입니다. 다른 사용자와의 공유 내용을 보여줍니다.',
                    date: '2024. 11. 29',
                  ),
                ]  else if (_selectedIndex == 4) ...[
                  PostCard(
                    author: 'qweqweqwe',
                    content: '공유된 내용입니다. 다른 사용자와의 공유 내용을 보여줍니다.',
                    date: '2024. 11. 29',
                  ),
                ],
              ],
            ),
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
Widget commentWidget({
  required IconData icon,
  required String text,
  required bool isSelected, // 선택 상태 추가
  required VoidCallback onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size(56, 48),
      backgroundColor:Colors.transparent, // 선택된 색상
      overlayColor: Colors.transparent,
    ),
    child: Column(
      children: [
        Container(
          width: 56,
          height: 32,
          child: Center(
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? Color(0xFF0095F6) : Colors.black, // 아이콘 색상 변경
            ),
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: 56,
          height: 12,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Color(0xFF0095F6) : Colors.black, // 텍스트 색상 변경
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


class PostCard extends StatefulWidget {
  final String author;
  final String content;
  final String date;

  const PostCard({
    Key? key,
    required this.author,
    required this.content,
    required this.date,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false; // 텍스트 확장 상태 관리

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: EdgeInsets.all(16), // 패딩 추가
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: 328,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
              children: [
                Container(
                  width: 35,
                  height: 36,
                  child: Text(
                    widget.author, // 작성자 이름
                    style: TextStyle(
                      color: Color(0xFF3D3D3D),
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                      letterSpacing: -0.35,
                    ),
                  ),
                ),
                SizedBox(height: 8), // 수직 간격 추가
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: widget.content,
                        style: TextStyle(
                          color: Color(0xFF3D3D3D),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                          letterSpacing: -0.35,
                        ),
                      ),
                      maxLines: 2, // 최대 줄 수 제한
                      textDirection: TextDirection.ltr,
                    );

                    textPainter.layout(maxWidth: constraints.maxWidth);
                    bool isTextOverflowing = textPainter.didExceedMaxLines;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.content, // 동일한 텍스트를 사용
                          style: TextStyle(
                            color: Color(0xFF3D3D3D),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            letterSpacing: -0.35,
                          ),
                          maxLines: _isExpanded ? null : 2,
                          overflow: _isExpanded ? null : TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8), // 수직 간격 추가
                        if (!_isExpanded && isTextOverflowing) ...[
                          SizedBox(height: 4), // 간격 추가
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded; // 클릭 시 상태 변경
                              });
                            },
                            child: Container(
                              width: 36,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  _isExpanded ? '접기' : '더보기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFB0B0B0),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 1.3,
                                    letterSpacing: -0.35,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 12), // 높이 기준으로 SizedBox 사용
          Container(
            width: 328,
            child: Text(
              widget.date, // 날짜
              style: TextStyle(
                color: Color(0xFF3D3D3D),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.3,
                letterSpacing: -0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}