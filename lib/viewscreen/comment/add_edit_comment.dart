import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../controller/firestore_controller.dart';
import '../../model/constant.dart';
class AddEditComment extends StatefulWidget {

  final String docid;
  const AddEditComment({Key? key,required this.docid}) : super(key: key);

  @override
  State<AddEditComment> createState() => _AddEditCommentState();
}

class _AddEditCommentState extends State<AddEditComment> {

  TextEditingController comment = TextEditingController();
  var usersQuery;

  @override
  void initState() {

    usersQuery =FirebaseFirestore.instance.collection(Constant.photoMemoCollection).doc(widget.docid).collection(Constant.commentsCollection).orderBy('time');
    // TODO: implement initState


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: comment,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: (){
                  },
                  icon: IconButton(
                    onPressed: () async{
                     if(comment!=null && comment.text!=''){
                       Map<String, dynamic> update ={
                         "comment" :comment.text,
                         "time" :  DateTime.now(),
                         "by" : FirebaseAuth.instance.currentUser!.email.toString(),
                       };

                       await FirestoreController.addCommentToPhoto(docId: widget.docid, update: update);


                       setState(() {
                         comment.clear();
                       });

                     }

                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  ),
                ),
                hintText: 'Write your Comment'

              ),
            ),
            SizedBox(height: 15,),
            Text('Old Comments',style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),),
            Expanded(
              child: FirestoreListView<Map<String, dynamic>>(
                query: usersQuery,
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (context, snapshot) {
                  Map<String, dynamic> user = snapshot.data();

                  return Container(
                    margin: EdgeInsets.only(left: 20,bottom: 10),
                    child: Row(
                      children: [
                        Icon(Icons.comment),
                        SizedBox(width: 10,),
                        Text(user['comment'],style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black
                        ),)
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
