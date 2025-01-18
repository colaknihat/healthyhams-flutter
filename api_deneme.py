import requests

def get_meal_info(meal_name):
  """
  Requests meal information from the Edamam Nutrition Analysis API.

  Args:
    meal_name: The name of the meal to search for.

  Returns:
    A dictionary containing the meal information, or None if no results 
    are found.
  """
  url = "https://api.edamam.com/api/nutrition-data"

  # Replace with your actual API ID and key
  api_id = "895769bc"  
  api_key = "70d86f3b74e95e3cf57ee395b375a386"

  querystring = {"app_id": api_id, "app_key": api_key, "ingr": meal_name}

  response = requests.request("GET", url, params=querystring)

  data = response.json()

  if "error" in data:
    print(f"Error: {data['error']}")
    return None

  return data

if __name__ == "__main__":
  meal = input("Enter a meal name: ")
  meal_info = get_meal_info(meal)

  if meal_info:
    print(meal_info)