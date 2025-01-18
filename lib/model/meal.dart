
import 'package:flutter/material.dart';


class Meal{
    final String name;
    final double protein,carbs,fats,calory;

    Meal({
      required this.name,
      required this.protein,
      required this.carbs,
      required this.fats,
      required this.calory,
    });

    factory Meal.fromApiData(Map<String, dynamic> json) {
      // Extract nutrition information from the description

      double protein = json['totalNutrients']['PROCNT']['quantity'] ?? 0;
      int truncatedProtein = protein.toInt();
      protein = truncatedProtein.toDouble();

      double carbs = json['totalNutrients']['CHOCDF']['quantity'] ?? 0;
      int truncatedcarbs = carbs.toInt();
      carbs = truncatedcarbs.toDouble();

      double fats = json['totalNutrients']['FAT']['quantity'] ?? 0;
      int truncatedfats = fats.toInt();
      fats = truncatedfats.toDouble();

      double calories = json['totalNutrients']['ENERC_KCAL']['quantity'] ?? 0;
      int truncatedcalories = calories.toInt();
      calories = truncatedcalories.toDouble();

      return Meal(
        name: json['ingredients'][0]['parsed'][0]['food'],
        protein: protein,
        carbs: carbs,
        fats: fats,
        calory: calories,
      );
      }
  }

class MealCard2 extends StatelessWidget {
  final Meal meal;
  final VoidCallback onDelete; // Callback function for delete action

  const MealCard2({super.key, required this.meal, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, bottom: 10,left: 20),     
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        elevation: 4,
        child: InkWell(
          onLongPress: () {
            _showDeleteConfirmationDialog(context); // Call the function here
          },
          child: Row(
            mainAxisSize:  MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    //MEAL NAME
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(meal.name),
                    ),
                    const Expanded(child: SizedBox()),
                    //GR AND NUTRITION VALUES
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${meal.calory} calories"),
                          Row(
                            children: [
                              Text("${meal.carbs} carbs "),
                              Text("${meal.fats} fats "),
                              Text("${meal.protein} proteins"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this meal?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                onDelete(); // Call the onDelete callback to delete the meal
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}


  

  final meals = [

    Meal(
      name: "Steak",
      protein: 50,
      carbs: 10,
      fats: 25,
      calory: 750,
    ),
    Meal(
      name: "Bread",
      protein: 0,
      carbs: 100,
      fats: 10,
      calory: 200,
    ),
    Meal(
      name: "Cola",
      protein: 0,
      carbs: 100,
      fats: 0,
      calory: 150,
    ),
    Meal(
      name: "Salad",
      protein: 0,
      carbs: 10,
      fats: 10,
      calory: 50,
    ),
  ];