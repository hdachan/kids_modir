// // 기능화면 상태관리
// class CoreFunctionalityScreen extends StatefulWidget {
//   @override
//   _BookmarkScreenState createState() => _BookmarkScreenState();
// }
//
// // 기능화면
// class _BookmarkScreenState extends State<CoreFunctionalityScreen> {
//   int _selectedIndex = 0;
//   String _selectedCategory = '전체';
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<String> _names = [];
//   List<String> _introductions = [];
//   List<String> classification = [];
//   List<String> _prices = [];
//   List<String> _imageUrls = [];
//   List<String> _designerIds = [];
//   List<int> _reviewCounts = [];
//   List<String> _titles = [];
//   List<String> _gender = [];
//
//   @override // 처음생성될때 위젯들을 불러옴
//   void initState() {
//     super.initState();
//     _fetchDesignerData();
//   }
//
//   Future<void> _fetchDesignerData() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('designer').get();
//       print('Documents fetched: ${snapshot.docs.length}'); // 문서 수 로그
//
//       setState(() {
//         _designerIds = snapshot.docs.map((doc) => doc.id).toList();
//         _names = snapshot.docs.map((doc) => doc['name'] as String).toList();
//         _introductions =
//             snapshot.docs.map((doc) => doc['introduction'] as String).toList();
//         classification = snapshot.docs
//             .map((doc) => doc['classification'] as String)
//             .toList();
//         _prices = snapshot.docs.map((doc) => doc['price'].toString()).toList();
//         _imageUrls =
//             snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
//         _titles = snapshot.docs.map((doc) => doc['title'] as String).toList();
//         _gender = snapshot.docs.map((doc) => doc['gender'] as String).toList();
//         _reviewCounts = snapshot.docs.map((doc) {
//           // reviewCount가 문자열일 경우 변환
//           var reviewCountValue = doc['reviewCount'];
//           if (reviewCountValue is String) {
//             return int.tryParse(reviewCountValue) ?? 0; // 변환 실패 시 0 반환
//           }
//           return reviewCountValue as int; // int로 간주
//         }).toList();
//       });
//     } catch (e) {
//       print('Error fetching designer data: $e'); // 오류 로그
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: HomeAppBar(),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Center(
//                   child: Container(
//                     width: 360,
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 56,
//                           width: 360,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 16, right: 16, top: 12, bottom: 12),
//                             child: Row(
//                               children: [
//                                 _buildButton(0, '전체', 48),
//                                 SizedBox(width: 8),
//                                 _buildButton(1, '인기순', 78),
//                                 SizedBox(width: 8),
//                                 _buildButton(2, '분야', 66),
//                                 SizedBox(width: 8),
//                                 _buildButton(3, '성별', 66),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: 428,
//                           child: _buildListView(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(int index, String text, double width) {
//     bool isSelected = _selectedIndex == index;
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//         if (index == 0) {
//           _selectedCategory = '전체';
//         }
//         if (index == 2) {
//           _showCategoryBottomSheet();
//         }
//         print('$text 버튼 클릭됨!');
//       },
//       borderRadius: BorderRadius.circular(100),
//       splashColor: Colors.grey.withOpacity(0.5),
//       highlightColor: Colors.transparent,
//       child: Container(
//         height: 32,
//         width: width,
//         decoration: BoxDecoration(
//           color: isSelected ? Color(0xFF3D3D3D) : Colors.transparent,
//           border: isSelected
//               ? null
//               : Border.all(width: 1, color: Color(0xFFE7E7E7)),
//           borderRadius: BorderRadius.circular(100),
//         ),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 text,
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : Colors.black,
//                   fontSize: 14,
//                   fontFamily: 'Pretendard',
//                   fontWeight: FontWeight.w400,
//                   height: 1,
//                   letterSpacing: -0.35,
//                 ),
//               ),
//               if (index > 0) ...[
//                 SizedBox(width: 2),
//                 Icon(
//                   Icons.arrow_drop_down,
//                   color: isSelected ? Colors.white : Colors.black,
//                   size: 16,
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showCategoryBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 '카테고리 선택',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               ListTile(
//                 title: Text('전체'),
//                 onTap: () {
//                   setState(() {
//                     _selectedCategory = '전체';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text('빈티지'),
//                 onTap: () {
//                   setState(() {
//                     _selectedCategory = '빈티지';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text('아메카지'),
//                 onTap: () {
//                   setState(() {
//                     _selectedCategory = '아메카지';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text('포멀'),
//                 onTap: () {
//                   setState(() {
//                     _selectedCategory = '포멀';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//               SizedBox(height: 20),
//               TextButton(
//                 child: Text('닫기'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildListView() {
//     List<int> filteredIndices = [];
//     for (int i = 0; i < classification.length; i++) {
//       if (_selectedCategory == '전체' ||
//           classification[i].contains(_selectedCategory)) {
//         filteredIndices.add(i);
//       }
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             width: 1,
//             color: Color(0xFFE7E7E7),
//           ),
//         ),
//       ),
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: ClampingScrollPhysics(),
//         itemCount: filteredIndices.length,
//         itemBuilder: (context, index) {
//           final itemIndex = filteredIndices[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DesignerDetailScreen(
//                     designerId: _designerIds[itemIndex],
//                     name: _names[itemIndex],
//                     introduction: _introductions[itemIndex],
//                     classification: classification[itemIndex],
//                     price: _prices[itemIndex],
//                     imageUrl: _imageUrls[itemIndex],
//                     reviewCount: _reviewCounts[itemIndex],
//                     gender: _gender[itemIndex],
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.zero,
//                   border: Border(
//                       bottom: BorderSide(width: 1, color: Color(0xFFE7E7E7)))),
//               height: 128,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 96,
//                     height: 96,
//                     margin: EdgeInsets.only(right: 16.0, left: 16.0),
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: NetworkImage(_imageUrls[itemIndex]),
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _titles[itemIndex],
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                             fontFamily: 'Pretendard',
//                             fontWeight: FontWeight.w700,
//                             height: 1.2,
//                             letterSpacing: -0.35,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           _names[itemIndex],
//                           style: TextStyle(
//                             color: Color(0xFF5D5D5D),
//                             fontSize: 12,
//                             fontFamily: 'Pretendard',
//                             fontWeight: FontWeight.w400,
//                             height: 1.2,
//                             letterSpacing: -0.30,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Icon(Icons.star, size: 14, color: Colors.yellow),
//                             SizedBox(width: 4),
//                             Text(
//                               '4.9',
//                               style: TextStyle(
//                                 color: Color(0xFF5D5D5D),
//                                 fontSize: 12,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.2,
//                                 letterSpacing: -0.30,
//                               ),
//                             ),
//                             SizedBox(width: 2),
//                             Text(
//                               '(${_reviewCounts[itemIndex]})',
//                               style: TextStyle(
//                                 color: Color(0xFF5D5D5D),
//                                 fontSize: 12,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.2,
//                                 letterSpacing: -0.30,
//                               ),
//                             ),
//                             SizedBox(width: 4),
//                             Container(
//                               width: 1,
//                               height: 12,
//                               decoration:
//                               BoxDecoration(color: Color(0xFF888888)),
//                             ),
//                             SizedBox(width: 4),
//                             Text(
//                               '${classification[itemIndex]}',
//                               style: TextStyle(
//                                 color: Color(0xFF5D5D5D),
//                                 fontSize: 12,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.2,
//                                 letterSpacing: -0.30,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Text(
//                               '${_prices[itemIndex]}',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 14,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w600,
//                                 height: 1.3,
//                                 letterSpacing: -0.35,
//                               ),
//                             ),
//                             SizedBox(width: 4),
//                             Text(
//                               '원',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.3,
//                                 letterSpacing: -0.35,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }