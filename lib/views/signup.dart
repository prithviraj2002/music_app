import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_app/appwrite/appwrite_auth.dart';
import 'package:music_app/consts/colors.dart';
import 'package:music_app/consts/text_style.dart';
import 'package:music_app/views/home.dart';
import 'package:music_app/views/login.dart';
import 'package:uuid/uuid.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

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
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.only(top: 20),
            color: bgColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already a user?", style: TextStyle(color: whiteColor, fontSize: 18),),
                    const SizedBox(width: 4,),
                    InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => AuthScreen()), (route) => false);
                        },
                        child: Text("Login", style: TextStyle(color: whiteColor, decoration: TextDecoration.underline, decorationColor: whiteColor, fontSize: 18),))
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
                    Image.asset("assets/signup.png", scale: 3,),
                    const SizedBox(height: 20,),
                    Align(alignment: Alignment.topLeft ,child: Text("Sign up", style: ourStyle(color: bgColor, size: 24),)),
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
                      obscureText: isPasswordVisible,
                      validator: (String? val) {
                        if (val == null && val!.isEmpty) {
                          return "Cannot have empty password";
                        } else if(val.length < 8){
                          return "Password less than 8 characters";
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: whiteColor)),
                          labelText: "Password",
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        }, icon: isConfirmPasswordVisible ? Icon(Icons.lock_open) : Icon(Icons.lock_outline))
                      ),
                    ),
                    const SizedBox(height: 12,),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: isConfirmPasswordVisible,
                      validator: (String? val) {
                        if (val == null && val!.isEmpty) {
                          return "Cannot have empty password";
                        }
                        else if(passwordController.text != val){
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: whiteColor)),
                          labelText: "Confirm Password",
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible = !isConfirmPasswordVisible;
                          });
                        }, icon: isConfirmPasswordVisible ?  Icon(Icons.lock_open): Icon(Icons.lock_outline))
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isLoading ? const CircularProgressIndicator(color: bgColor,) : OutlinedButton(
                        onPressed: () {
                          final box = GetStorage();
                          if(formKey.currentState!.validate() && confirmPasswordController.text == passwordController.text){
                            try{
                              final id = Uuid().v4();
                              AuthProvider.account.create(
                                  userId: id,
                                  email: emailController.text,
                                  password: passwordController.text
                              );
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Home()), (route) => false);
                              box.write("userId", id);
                              toggleLoading();
                            } on Exception catch(e){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred!: $e")));
                              toggleLoading();
                            }
                          }
                        }, child: const Text("Signup")),
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
