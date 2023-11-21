import 'package:flutter/material.dart';

class DiagnosisPage extends StatelessWidget {
  final Map<String, dynamic> selectedSymptoms;
  final Map<String, dynamic> responseBody;

  DiagnosisPage({
    required this.selectedSymptoms,
    required this.responseBody,
  });

  @override
  Widget build(BuildContext context) {
    String diagnosisResult = generateDiagnosis(selectedSymptoms, responseBody);

    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnóstico'),
      ),
      body: Center(
        child: Text('Seu diagnóstico é: $diagnosisResult'),
      ),
    );
  }

  String generateDiagnosis(Map<String, dynamic> selectedSymptoms,
      Map<String, dynamic> responseBody) {

    if (responseBody.containsKey('prognosis')) {
      String apiDiagnosis = responseBody['prognosis'];
      return apiDiagnosis;
    }

    return 'Diagnóstico não disponível';
  }
}
