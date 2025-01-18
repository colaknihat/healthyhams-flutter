import 'package:flutter/material.dart';
import 'package:healthyhams/model/meal.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:healthyhams/model/meal_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:healthyhams/model/api_helper.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});
  @override
  State<CalendarWidget> createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  DateTime today = DateTime.now();
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = DateTime(day.year, day.month, day.day);
      _selectedMeal.value = _getMealForDay(selectedDay);
    });
  }

  Future<Map<String, dynamic>> fetchFoodNutrition(String foodName) async {
    final jsonString = await rootBundle.loadString('assets/meals.json');
    final jsonData = jsonDecode(jsonString) as List;

    for (var meal in jsonData) {
      if (meal['name'] == foodName) {
        return meal;
      }
    }
    // If no matching meal is found
    throw Exception('Meal not found');
  }

  //Meal List
  //Map<DateTime,List<Meal>> mealHistory = {};
  final TextEditingController mealNameEC = TextEditingController();
  final TextEditingController proteinEC = TextEditingController();
  final TextEditingController carbsEC = TextEditingController();
  final TextEditingController calsEC = TextEditingController();
  final TextEditingController fatsEC = TextEditingController();
  late final ValueNotifier<List<Meal>> _selectedMeal;
  @override
  void initState() {
    super.initState();
    _selectedMeal = ValueNotifier(_getMealForDay(selectedDay));
  }

  List<Meal> _getMealForDay(DateTime day) {
    return mealHistory[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("add what you ate!"),
                  content: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextField(
                          controller: mealNameEC,
                          decoration: const InputDecoration(
                            labelText: 'enter meal name',
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    //MEAL API
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedDay.isAfter(DateTime.now())) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Cannot add meal to a future date")),
                          );
                          return; // Don't add the meal
                        }
                        final nutritionData =
                            await EdamamApiHelper.fetchFoodNutrition(mealNameEC.text);
                        if (nutritionData != null) {
                          Meal meal = Meal.fromApiData(nutritionData);
                          DateTime today = DateTime(selectedDay.year,
                              selectedDay.month, selectedDay.day);
                          AddToMealHistory(today, meal);
                          setState(() {
                            _selectedMeal.value = _getMealForDay(selectedDay);
                          });
                          print(meal);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to fetch nutrition data.'),
                              duration: Duration(
                                  seconds: 2), // Adjust duration as needed
                            ),
                          );
                        }
                      },
                      child: const Text('Add Meal'),
                    ),
                    //OWN MEAL
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text("add your own!"),
                                content: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: mealNameEC,
                                        decoration: const InputDecoration(
                                          labelText: 'meal Name',
                                        ),
                                      ),
                                      TextField(
                                        controller: calsEC,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'calories',
                                        ),
                                      ),
                                      TextField(
                                        controller: proteinEC,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'proteins (grams)',
                                        ),
                                      ),
                                      TextField(
                                        controller: carbsEC,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'carbs (grams)',
                                        ),
                                      ),
                                      TextField(
                                        controller: fatsEC,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'fats (grams)',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Meal newMeal = Meal(
                                            name: mealNameEC.text,
                                            calory: double.parse(calsEC.text),
                                            protein:
                                                double.parse(proteinEC.text),
                                            carbs: double.parse(carbsEC.text),
                                            fats: double.parse(fatsEC.text));
                                        AddToMealHistory(selectedDay, newMeal);
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _selectedMeal.value =
                                              _getMealForDay(selectedDay);
                                        });
                                      },
                                      child: const Text("Add")),
                                ],
                              );
                            });
                      },
                      child: const Text('Add your own'),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const Text(""),
          //used to say data

          Container(
            child: TableCalendar(
              locale: "en_US",
              rowHeight: 40,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              eventLoader: _getMealForDay,
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              focusedDay: today,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: _onDaySelected,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: _selectedMeal,
                builder: (context, value, _) {
                  return ListView(
                    children: [
                      for (int i = 0; i < value.length; i++)
                        MealCard2(
                          meal: value[i],
                          onDelete: () {
                            setState(() {
                              removeMealFromHistory(
                                  selectedDay,
                                  value[
                                      i]); // Call the removeMealFromHistory function
                              _selectedMeal.value = _getMealForDay(selectedDay);
                            });
                          },
                        ),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
