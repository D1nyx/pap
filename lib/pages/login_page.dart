import 'package:flutter/material.dart';
import 'package:pap/components/my_button.dart';
import 'package:pap/components/my_textfield.dart';
import 'package:pap/components/square_title.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: Image(
                      image: AssetImage('lib/images/logo.png'),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            Text(
              'Bem Vindo de volta, sentimos a sua falta!',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,

                ),
            ),

            const SizedBox(height: 25),

            MyTextfield(
              controller: usernameController,
              hintText: 'Utilizador',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            MyTextfield(
              controller: passwordController,
              hintText: 'Palavra-Passe',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Esqueces-te a palavra-passe?',
                    style: TextStyle(color: Colors.grey[600]),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 25), 

            MyButton(
              onTap: signUserIn,
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child:Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      'Ou continuar com',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
              
                  Expanded(
                    child:Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTitle(imagePath: 'lib/images/google.png'),

                SizedBox(width: 25),

                SquareTitle(imagePath: 'lib/images/apple.png'),
              ],
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ainda não é membro?',
                  style: TextStyle(color: Colors.grey[700]),
                  ),
                const SizedBox(width: 4),
                const Text(
                  'Registe-se agora',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            )

          ]),
        ),  
      ),
    );
  }
}