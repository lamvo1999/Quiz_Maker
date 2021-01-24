import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/helper/functions.dart';
import 'package:quiz_maker/services/auth.dart';

import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/views/signup.dart';
import 'package:quiz_maker/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthService authService = new AuthService();
  final passwordControlaer = TextEditingController();
  final passwordFocusNode = FocusNode();
  String animationType = "idle";

  @override
  void initState() {
    // TODO: implement initState
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        setState(() {
          animationType = "test";
        });
      } else {
        setState(() {
          animationType = "idle";
        });
      }
    });
    super.initState();
  }

  bool _isLoading = false;

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.signInEmailAndPass(email, password).then((val) {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedin: true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 300,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: FlareActor(
                            "assets/images/teddy.flr",
                            fit: BoxFit.contain,
                            animation: "success",
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 300,
                          height: 300,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: FlareActor(
                                "assets/images/teddy.flr",
                                fit: BoxFit.contain,
                                animation: animationType,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(right: 20, left: 20, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          validator: (val) {
                            return val.isEmpty ? "Nhập Email" : null;
                          },
                          decoration: InputDecoration(
                            hintText: " Email",
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.mail_outline,
                            ),
                          ),
                          onChanged: (val) {
                            email = val;
                          },
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: passwordControlaer,
                          focusNode: passwordFocusNode,
                          obscureText: true,
                          validator: (val) {
                            return val.isEmpty ? "Nhập Mật Khẩu" : null;
                          },
                          decoration: InputDecoration(
                            hintText: " Password",
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                            ),
                          ),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30)),
                          alignment: AlignmentDirectional.center,
                          width: MediaQuery.of(context).size.width - 48,
                          child: Text(
                            "Đăng Nhập",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Không có tài khoản ?",
                            style: TextStyle(
                              fontSize: 15.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              " Đăng Ký.",
                              style: TextStyle(
                                  fontSize: 15.5,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
