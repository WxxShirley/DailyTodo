import 'package:shared_preferences/shared_preferences.dart';


void updateTodo(String key, String value) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key , value);
  
}