import 'package:healthyhams/model/meal.dart';

Map<DateTime,List<Meal>> mealHistory = {};

void AddToMealHistory(DateTime day,Meal meal)
{
  if(!mealHistory.containsKey(day))
  {
    mealHistory.addAll({day: [meal]});
  }
  else
  {
    mealHistory[day]?.add(meal);
  }

}

void removeMealFromHistory(DateTime day, Meal meal) {
  if (mealHistory.containsKey(day)) {
    mealHistory[day]?.remove(meal);
  }
}

List<Meal>? getTodaysMeals(DateTime todaysDate)
{
  List<Meal>? todaysMeals = mealHistory[todaysDate];
  return todaysMeals;
}