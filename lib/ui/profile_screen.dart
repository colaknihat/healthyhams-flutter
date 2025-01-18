import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:healthyhams/model/meal.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';
import 'package:healthyhams/model/meal_manager.dart';
import 'dart:convert';
import 'package:healthyhams/model/api_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DateTime today = DateTime.now();
  DateTime todaysDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final TextEditingController mealNameEC = TextEditingController();
  final TextEditingController proteinEC = TextEditingController();
  final TextEditingController carbsEC = TextEditingController();
  final TextEditingController calsEC = TextEditingController();
  final TextEditingController fatsEC = TextEditingController();
  List<Meal>? todaysMeals;
  List<double> todaysNutritions = [0, 0, 0, 0];
  double todaysCalory = 0;
  double todaysPro = 0;
  double todaysCab = 0;
  double todaysFat = 0;
  //0 calory, 1 protein, 2 fat, 3 cab

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    todaysMeals = getTodaysMeals(todaysDate);
    final todayDateWithHours = DateTime.now();
    setTodaysNutritions(todaysMeals, todaysNutritions);
    todaysCalory = todaysNutritions[0];
    todaysPro = todaysNutritions[1];
    todaysCab = todaysNutritions[2];
    todaysFat = todaysNutritions[3];

    return Scaffold(
      backgroundColor: const Color.fromARGB(244, 245, 250, 255),

      body: Stack(
        children: <Widget>[
          //TOP CURVED PART
          Positioned(
            top: 0,
            height: height * 0.40,
            left: 0,
            right: 0,
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
                top: 10,
                bottom: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Hello User & Date
                    ListTile(
                      title: Text(
                        "${DateFormat("EEEE\n").format(todayDateWithHours)}${DateFormat("dd MM").format(todayDateWithHours)}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      subtitle: const Text(
                        "hi, user",
                        style: TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                      //trailing: , Profile Picture
                    ),
                    //PROGRESSES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // RADIAL PROGRESS

                        _RadialProgress(
                          width: width * 0.25,
                          height: height * 0.25,
                          progress: todaysCalory / 2000,
                          calLeft: 2000 - todaysCalory,
                        ),
                        //NUTRITION PROGRESS
                        Column(
                          children: <Widget>[
                            _NutritionProgress(
                              nutrition: "proteins",
                              leftAmount: 60 - todaysPro,
                              progress: todaysPro / 60,
                              progressColor: Colors.white,
                              width: width * 0.325,
                              height: height * 0.012,
                            ),
                            _NutritionProgress(
                              nutrition: "carbs",
                              leftAmount: 225 - todaysCab,
                              progress: todaysCab / 225,
                              progressColor: Colors.white,
                              width: width * 0.325,
                              height: height * 0.012,
                            ),
                            _NutritionProgress(
                              nutrition: "fats",
                              leftAmount: 78 - todaysFat,
                              progress: todaysFat / 78,
                              progressColor: Colors.white,
                              width: width * 0.325,
                              height: height * 0.012,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          //TODAY'S MEALS
          Positioned(
            //height: height,
            top: height * 0.40,
            left: 0,
            right: 0,
            child: SizedBox(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(
                      bottom: 8,
                      left: 16,
                      right: 16,
                      top: 10,
                    ),
                    child: Center(
                      child: Text(
                        "what you ate today!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 132, 167, 9),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        if (todaysMeals != null)
                          for (int i = 0; i < todaysMeals!.length; i++)
                            MealCard2(
                              meal: todaysMeals![i],
                              onDelete: () {
                                setState(() {
                                  removeMealFromHistory(
                                      todaysDate,
                                      todaysMeals![
                                          i]); // Call the removeMealFromHistory function
                                  todaysMeals = getTodaysMeals(todaysDate);
                                });
                              },
                            ),
                      ],
                    )),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color.fromRGBO(98, 130, 93, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      //ADD MEAL
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
                        try {
                          final nutritionData =
                              await EdamamApiHelper.fetchFoodNutrition(
                                  mealNameEC.text);
                          if (nutritionData != null) {
                            Meal meal = Meal.fromApiData(nutritionData);
                            DateTime today = DateTime(todayDateWithHours.year,
                                todayDateWithHours.month, todayDateWithHours.day);
                            AddToMealHistory(today, meal);
                            setState(() {
                              todaysMeals = getTodaysMeals(todaysDate);
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
                        } catch (e) {
                          if (e.toString().contains('Meal not found')) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Meal could not be found, please try adding manually'),
                              ),
                            );
                          } else {
                            // Handle other exceptions
                            print('Error: $e');
                          }
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
                                        AddToMealHistory(todaysDate, newMeal);
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        setState(() {
                                          todaysMeals =
                                              getTodaysMeals(todaysDate);
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
        child: const Row(
          children: [
            Icon(Icons.add),
            Icon(Icons.dining_sharp),
          ],
        ),
      ),
    );
  }
}

double setTodaysNutritions(
    List<Meal>? todaysMeals, List<double>? todaysNutritions) {
  double totalCalory = 0;
  if (todaysMeals == null) return 0;
  if (todaysNutritions == null) return 0;
  todaysNutritions[0] = 0;
  todaysNutritions[1] = 0;
  todaysNutritions[2] = 0;
  todaysNutritions[3] = 0;

  for (int i = 0; i < todaysMeals.length; i++) {
    todaysNutritions[0] += todaysMeals[i].calory;
    todaysNutritions[1] += todaysMeals[i].protein;
    todaysNutritions[2] += todaysMeals[i].carbs;
    todaysNutritions[3] += todaysMeals[i].fats;
  }
  return totalCalory;
}

class _NutritionProgress extends StatelessWidget {
  final String nutrition;
  final double leftAmount;
  final double progress, width, height;
  final Color progressColor;

  const _NutritionProgress(
      {required this.nutrition,
      required this.leftAmount,
      required this.progress,
      this.width = 0,
      this.height = 0,
      required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nutrition.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Row(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height: height,
                  width: width * min(1, progress),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    color: progressColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15.0),
            Text(
              "${leftAmount}g left",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final double height, width, progress, calLeft;
  const _RadialProgress(
      {required this.height,
      required this.width,
      required this.progress,
      required this.calLeft});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      //RADIAL
      painter: _RadialPainter(progress: progress, Colors.white),
      //KCAL LEFT TEXT
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: calLeft.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              TextSpan(
                text: "\nkcal left",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RadialPainter(this.color, {required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintProgress = Paint()
      ..strokeWidth = 10
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint paintBack = Paint()
      ..strokeWidth = 10
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(-relativeProgress),
        false,
        paintProgress);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90), math.radians(360), false, paintBack);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _MealCard extends StatelessWidget {
  final Meal meal;

  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 20,
        bottom: 10,
      ),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        elevation: 4,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                        Text("${meal.calory} GR  ${meal.calory} Calory"),
                        Row(
                          children: [
                            Text("${meal.carbs} Carbs"),
                            Text("${meal.fats} Fats"),
                            Text("${meal.protein} Protein"),
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
    );
  }
}
