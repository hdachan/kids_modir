import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'DesignerCollection.dart';
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
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // 현재 선택된 인덱스

  final List<Widget> _pages = [
    HomeOverview(), // 전체적인 홈 화면
    DesignerSelectionScreen(), // 디자이너 선택 화면
    MagazineScreen(), // 매거진 화면
    ReservationScreen(), // 예약 화면
    MyProfileScreen(), // 마이페이지 화면
  ]; // 각 페이지 위젯들

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index; // 인덱스 변경 시 상태 갱신
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
          currentIndex: _currentIndex, // 현재 선택된 인덱스
          onTap: updateIndex, // 탭 시 인덱스 업데이트
          selectedItemColor: Color(0xFF3D3D3D), // 선택된 아이템 색상
          unselectedItemColor: Color(0xFF3D3D3D), // 선택되지 않은 아이템 색상
          items: [
            BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(Icons.home)
                  : Icon(Icons.home_outlined), // 홈 아이콘 변경
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(Icons.brush) // 선택된 상태에서 브러시 아이콘
                  : Icon(Icons.brush_outlined), // 선택되지 않은 상태에서 브러시 아이콘
              label: '기능',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(Icons.people) // 선택된 상태에서 커뮤니티 아이콘
                  : Icon(Icons.people_outlined), // 선택되지 않은 상태에서 커뮤니티 아이콘
              label: '커뮤/매거진',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Icon(Icons.bookmark)
                  : Icon(Icons.bookmark_outline), // 북마크 아이콘 변경
              label: '예약',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 4
                  ? Icon(Icons.person)
                  : Icon(Icons.person_outline), // 마이페이지 아이콘 변경
              label: '마이페이지',
            ),
          ],
        ),
      ),
    );
  }
}

// 각 화면 구현 (예시)
class HomeOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("홈 화면"));
  }
}

class DesignerSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("디자이너 선택 화면"));
  }
}

class MagazineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("매거진 화면"));
  }
}

class ReservationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("예약 화면"));
  }
}

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("마이페이지 화면"));
  }
}

