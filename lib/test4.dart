// 견적서 3번

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'test3.dart';

void main() {
  runApp(Test4(designerId: '디자이너 아이디 전달하기 위한 변수')); // Test3 위젯을 홈으로 설정
}

class Test4 extends StatefulWidget {
  final String designerId; // 디자이너 ID 추가

  const Test4({Key? key, required this.designerId}) : super(key: key);
  @override
  _Test4State createState() => _Test4State(); // 상태 클래스를 생성
}

class _Test4State extends State<Test4> {
  int _selectedIndex1 = -1; // 선택된 인덱스 초기화
  int _selectedIndex2 = -1;

  String Quotationpirce = ''; // TextField의 입력값을 저장할 변수
  String Quotationinformation = ''; // TextField의 입력값을 저장할 변수

  TextEditingController quotationPriceController = TextEditingController(); // 컨트롤러 선언
  TextEditingController quotationinformationController = TextEditingController(); // 컨트롤러 선언

  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadSeasonFromFirebase(); // 데이터 불러오기 호출
  }

// Firebase에 데이터를 저장하는 메서드
  Future<void> _saveSeasonToFirebase() async {
    String selectedSeason;
    switch (_selectedIndex1) {
      case 0:
        selectedSeason = '봄';
        break;
      case 1:
        selectedSeason = '여름';
        break;
      case 2:
        selectedSeason = '가을';
        break;
      case 3:
        selectedSeason = '겨울';
        break;
      default:
        return; // 선택된 계절이 없으면 종료
    }

    String selectedCombination;
    switch (_selectedIndex2) {
      case 0:
        selectedCombination = '간단';
        break;
      case 1:
        selectedCombination = '조합';
        break;
      case 2:
        selectedCombination = '활용';
        break;
      case 3:
        selectedCombination = '구축';
        break;
      default:
        return; // 선택된 조합이 없으면 종료
    }

    try {
      await FirebaseFirestore.instance
          .collection('designer')
          .doc(widget.designerId)
          .collection('Quotation')
          .doc(userId)
          .set({
        'season': selectedSeason,
        'Quotationpirce': Quotationpirce, // 입력값
        'combination': selectedCombination, // 선택된 조합 추가
        'Quotationinformation' :Quotationinformation,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('선택된 계절과 조합이 Firebase에 저장되었습니다: $selectedSeason, $selectedCombination');
    } catch (e) {
      print('Firebase 저장 오류: $e');
    }
  }

  Future<void> _loadSeasonFromFirebase() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('designer')
          .doc(widget.designerId)
          .collection('Quotation')
          .doc(userId)
          .get();

      if (doc.exists) {
        String season = doc['season'];
        String combination = doc['combination'];
        String quotationPrice = doc['Quotationpirce'];

        // doc.data()를 Map<String, dynamic>으로 캐스팅
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        String quotationinformation = data != null && data.containsKey('Quotationinformation')
            ? data['Quotationinformation']
            : ''; // 기본값 설정

        // 선택된 계절과 조합에 따라 인덱스를 설정합니다.
        _selectedIndex1 = _getSeasonIndex(season);
        _selectedIndex2 = _getCombinationIndex(combination);

        setState(() {
          // UI 업데이트
          quotationPriceController.text = quotationPrice;
          quotationinformationController.text = quotationinformation;
        });

        print('불러온 계절과 조합: $season, $combination, Quotationpirce: $quotationPrice');
      } else {
        print('문서가 존재하지 않습니다.');
      }
    } catch (e) {
      print('Firebase 불러오기 오류: $e');
    }
  }





// 계절 인덱스를 반환하는 메소드
  int _getSeasonIndex(String season) {
    switch (season) {
      case '봄':
        return 0;
      case '여름':
        return 1;
      case '가을':
        return 2;
      case '겨울':
        return 3;
      default:
        return -1; // 유효하지 않은 경우
    }
  }

// 조합 인덱스를 반환하는 메소드
  int _getCombinationIndex(String combination) {
    switch (combination) {
      case '간단':
        return 0;
      case '조합':
        return 1;
      case '활용':
        return 2;
      case '구축':
        return 3;
      default:
        return -1; // 유효하지 않은 경우
    }
  }




