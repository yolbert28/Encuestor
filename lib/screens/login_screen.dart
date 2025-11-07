import 'package:encuestor/components/animated_switch.dart';
import 'package:encuestor/components/app_text_field.dart';
import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/screens/home_profesor_screen.dart';
import 'package:encuestor/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isProfesor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: isProfesor ? AppColor.primaryP : AppColor.primary,
      body: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        color: isProfesor ? AppColor.primaryP : AppColor.primary,
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", width: 200),
            SizedBox(height: 8),
            AnimatedSwitch(
              leftWidget: Text(
                "Estudiante",
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              rightWidget: Text(
                "Profesor",
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (bool value) {
                setState(() {
                  isProfesor = value;
                });
              },
            ),
            AppTextField(hintText: "Cédula"),
            AppTextField(hintText: "Contraseña", enabled: isProfesor),
            PrimaryButton(
              text: "Ingresar",
              onPressed: () {
                if (isProfesor) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeProfesorScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
