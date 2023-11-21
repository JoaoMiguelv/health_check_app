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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Elementos centralizados no topo
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Image.asset(
                  'lib/HealthCheck.png', // Ajuste o caminho conforme necessário
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                SizedBox(height: 20),
                Text(
                  'Geramos o seu diagnóstico!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Lembre-se que ele foi gerado a partir de aprendizagem de máquina e não substitui uma consulta médica.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Elementos centralizados no meio
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, // Cor do fundo
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'De acordo com a nossa base de dados, você tem suspeita de:\n\n$diagnosisResult',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Botão "Refazer" centralizado abaixo
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF91041C), // Cor do botão
              ),
              child: Text('Refazer'),
            ),
          ),
        ],
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
