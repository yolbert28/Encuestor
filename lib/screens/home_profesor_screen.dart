import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/survey_card.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/screens/survey_detail_screen.dart';
import 'package:flutter/material.dart';

class HomeProfesorScreen extends StatefulWidget {
  const HomeProfesorScreen({super.key});

  @override
  State<HomeProfesorScreen> createState() => _HomeinfoScreenState();
}

class _HomeinfoScreenState extends State<HomeProfesorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryP,
        title: Image.asset("assets/images/logo.png", width: 140),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AppColor.backgroundP,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 16),
        child: Column(
          spacing: 16,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  children: [
                    Text(
                      "Encuestas disponibles",
                      style: TextStyles.titleProfesor,
                    ),
                    SurveyCard(
                      title: "Sistemas Operativos",
                      info: "Ing. Informática",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SurveyDetailScreen(),
                          ),
                        );
                      },
                    ),
                    SurveyCard(
                      title: "Bases de Datos",
                      info: "Maria Rodriguez",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SurveyDetailScreen(),
                          ),
                        );
                      },
                    ),
                    SurveyCard(
                      title: "Redes de Computadoras",
                      info: "Carlos Gomez",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SurveyDetailScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            PrimaryButton(text: "Agregar", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
