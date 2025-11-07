import 'package:encuestor/components/survey_edit_card.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:flutter/material.dart';

class SurveyDetailScreen extends StatefulWidget {
  const SurveyDetailScreen({super.key});

  @override
  State<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
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
                child: Column(spacing: 16, children: [
                  Text("sistemas Operativos", style: TextStyles.titleProfesor,),
                  SurveyEditCard()
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
