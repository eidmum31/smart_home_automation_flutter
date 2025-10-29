

import "package:email_validator/email_validator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:mobileplatformfinal/components/button.dart";
import "package:mobileplatformfinal/components/text_field.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;



class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController=TextEditingController();
  final passwordController=TextEditingController();

  void signIn() async{
    showDialog(context: context, builder: (context)=>const Center(
      child: CircularProgressIndicator(),
    ));

    if(emailTextController.text.isEmpty && passwordController.text.isEmpty)
    {
      Navigator.pop(context);
      displayMessage("Please fillup both email and password");
      return;
    }
    if(emailTextController.text.isEmpty )
    {
      Navigator.pop(context);
      displayMessage("Please fillup email");
      return;
    }
    if(passwordController.text.isEmpty )
    {
      Navigator.pop(context);
      displayMessage("Please fillup password");
      return;
    }
    if(!EmailValidator.validate(emailTextController.text)){
      Navigator.pop(context);
      displayMessage("Please Enter a valid email");
      return;

    }

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailTextController.text, password: passwordController.text);
      if(context.mounted) Navigator.pop(context);
    }
    on FirebaseAuthException catch(e){
        Navigator.pop(context);
        displayMessage(e.code);
    }
  }
  void displayMessage(String message){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(message),
    ));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(Icons.lock,
                    size: 100,
                ),
                SizedBox(height: 50,),
                Text("Welcome back. You've been missed"),
                SizedBox(height: 25,),

                MyTextField(controller: emailTextController, hintText: "Email", obscureText: false),
                SizedBox(height: 10,),
                MyTextField(controller: passwordController, hintText: "password", obscureText: true),
                SizedBox(height: 10,),
                MyButton(onTap: signIn, text: "Sign In"),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text("Not A Member?"),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
