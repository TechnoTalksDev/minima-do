import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minima_do/components/helper_functions.dart';
import 'package:minima_do/components/minima_field.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordConfirmController = TextEditingController();

  void register() async{
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      )
    );

  
    if (passwordController.text != passwordConfirmController.text) {
      Navigator.pop(context);

      displayMessage("Passwords do not match", "error",context);
    }else {

      try {
        UserCredential? userCreds = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text, );
        Navigator.pop(context);
        widget.onTap!();
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessage(e.code, "error", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
              
              MinimaField(hintText: "Username", obscureText: false, controller: usernameController),
              
              const SizedBox(height: 10,),

              MinimaField(hintText: "Email", obscureText: false, controller: emailController),
              
              const SizedBox(height: 10,),

              MinimaField(hintText: "Password", obscureText: true, controller: passwordController),

              const SizedBox(height: 10,),

              MinimaField(hintText: "Confirm password", obscureText: true, controller: passwordConfirmController),  

              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: MinimaButton(text: "Register", onTap: register)
              ),
                const SizedBox(height: 15),

              GestureDetector(
                onTap: widget.onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    SizedBox(width: 5,),
                    Text("Login", style: TextStyle(fontWeight: FontWeight.bold),)
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
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.all(20)),
      
    );
  }
}