import 'package:encuestor/components/survey_card.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/screens/survey_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Image.asset("assets/images/logo.png", width: 140),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AppColor.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              Text("Encuestas disponibles", style: TextStyles.title),
              SurveyCard(
                title: "Sistemas Operativos",
                info: "Juan Perez",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SurveyScreen()),
                  );
                },
              ),
              SurveyCard(
                title: "Bases de Datos",
                info: "Maria Rodriguez",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SurveyScreen()),
                  );
                },
              ),
              SurveyCard(
                title: "Redes de Computadoras",
                info: "Carlos Gomez",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SurveyScreen()),
                  );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
