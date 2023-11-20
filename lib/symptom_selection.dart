import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_check_app/diagnosis_page.dart';

class SymptomSelectionPage extends StatefulWidget {
  @override
  _SymptomSelectionPageState createState() => _SymptomSelectionPageState();
}

class _SymptomSelectionPageState extends State<SymptomSelectionPage> {
  late String jsonString;
  late List<Category> categories;
  List<String> selectedSymptoms = [];

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
          }
        });
      });

      if (isSelected) {
        selectedSymptoms.add(symptomKey);
      } else {
        selectedSymptoms.remove(symptomKey);
      }
    });
  }

  void printSelectedSymptoms() {
    // ignore: avoid_print
    print("Sintomas Selecionados: $selectedSymptoms");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SINTOMAS'),
      ),
      // ignore: unnecessary_null_comparison
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
        onPressed: () {
          print('Sintomas Selecionados: ${selectedSymptoms}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DiagnosisPage(selectedSymptoms: selectedSymptoms),
            ),
          );
        },
        child: Icon(Icons.check),
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
