import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minima_do/components/helper_functions.dart';
import 'package:minima_do/components/minima_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage(
    {
      super.key,
      required this.onTap
    }
  );

  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void login() async{
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      )
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code, "error", context);
    }

  }

  @override
  Widget build(BuildContext context) {
    //var theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check, size: 80),
              
              const SizedBox(height: 20,),
              
              const Text("M I N I M A", style: TextStyle(fontSize: 20),),
              
              const SizedBox(height: 40,),
              
              MinimaField(hintText: "Email", obscureText: false, controller: emailController),
              
              const SizedBox(height: 10,),

              MinimaField(hintText: "Password", obscureText: true, controller: passwordController),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot password?", style: TextStyle(color: Colors.grey),),
                ],
              ),

              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: MinimaButton(text: "Login", onTap: login)
              ),

              const SizedBox(height: 15),

              GestureDetector(
                onTap: widget.onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account?"),
                    SizedBox(width: 5,),
                    Text("Sign up", style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

class MinimaButton extends StatelessWidget {
  const MinimaButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    
    return ElevatedButton(  
      onPressed: onTap,   
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.all(20)),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
    );
  }
}