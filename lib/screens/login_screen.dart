import 'package:encuestor/components/animated_switch.dart';
import 'package:encuestor/components/app_text_field.dart';
import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/data/professor_repository.dart';
import 'package:encuestor/data/students_repository.dart';
import 'package:encuestor/screens/home_professor_screen.dart';
import 'package:encuestor/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final StudentsRepository _studentsRepository = StudentsRepository();
  final ProfessorRepository _professorRepository = ProfessorRepository();

  var isProfesor = false;
  //

  bool _isLoading = false;

  void _login() async {
    final id = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (id.isEmpty) {
      _showError("Por favor, ingrese su cédula.");
      return;
    }

    if (id.isEmpty) {
      _showError("Por favor, ingrese su contraseña.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (isProfesor) {
      // Lógica para profesor (sin cambios)
      try {
        final professorDoc = await _professorRepository.getProfessor(id);

        if (professorDoc == null) {
          _showError("Cédula de profesor no encontrada.");
          setState(() {
            _isLoading = false;
          });
          return;
        } else if (professorDoc.password == password) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeProfesorScreen(professorId: id),
            ),
          );
        } else {
          _showError("Credenciales incorrectas.");
        }
      } catch (e) {
        _showError("Ocurrió un error al verificar el profesor. $e");
      }
    } else {
      // Lógica para estudiante
      try {
        final studentExists = await _studentsRepository.studentExists(id);
        if (studentExists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(studentId: id.trim()),
            ),
          );
        } else {
          _showError("Cédula de estudiante no encontrada.");
        }
      } catch (e) {
        _showError("Ocurrió un error al verificar el estudiante. $e");
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            AppTextField(hintText: "Cédula", controller: _idController),

            AppTextField(
              hintText: "Contraseña",
              enabled: isProfesor,
              controller: _passwordController,
              obscureText: true,
            ),

            _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : PrimaryButton(text: "Ingresar", onPressed: _login),
          ],
        ),
      ),
    );
  }
}
