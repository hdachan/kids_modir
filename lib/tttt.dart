import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    home: Ttt(),
  ));
}

class Ttt extends StatefulWidget {
  const Ttt({super.key});

  @override
  State<Ttt> createState() => _TttState();
}

class _TttState extends State<Ttt> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _saveToFirebase() async {
    User? user = _auth.currentUser; // 현재 로그인된 사용자

    if (user != null) {
      String userId = user.uid; // 사용자 UID

      await _firestore
          .collection('users')
          .doc(userId) // 사용자 문서 참조
          .collection('견적서') // 하위 컬렉션 참조
          .add({
        'text': '이미지 선택하기',
      });

      print('데이터가 Firestore에 저장되었습니다.');
    } else {
      print('사용자가 로그인되어 있지 않습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ttt'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _saveToFirebase();
          },
          child: Text('이미지 선택하기'),
        ),
      ),
    );
  }
}
