import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photo_memo.dart';
import 'package:lesson3/viewscreen/view/web_image.dart';

import 'comment/add_edit_comment.dart';

class SharedWithScreen extends StatelessWidget {
  static const routeName = '/sharedWithScreen';

  final User user;
  final List<PhotoMemo> photoMemoList;

  const SharedWithScreen(
      {required this.user, required this.photoMemoList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared With:  ${user.email}'),
      ),
      body: SingleChildScrollView(
        child: photoMemoList.isEmpty
            ? Text(
                'No PhotoMemo Shared With Me',
                style: Theme.of(context).textTheme.headline6,
              )
            : Column(
                children: [
                  for (var photoMemo in photoMemoList)
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Center(
                                  child: WebImage(
                                    url: photoMemo.photoURL,
                                    context: context,
                                    height: MediaQuery.of(context).size.height * 0.3,
                                  ),
                                ),
                                Positioned(
                                    left: 320,
                                    top: 10,
                                    child: IconButton(
                                      onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  AddEditComment(docid: photoMemo.docId.toString(),)),
                                        );
                                      },
                                      icon: Icon(
                                  Icons.comment
                                ),
                                    ))
                              ],
                            ),
                            Text(
                              photoMemo.title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(photoMemo.memo),
                            Text('Created By: ${photoMemo.createdBy}'),
                            Text('Created At: ${photoMemo.timestamp}'),
                            Text('Shared With: ${photoMemo.sharedWith}'),
                            Constant.devMode
                                ? Text('Image Labels: ${photoMemo.imageLabels}')
                                : const SizedBox(
                                    height: 1.0,
                                  ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
