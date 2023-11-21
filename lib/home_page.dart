import 'package:flutter/material.dart';
import 'symptom_selection.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              // Adicionando a logo no topo da tela
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'lib/HealthCheck.png', // Ajuste o caminho conforme necessário
                  width: screenWidth,
                ),
              ),
              SizedBox(height: 20),

              // Campo para inserir o nome
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  style: TextStyle(color: Colors.white), // Cor do texto
                  cursorColor: Color(0xFF91041C), // Cor do cursor
                  decoration: InputDecoration(
                    hintText: 'Olá! Qual o seu nome?',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(
                              0xFF91041C)), // Cor da linha quando o campo está focado
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Botão "Continuar"
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SymptomSelectionPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF91041C), // Cor do botão
                  ),
                  child: Text(
                    'Continuar',
                    style:
                        TextStyle(color: Colors.white), // Cor do texto do botão
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
