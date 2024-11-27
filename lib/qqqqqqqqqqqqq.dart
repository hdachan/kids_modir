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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home Page 1'), // 앱바 제목 설정
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
                  child: PageView( // PageView로 변경
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
                  color: Colors.black,
                  padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12), // 패딩 설정
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 간격 조정
                    children: [
                      for (int i = 0; i < 5; i++) // 반복문으로 박스 생성
                        Container(
                          width: 56,
                          height: 48,
                          color: Colors.blue, // 박스 색상 설정
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 360,
                  height: 174,
                  color: Colors.tealAccent,
                ),
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
