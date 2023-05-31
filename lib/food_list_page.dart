import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'food_detail_page.dart';

class FoodListPage extends StatefulWidget {
  final String category;

  const FoodListPage({required this.category});

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  List<dynamic> foods = [];

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        foods = data['meals'];
      });
    }
  }

  void navigateToFoodDetailPage(String foodId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FoodDetailPage(foodId: foodId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Food List - ${widget.category}'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: EdgeInsets.all(10),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];

          return GestureDetector(
            onTap: () => navigateToFoodDetailPage(food['idMeal']),
            child: GridTile(
              child: Image.network(
                food['strMealThumb'],
                fit: BoxFit.cover,
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black45,
                title: Text(
                  food['strMeal'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}