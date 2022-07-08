import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/auth_controller.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photo_memo.dart';
import 'package:lesson3/viewscreen/signup_screen.dart';
import 'package:lesson3/viewscreen/userhome_screen.dart';
import 'package:lesson3/viewscreen/view/view_util.dart';

class StartScreen extends StatefulWidget {
  static const routeName = '/startScreen';

  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StartState();
  }
}

class _StartState extends State<StartScreen> {
  late _Controller con;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Photo Memo',
                style: Theme.of(context).textTheme.headline3,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validateEmail,
                onSaved: con.saveEmail,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                validator: con.validatePassword,
                onSaved: con.savePassword,
              ),
              ElevatedButton(
                onPressed: con.signin,
                child: Text('Sign In', style: Theme.of(context).textTheme.button),
              ),
              const SizedBox(height: 24.0,),
               OutlinedButton(
                onPressed: con.signUp,
                child: Text('Create New Account', style: Theme.of(context).textTheme.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _StartState state;
  String? email;
  String? password;
  _Controller(this.state);

  void signUp(){
    Navigator.pushNamed(state.context, SignUpScreen.routeName);
  }

  void signin() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    startCircularProgress(state.context);

    User? user;

    try {
      if (email == null || password == null) {
        throw 'Email or Password is null';
      }
      user = await AuthController.signIn(email: email!, password: password!);

      List <PhotoMemo> photoMemoList = await FirestoreController.getPhotoMemoList(email: email!);

     stopCircularProgress(state.context);

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        state.context,
        UserHomeScreen.routeName,
        arguments: {
          Argkey.user: user,
          Argkey.photoMemoList: photoMemoList,
        },
      );
    } catch (e) {
      stopCircularProgress(state.context);
      if (Constant.devMode) print('********** Sign In Error: $e');
      showSnackBar(
          context: state.context, seconds: 20, message: 'Sign In Error: $e');
    }
  }

  String? validateEmail(String? value) {
    if (value == null) {
      return 'No Email Provided';
    } else if (!(value.contains('@') && value.contains('.'))) {
      return 'Invalid Email format';
    } else {
      return null;
    }
  }

  void saveEmail(String? value) {
    if (value != null) {
      email = value;
    }
  }

  String? validatePassword(String? value) {
    if (value == null) {
      return 'password is not provided';
    } else if (value.length < 6) {
      return 'password is too short';
    } else {
      return null;
    }
  }

  void savePassword(String? value) {
    if (value != null) {
      password = value;
    }
  }
}