// 다음 버튼을 눌렀을 때 호출하는 메서드
  void onNextButtonPressed() {
    _saveSeasonToFirebase();
    // 추가적인 로직 (예: 다음 화면으로 이동 등)
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: QuotationImgSelectAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: 360,
                  child: Column(
                    children: [
                      Container(
                        width: 360,
                        height: 56,
                        padding: EdgeInsets.all(16), // 패딩 값 추가
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF3D3D3D)),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                color: Colors.white, // 내부 컨테이너 색상
                              ),
                              alignment: Alignment.center,
                              // 텍스트 중앙 정렬
                              child: Text(
                                '1',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF3D3D3D),
                                  fontSize: 10,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                  letterSpacing: -0.25,
                                ),
                              ),
                            ),
                            Container(
                              width: 128,
                              height: 1,
                              color: Color(
                                  0xFFD1D1D1), // 내부 컨테이너 색상 (원하는 색상으로 변경 가능)
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF3D3D3D)),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                color: Colors.white, // 내부 컨테이너 색상
                              ),
                              alignment: Alignment.center,
                              // 텍스트 중앙 정렬
                              child: Text(
                                '2',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF3D3D3D),
                                  fontSize: 10,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                  letterSpacing: -0.25,
                                ),
                              ),
                            ),
                            Container(
                              width: 128,
                              height: 1,
                              color: Color(
                                  0xFFD1D1D1), // 내부 컨테이너 색상 (원하는 색상으로 변경 가능)
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF3D3D3D)),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                color: Color(0xFF3D3D3D), // 내부 컨테이너 색상
                              ),
                              alignment: Alignment.center,
                              // 텍스트 중앙 정렬
                              child: Text(
                                '3',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
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
                      Container(
                        width: 360,
                        height: 85,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 32, left: 16, right: 16),
                          child: Column(
                            // 텍스트 부분에 Column 추가
                            children: [
                              Container(
                                width: 328,
                                height: 28,
                                child: Text(
                                  '희망하시는 계절감을 골라주세요',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                    letterSpacing: -0.50,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8), // 사이즈 박스 추가
                              Container(
                                width: 328,
                                height: 17,
                                child: Text(
                                  '고객님이 선택하신 계절감에 맞게 아이템을 추천해드릴게요',
                                  // 원하는 텍스트로 변경 가능
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                    letterSpacing: -0.30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 360,
                        height: 56,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 24, left: 16, right: 16),
                          child: Row(
                            // 텍스트 부분에 Column 추가
                            children: [
                              _buildCustomButton(0, '봄'),
                              SizedBox(width: 8),
                              _buildCustomButton(1, '여름'),
                              SizedBox(width: 8),
                              _buildCustomButton(2, '가을'),
                              SizedBox(width: 8),
                              _buildCustomButton(3, '겨울'),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 360,
                        height: 85,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 32, left: 16, right: 16),
                          child: Column(
                            // 텍스트 부분에 Column 추가
                            children: [
                              Container(
                                width: 328,
                                height: 28,
                                child: Text(
                                  '희망하시는 금액을 골라주세요',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                    letterSpacing: -0.50,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8), // 사이즈 박스 추가
                              Container(
                                width: 328,
                                height: 17,
                                child: Text(
                                  '너무 낮은 금액은 분석 거절 사유가 될 수도 있어요',
                                  // 원하는 텍스트로 변경 가능
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                    letterSpacing: -0.30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 360,
                        height: 66,
                        padding:
                            const EdgeInsets.only(top: 24, left: 16, right: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // 세로 중앙 정렬
                          children: [
                            Container(
                              width: 328,
                              height: 42,
                              color: Color(0xFFF6F6F6),
                              // 배경 색상 예시
                              alignment: Alignment.center,
                              // 텍스트를 중앙에 배치
                              child: Container(
                                width: 282,
                                height: 14,
                                child: TextField(
                                  controller: quotationPriceController, // 컨트롤러 설정
                                  decoration: InputDecoration(
                                    hintText: 'ex) 100,000', // 힌트 텍스트
                                    hintStyle: TextStyle(
                                      color: Color(0xFFB0B0B0),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                      letterSpacing: -0.35,
                                    ),
                                    border: InputBorder.none, // 테두리 없애기
                                  ),
                                  style: TextStyle(
                                    color: Colors.black, // 입력된 텍스트 색상
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
                                    LengthLimitingTextInputFormatter(9), // 최대 글자 수 9로 제한
                                  ],
                                  onChanged: (value) {
                                    Quotationpirce = value; // 입력값을 변수에 저장
                                  },
                                ),
                              ),

                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 360,
                        height: 85,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 32, left: 16, right: 16),
                          child: Column(
                            // 텍스트 부분에 Column 추가
                            children: [
                              Container(
                                width: 328,
                                height: 28,
                                child: Text(
                                  '소화 가능한 패션 레벨을 알려주세요',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                    letterSpacing: -0.50,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8), // 사이즈 박스 추가
                              Container(
                                width: 328,
                                height: 17,
                                child: Text(
                                  '레벨에 따라서 패션 아이템의 디테일이 달라져요', // 원하는 텍스트로 변경 가능
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                    letterSpacing: -0.30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 328,
                        height: 312,
                        padding:
                            const EdgeInsets.only(top: 24, left: 16, right: 16),
                        child: Column(
                          children: [
                            _buildCustomButton2(0, '간단', '기본 아이템을 활용한 간단한 조합'),
                            SizedBox(height: 16), // 사이즈 박스
                            _buildCustomButton2(1, '조합', '다양한 스타일의 아이템을 조합하여 개성을 표현'),
                            SizedBox(height: 16), // 사이즈 박스
                            _buildCustomButton2(2, '활용', '트렌드를 반영한 세련된 레이어링과 액세서리 활용'),
                            SizedBox(height: 16), // 사이즈 박스
                            _buildCustomButton2(3, '구축', '패션의 모든 요소를 활용하여 독창적인 스타일 구축'),
                          ],
                        ),
                      ),
                      Container(
                        width: 360,
                        height: 85,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 32, left: 16, right: 16),
                          child: Column(
                            // 텍스트 부분에 Column 추가
                            children: [
                              Container(
                                width: 328,
                                height: 28,
                                child: Text(
                                  '추가로 전달하고 싶은 정보 (선택)',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                    letterSpacing: -0.50,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8), // 사이즈 박스 추가
                              Container(
                                width: 328,
                                height: 17,
                                child: Text(
                                  '스타일리스트가 참고할만한 추가 사항이 있을까요?',
                                  // 원하는 텍스트로 변경 가능
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                    letterSpacing: -0.30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 360,
                        height: 356,
                        padding: EdgeInsets.only(
                            top: 24, left: 16, right: 16, bottom: 48),
                        child: Container(
                          width: 328,
                          height: 284,
                          // 내부 컨테이너 크기
                          color: Color(0xFFF6F6F6),
                          padding: EdgeInsets.only(
                              top: 16, left: 16, right: 16, bottom: 16),
                          // 패딩 설정
                          child: Container(
                            width: 296,
                            height: 252, // 새로 추가한 컨테이너 크기
                            child: TextField(
                              controller: quotationinformationController, // 컨트롤러 설정
                              maxLines: null, // 여러 줄 입력 가능
                              decoration: InputDecoration(
                                hintText: '내용을 입력하세요\n\n금지 행위\n-타인의 권리를 침해하거나 불쾌감을 주는 행위\n-범죄, 불법, 행위 등 법령을 위반하는 행위\n-욕설, 비하, 차별, 혐오, 자살, 폭력 관련 내용을\n포함한 내용을 작성하는 행위\n    -음란물, 성적 수치심을 유발하는 행위\n    -스포일러, 공포, 속임, 놀라게 하는 내용\n\n등을 작성하는 분은 영구적으로 회원자격이 해지되며,\n관련 법률에 따라 처벌받을 수 있습니다.',
                                hintStyle: TextStyle(
                                  color: Color(0xFFB0B0B0),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  letterSpacing: -0.35,
                                ),
                                border: InputBorder.none, // 테두리 없애기
                              ),
                              style: TextStyle(
                                color: Color(0xFF3D3D3D),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                              onChanged: (value) {
                                Quotationinformation = value; // 입력값을 변수에 저장
                              },
                            ),
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
        bottomNavigationBar: Container(
          width: double.infinity, // 전체 너비 사용
          height: 66,
          padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Test3(
                              designerId: '',
                            )), // Test3 화면으로 이동
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  // 버튼 배경색
                  side: BorderSide(width: 1, color: Color(0xFFE7E7E7)),
                  // 테두리 설정
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  minimumSize: Size(154, 42), // 버튼 크기
                ),
                child: Text(
                  '이전',
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

              SizedBox(width: 20), // 버튼 사이 간격
              TextButton(
                onPressed: () {
                  print("다음없음");
                  _saveSeasonToFirebase();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF3D3D3D), // 버튼 배경색
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  minimumSize: Size(154, 42), // 버튼 크기
                ),
                child: Text(
                  '다음',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF6F6F6),
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    letterSpacing: -0.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(int index, String text) {
    bool isSelected = _selectedIndex1 == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex1 = index;
        });
        print('$text 버튼 클릭됨!');
      },
      borderRadius: BorderRadius.circular(100),
      splashColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.transparent,
      child: Container(
        height: 32,
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 11),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF3D3D3D) : Colors.transparent,
          border: isSelected
              ? Border.all(width: 1, color: Color(0xFF3D3D3D))
              : Border.all(width: 1, color: Color(0xFFE7E7E7)),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.1,
              letterSpacing: -0.35,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton2(int index, String text, String description) {
    bool isSelected = _selectedIndex2 == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex2 = index;
        });
        print('$text 버튼 클릭됨!');
      },
      child: Container(
        width: 328,
        height: 60,
        padding: EdgeInsets.only(top: 11, bottom: 11, left: 16, right: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF3D3D3D) : Colors.transparent,
          border: Border.all(
            width: 1,
            color: isSelected ? Color(0xFF3D3D3D) : Color(0xFFE7E7E7),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Container(
              width: 296,
              height: 16,
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF3D3D3D),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  letterSpacing: -0.40,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 296,
              height: 12,
              child: Text(
                description,
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  letterSpacing: -0.40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class QuotationImgSelectAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const QuotationImgSelectAppBar({Key? key}) : super(key: key);

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
                onPressed: () {},
                icon: Icon(Icons.arrow_back),
                iconSize: 24,
                color: Colors.black,
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 248,
                height: 56,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '견적서 작성',
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
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.refresh),
                iconSize: 24,
                color: Colors.black,
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
