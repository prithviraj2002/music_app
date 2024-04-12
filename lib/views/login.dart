import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_app/appwrite/appwrite_auth.dart';
import 'package:music_app/consts/colors.dart';
import 'package:music_app/consts/text_style.dart';
import 'package:music_app/views/home.dart';
import 'package:music_app/views/signup.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isVisible = false;

  void toggleLoading(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.only(top: 20),
            color: bgColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("New here?", style: TextStyle(color: whiteColor, fontSize: 18),),
                    const SizedBox(width: 4,),
                    InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Signup()), (route) => false);
                        },
                        child: Text("Sign up", style: TextStyle(color: whiteColor, decoration: TextDecoration.underline, decorationColor: whiteColor, fontSize: 18),))
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(50), right: Radius.circular(50))
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20,),
                    Image.asset("assets/login.png"),
                    const SizedBox(height: 20,),
                    Align(alignment: Alignment.topLeft ,child: Text("Login", style: ourStyle(color: bgColor, size: 24),)),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: emailController,
                      validator: (String? val) {
                        if (val == null && val!.isEmpty) {
                          return "Cannot have empty email";
                        } else if (!val.contains("@") &&
                            !val.contains(".com")) {
                          return "Invalid email id";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: whiteColor)),
                          labelText: "Email"),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isVisible,
                      validator: (String? val) {
                        if (val == null && val!.isEmpty) {
                          return "Cannot have empty password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: whiteColor)),
                          labelText: "Password",
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        }, icon: isVisible ? Icon(Icons.lock_open) : Icon(Icons.lock_outline))
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isLoading ? const CircularProgressIndicator(color: bgColor,) : OutlinedButton(
                        onPressed: () {
                          final box = GetStorage();
                          if(formKey.currentState!.validate()){
                            toggleLoading();
                            try{
                              AuthProvider.account.createEmailPasswordSession(email: emailController.text, password: passwordController.text).then((session) {
                                box.write("userId", session.userId);
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Home()), (route) => false);
                              });
                              toggleLoading();
                              Home();
                            } on Exception catch(e){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred!: $e")));
                              toggleLoading();
                            }
                          }
                        }, child: Text("Login")
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
