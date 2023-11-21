import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'diagnosis_page.dart';

class SymptomSelectionPage extends StatefulWidget {
  @override
  _SymptomSelectionPageState createState() => _SymptomSelectionPageState();
}

class _SymptomSelectionPageState extends State<SymptomSelectionPage> {
  late String jsonString;
  late List<Category> categories;
  late Map<String, dynamic> selectedSymptoms = {};

  bool get isButtonEnabled => selectedSymptoms.length >= 5;

  @override
  void initState() {
    super.initState();
    loadMockData();
  }

  Future<void> loadMockData() async {
    try {
      jsonString = await rootBundle.loadString('lib/mockdata.json');
      setState(() {
        categories = loadCategoriesFromJson();
      });
    } catch (e) {
      print('Erro ao carregar o arquivo mockdata.json: $e');
    }
  }

  // Future<void> loadMockData() async {
  //   Uri url =
  //       Uri.parse('https://disease-prognosis-api.azurewebsites.net/symptoms');

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       jsonString = response.body;
  //       setState(() {
  //         categories = loadCategoriesFromJson();
  //       });
  //     }
  //   } catch (e) {
  //     print('Erro na requisição GET: $e');
  //   }
  // }

  List<Category> loadCategoriesFromJson() {
    Map<String, dynamic> jsonData = convert.jsonDecode(jsonString);

    List<Category> categories = jsonData.entries.map((entry) {
      List<Symptom> symptoms = (entry.value as Map<String, dynamic>)
          .entries
          .map((entry) =>
              Symptom(name: entry.value, key: entry.key, isSelected: false))
          .toList();

      return Category(name: entry.key, symptoms: symptoms);
    }).toList();

    return categories;
  }

  void onSymptomSelected(String symptomKey, bool isSelected) {
    setState(() {
      categories.forEach((category) {
        category.symptoms.forEach((s) {
          if (s.key == symptomKey) {
            s.isSelected = isSelected;
            selectedSymptoms[s.key] = isSelected;
          }
        });
      });
    });
  }

  void printSelectedSymptoms() async {
    if (selectedSymptoms.length >= 5) {
      print('Sintomas Selecionados: $selectedSymptoms');

      String requestBody = convert.jsonEncode(selectedSymptoms);

      Uri url = Uri.parse(
          'https://disease-prognosis-api.azurewebsites.net/prognosis');
      try {
        final response = await http.post(
          url,
          body: requestBody,
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> diagnosisResult =
              convert.jsonDecode(response.body);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiagnosisPage(
                selectedSymptoms: selectedSymptoms,
                responseBody: diagnosisResult,
              ),
            ),
          );
        }
      } catch (e) {
        print('Erro na requisição POST: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro na requisição POST. Tente novamente.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecione pelo menos 5 sintomas'),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sintomas'),
      ),
      body: categories != null
          ? ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return CategoryTile(
                  category: categories[index],
                  onSymptomSelected: onSymptomSelected,
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: isButtonEnabled ? printSelectedSymptoms : null,
        child: Icon(Icons.check),
        backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
      ),
    );
  }
}

class Category {
  final String name;
  final List<Symptom> symptoms;

  Category({required this.name, required this.symptoms});
}

class Symptom {
  final String name;
  final String key;
  bool isSelected;

  Symptom({required this.name, required this.key, this.isSelected = false});
}

class CategoryTile extends StatelessWidget {
  final Category category;
  final Function(String, bool) onSymptomSelected;

  CategoryTile({required this.category, required this.onSymptomSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(category.name),
        children: category.symptoms.map((symptom) {
          return ListTile(
            title: Text(symptom.name),
            trailing: Checkbox(
              value: symptom.isSelected,
              onChanged: (value) {
                onSymptomSelected(symptom.key, value ?? false);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
