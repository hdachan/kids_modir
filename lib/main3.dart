import 'package:flutter/material.dart';






void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World App',
      home: Scaffold(
        appBar: HomeAppBar(), // HomeAppBar 사용
        body: Center(
          child: Text(
            'Hello, World!',
            style: TextStyle(fontSize: 24),
          ),
        ),
        bottomNavigationBar: CustomBottomAppBar(), // CustomBottomAppBar 사용
      ),
    );
  }
}

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
                    Icons.notifications, // 알림 아이콘
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

class CustomBottomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0, // 그림자 효과 제거
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(left: 16,bottom: 12,top: 8),
          width: 360,
          height: 68,
          color: Colors.red,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 48,
                color: Colors.blue, // 원하는 색상으로 변경
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(360, 68); // 바텀바 사이즈 설정
}

//잠시 적어둔거
//class HomeScreen extends StatelessWidget {
// @override // 홈스크린 바뀌기전
// Widget build(BuildContext context) {
//   return DefaultTabController(
//     length: 3,
//     child: Scaffold(
//       appBar: HomeAppBar(),
//     ),
//   );
// }
//}
//
//
////홈 >> 메인 / 커뮤니티 / 매거진
//class HomeScreen extends StatelessWidget {
// @override
// Widget build(BuildContext context) {
//   return DefaultTabController(
//     length: 3,
//     child: Scaffold(
//       appBar: HomeAppBar(),
//       body: TabBarView(
//         children: [
//           Center(child: Text('메인 화면 내용')),
//           CommunityTab(),
//           Center(child: Text('매거진 화면 내용')),
//         ],
//       ),
//     ),
//   );
// }
//}
//
//// 홈 >> 커뮤니티
//class CommunityTab extends StatelessWidget {
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('posts')
//           .orderBy('timestamp', descending: true)
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return ListView(
//           children: snapshot.data!.docs.map((document) {
//             var data = document.data() as Map<String, dynamic>?;
//             String imageUrl = (data != null && data['imageUrl'] != null)
//                 ? data['imageUrl'] as String
//                 : '';
//
//             return FutureBuilder(
//               future: Future.wait([
//                 document.reference.collection('likes').get(),
//                 document.reference.collection('comments').get(),
//               ]),
//               builder: (context,
//                   AsyncSnapshot<List<QuerySnapshot>> countsSnapshot) {
//                 if (!countsSnapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 int likesCount = countsSnapshot.data![0].docs.length;
//                 int commentsCount = countsSnapshot.data![1].docs.length;
//
//                 return ListTile(
//                   title: Text(data?['title'] ?? '제목 없음'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(data?['content'] ?? '내용 없음'),
//                       if (imageUrl.isNotEmpty)
//                         Image.network(
//                           imageUrl,
//                           width: 100, // 원하는 너비 지정
//                           height: 100, // 원하는 높이 지정
//                           fit: BoxFit.cover, // 이미지 비율 유지하며 크기 조절
//                         ),
//                       Text(
//                         DateFormat('yyyy-MM-dd – kk:mm').format(
//                           (data?['timestamp'] as Timestamp).toDate(),
//                         ),
//                         style: TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.favorite, color: Colors.red, size: 16),
//                           SizedBox(width: 4),
//                           Text('$likesCount'),
//                           SizedBox(width: 16),
//                           Icon(Icons.comment, color: Colors.grey, size: 16),
//                           SizedBox(width: 4),
//                           Text('$commentsCount'),
//                         ],
//                       ),
//                     ],
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PostDetail(post: document),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }).toList(),
//         );
//       },
//     ),
//   );
// }
//}
//
////글쓰기 버튼을 눌렀을때 생명주기
//class NewPostDialog extends StatefulWidget {
// @override
// _NewPostDialogState createState() => _NewPostDialogState();
//}
//
////글쓰기 버튼을 눌렀을때 나오는 위젯 /기능
//class _NewPostDialogState extends State<NewPostDialog> {
// final TextEditingController titleController = TextEditingController();
// final TextEditingController contentController = TextEditingController();
// File? _image;
// bool _isUploading = false;
//
// Future<void> _pickImage() async {
//   final pickedFile =
//   await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     setState(() {
//       _image = File(pickedFile.path);
//     });
//   }
// }
//
// Future<String?> _uploadImage(File image) async {
//   try {
//     final storageRef = FirebaseStorage.instance
//         .ref()
//         .child('posts/${DateTime.now().millisecondsSinceEpoch}.jpg');
//     final uploadTask = storageRef.putFile(image);
//     final snapshot = await uploadTask;
//
//     if (snapshot.state == TaskState.success) {
//       final downloadUrl = await snapshot.ref.getDownloadURL();
//       return downloadUrl;
//     } else {
//       return null;
//     }
//   } catch (e) {
//     print(e);
//     return null;
//   }
// }
//
// Future<void> _savePost() async {
//   setState(() {
//     _isUploading = true;
//   });
//
//   String? imageUrl;
//   if (_image != null) {
//     imageUrl = await _uploadImage(_image!);
//   }
//
//   if (imageUrl != null || _image == null) {
//     await FirebaseFirestore.instance.collection('posts').add({
//       'title': titleController.text,
//       'content': contentController.text,
//       'imageUrl': imageUrl,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
//
//   setState(() {
//     _isUploading = false;
//   });
//
//   Navigator.of(context).pop();
// }
//
// @override
// Widget build(BuildContext context) {
//   return AlertDialog(
//     title: Text('새 글 작성'),
//     content: SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: titleController,
//             decoration: InputDecoration(labelText: '제목'),
//           ),
//           TextField(
//             controller: contentController,
//             decoration: InputDecoration(labelText: '내용'),
//           ),
//           SizedBox(height: 10),
//           _image == null ? Text('이미지가 선택되지 않았습니다.') : Image.file(_image!),
//           TextButton(
//             onPressed: _pickImage,
//             child: Text('갤러리에서 사진 선택'),
//           ),
//         ],
//       ),
//     ),
//     actions: [
//       TextButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         child: Text('취소'),
//       ),
//       TextButton(
//         onPressed: _isUploading ? null : _savePost,
//         child: _isUploading ? CircularProgressIndicator() : Text('저장'),
//       ),
//     ],
//   );
// }
//}
//
////포스터를 눌렀을때 생명주기
//class PostDetail extends StatefulWidget {
// final DocumentSnapshot post;
//
// PostDetail({required this.post});
//
// @override
// _PostDetailState createState() => _PostDetailState();
//}
//
////포스터를 눌렀을때 나오는 화면
//class _PostDetailState extends State<PostDetail> {
// late Map<String, dynamic> data;
// String imageUrl = '';
// bool isLiked = false;
// int likesCount = 0;
// User? currentUser;
// List<String> likedEmails = [];
// List<Map<String, dynamic>> comments = [];
// TextEditingController commentController = TextEditingController();
//
// @override
// void initState() {
//   super.initState();
//   data = widget.post.data() as Map<String, dynamic>;
//   imageUrl = data['imageUrl'] ?? '';
//   likesCount = data['likesCount'] ?? 0;
//   currentUser = FirebaseAuth.instance.currentUser;
//
//   if (currentUser != null) {
//     checkIfLiked();
//     fetchLikedEmails();
//   }
//   fetchComments();
// }
//
// void checkIfLiked() async {
//   DocumentSnapshot userLikeDoc = await widget.post.reference
//       .collection('likes')
//       .doc(currentUser!.uid)
//       .get();
//
//   setState(() {
//     isLiked = userLikeDoc.exists;
//   });
// }
//
// void fetchLikedEmails() async {
//   QuerySnapshot likesSnapshot =
//   await widget.post.reference.collection('likes').get();
//
//   setState(() {
//     likedEmails =
//         likesSnapshot.docs.map((doc) => doc['email'] as String).toList();
//   });
// }
//
// void fetchComments() async {
//   QuerySnapshot commentsSnapshot = await widget.post.reference
//       .collection('comments')
//       .orderBy('timestamp', descending: true)
//       .get();
//
//   setState(() {
//     comments = commentsSnapshot.docs
//         .map((doc) => doc.data() as Map<String, dynamic>)
//         .toList();
//   });
// }
//
// void addComment() async {
//   if (currentUser == null || commentController.text.isEmpty) return;
//
//   DocumentReference commentRef =
//   widget.post.reference.collection('comments').doc();
//
//   await commentRef.set({
//     'content': commentController.text,
//     'author': currentUser!.email,
//     'timestamp': FieldValue.serverTimestamp(),
//   });
//
//   commentController.clear();
//   fetchComments();
// }
//
// void toggleLike() async {
//   if (currentUser == null) return;
//
//   DocumentReference likeRef =
//   widget.post.reference.collection('likes').doc(currentUser!.uid);
//
//   if (isLiked) {
//     await likeRef.delete();
//     setState(() {
//       isLiked = false;
//       likesCount--;
//       likedEmails.remove(currentUser!.email);
//     });
//   } else {
//     await likeRef.set({
//       'likedAt': FieldValue.serverTimestamp(),
//       'email': currentUser!.email,
//     });
//     setState(() {
//       isLiked = true;
//       likesCount++;
//       likedEmails.add(currentUser!.email!);
//     });
//   }
//
//   widget.post.reference.update({'likesCount': likesCount});
// }
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(data['title'] ?? '제목 없음'),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             data['title'] ?? '제목 없음',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
//           Text(
//             DateFormat('yyyy-MM-dd – kk:mm').format(
//               (data['timestamp'] as Timestamp).toDate(),
//             ),
//             style: TextStyle(fontSize: 12, color: Colors.grey),
//           ),
//           SizedBox(height: 8),
//           if (imageUrl.isNotEmpty)
//             Image.network(
//               imageUrl,
//               width: 300, // 원하는 너비 설정
//               height: 300, // 원하는 높이 설정
//               fit: BoxFit.cover, // 이미지가 지정된 크기에 맞게 조정되도록 설정
//             ),
//           SizedBox(height: 8),
//           Text(data['content'] ?? '내용 없음'),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       isLiked ? Icons.favorite : Icons.favorite_border,
//                       color: isLiked ? Colors.red : Colors.grey,
//                     ),
//                     onPressed: toggleLike,
//                   ),
//                   Text('좋아요: $likesCount'),
//                 ],
//               ),
//               Text('댓글: ${comments.length}'),
//             ],
//           ),
//           SizedBox(height: 16),
//           Expanded(
//             child: ListView.builder(
//               itemCount: comments.length,
//               itemBuilder: (context, index) {
//                 final comment = comments[index];
//                 return ListTile(
//                   title: Text(comment['content']),
//                   subtitle: Text(comment['author']),
//                   trailing: Text(
//                     DateFormat('yyyy-MM-dd – kk:mm').format(
//                       (comment['timestamp'] as Timestamp).toDate(),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           TextField(
//             controller: commentController,
//             decoration: InputDecoration(
//               labelText: '댓글 입력',
//             ),
//           ),
//           SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: addComment,
//             child: Text('댓글 달기'),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//}
//
//// 글을 클릭했을때 나오는 생명주기
//class PostClick extends StatefulWidget {
// final DocumentSnapshot post;
//
// PostClick({required this.post});
//
// @override
// _PostClickState createState() => _PostClickState();
//}
//
//// 글을 클릭했을때 나오는 위젯 / 기능
//class _PostClickState extends State<PostClick> {
// late Map<String, dynamic> data;
// String imageUrl = '';
// bool isLiked = false;
// int likesCount = 0;
// User? currentUser;
//
// @override
// void initState() {
//   super.initState();
//   data = widget.post.data() as Map<String, dynamic>;
//   imageUrl = data['imageUrl'] ?? '';
//   likesCount = data['likesCount'] ?? 0;
//   currentUser = FirebaseAuth.instance.currentUser;
//
//   if (currentUser != null) {
//     checkIfLiked();
//   }
// }
//
// void checkIfLiked() async {
//   DocumentSnapshot userLikeDoc = await widget.post.reference
//       .collection('likes')
//       .doc(currentUser!.uid)
//       .get();
//
//   setState(() {
//     isLiked = userLikeDoc.exists;
//   });
// }
//
// void toggleLike() async {
//   if (currentUser == null) return;
//
//   DocumentReference likeRef =
//   widget.post.reference.collection('likes').doc(currentUser!.uid);
//
//   if (isLiked) {
//     await likeRef.delete();
//     setState(() {
//       isLiked = false;
//       likesCount--;
//     });
//   } else {
//     await likeRef.set({
//       'likedAt': FieldValue.serverTimestamp(),
//       'email': currentUser!.email,
//       'postId': widget.post.id,
//     });
//     setState(() {
//       isLiked = true;
//       likesCount++;
//     });
//   }
//
//   widget.post.reference.update({'likesCount': likesCount});
// }
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(data['title'] ?? '제목 없음'),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             data['title'] ?? '제목 없음',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
//           Text(
//             DateFormat('yyyy-MM-dd – kk:mm').format(
//               (data['timestamp'] as Timestamp).toDate(),
//             ),
//             style: TextStyle(fontSize: 12, color: Colors.grey),
//           ),
//           SizedBox(height: 8),
//           if (imageUrl.isNotEmpty) Image.network(imageUrl),
//           SizedBox(height: 8),
//           Text(data['content'] ?? '내용 없음'),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       isLiked ? Icons.favorite : Icons.favorite_border,
//                       color: isLiked ? Colors.red : Colors.grey,
//                     ),
//                     onPressed: toggleLike,
//                   ),
//                   Text('좋아요: $likesCount'),
//                 ],
//               ),
//               Text('댓글: ${data['commentsCount'] ?? 0}'),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
//}

