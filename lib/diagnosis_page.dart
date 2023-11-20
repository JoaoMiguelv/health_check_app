import 'package:flutter/material.dart';

class DiagnosisPage extends StatelessWidget {
  final List<String> selectedSymptoms;

  DiagnosisPage({required this.selectedSymptoms});

  @override
  Widget build(BuildContext context) {
    String diagnosisResult = generateDiagnosis(selectedSymptoms);

    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnóstico'),
      ),
      body: Center(
        child: Text('Seu diagnóstico é: $diagnosisResult'),
      ),
    );
  }

  String generateDiagnosis(List<String> selectedSymptoms) {
    if (selectedSymptoms.contains('febre') &&
        selectedSymptoms.contains('tosse')) {
      return 'Resfriado';
    } else if (selectedSymptoms.contains('manchas') &&
        selectedSymptoms.contains('coceira')) {
      return 'Catapora';
    } else {
      return 'Indefinido';
    }
  }
}
