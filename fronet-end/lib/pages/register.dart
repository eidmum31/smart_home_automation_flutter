import "package:email_validator/email_validator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";

import "../components/button.dart";
import "../components/text_field.dart";
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController=TextEditingController();
  final passwordTextController=TextEditingController();
  final confirmPasswordTextController=TextEditingController();

  void signUp() async{
    showDialog(context: context, builder: (context)=>const Center(
      child: CircularProgressIndicator(),
    ));

    if(passwordTextController.text.isEmpty&&emailTextController.text.isEmpty&&confirmPasswordTextController.text.isEmpty){
      Navigator.pop(context);
      displayMessage("Please enter email , password and confirm password");
      return;
    }
    if(emailTextController.text.isEmpty&&passwordTextController.text.isEmpty){
      Navigator.pop(context);
      displayMessage("Email and password are empty");
      return;
    }
    if(confirmPasswordTextController.text.isEmpty&&passwordTextController.text.isEmpty){
      Navigator.pop(context);
      displayMessage("Password and confirm password are empty");
      return;
    }
    if(emailTextController.text.isEmpty&&confirmPasswordTextController.text.isEmpty){
      Navigator.pop(context);
      displayMessage("Email and confirm password are empty");
      return;
    }
    if(emailTextController.text.isEmpty){
      Navigator.pop(context);
      displayMessage("Emails are required");
      return;
    }
    if(passwordTextController.text.isEmpty){
      Navigator.pop(context);
      displayMessage("Please enter password");
      return;
    }
    if(confirmPasswordTextController.text.isEmpty){
      Navigator.pop(context);
      displayMessage("Please confirm password");
      return;
    }


    if(!EmailValidator.validate(emailTextController.text)){
      Navigator.pop(context);
      displayMessage("Please Enter a valid email");
      return;

    }
    if(passwordTextController.text!=confirmPasswordTextController.text){
      Navigator.pop(context);
      displayMessage("Password and confirm password does not match");
      return;
    }

    if(passwordTextController.text.length<6){
      Navigator.pop(context);
      displayMessage("Passwords must be 6 characters long");
      return;
    }




    try{
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(Icons.lock,
                  size: 100,
                ),
                SizedBox(height: 30,),
                Text("Let's create an account!"),
                SizedBox(height: 15,),

                MyTextField(controller: emailTextController, hintText: "Email", obscureText: false),
                SizedBox(height: 7,),
                MyTextField(controller: passwordTextController, hintText: "Password", obscureText: true),
                SizedBox(height: 7,),
                MyTextField(controller: confirmPasswordTextController, hintText: "Confirm password", obscureText: true),
                SizedBox(height: 7,),
                MyButton(onTap: signUp, text: "Sign Up"),
                SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text("Alreay have an account?"),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login here",
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
