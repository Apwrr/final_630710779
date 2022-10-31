import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_food/models/api_result.dart';
import 'package:flutter_food/models/food_item.dart';
import 'package:flutter_food/services/api.dart';

//flutter pub add http
import 'package:http/http.dart' as http;

const apiBaseUrl = 'https://cpsu-test-api.herokuapp.com';
const apiGetFoods = '$apiBaseUrl/foods';

class FoodListPage extends StatefulWidget {
  const FoodListPage({Key? key}) : super(key: key);

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  List<FoodItem>? _foodList;
  var _isLoading = false;
  String? _isError;

  @override
  void initState() {
    super.initState();
    _handleClickButton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FOOD LIST')),
      body: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: _handleClickButton,
          //     child: const Text('GET FOOD DATA'),
          //   ),
          // ),
          Expanded(
            child: Stack(
              children: [
                if (_foodList != null)
                  ListView.builder(
                    itemBuilder: _buildListItem,
                    itemCount: _foodList!.length,
                  ),
                if (_isLoading) const Center(
                    child: CircularProgressIndicator()),
                if(_isError != null && !_isLoading)
                  Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(_isError!),
                      ),
                      ElevatedButton(onPressed: () {
                        _handleClickButton();
                      }, child: const Text('RETRY'))
                    ],
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleClickButton() async {
    setState(() {
      // _foodList = null;
      _isLoading = true;
    });

    // try{
    //   var output =  await Api().fetch('foods');
    //   setState(() {
    //     _foodList = output.map<FoodItem>((item) {
    //       return FoodItem.formJson(item);
    //     }).toList();
    //     _isLoading = false;
    //   });
    // } catch (e) {
    //   setState(() {
    //     _isError = e.toString();
    //     _isLoading = false;
    //   });
    // }

//call API
    var response = await http.get(Uri.parse(apiGetFoods));

    if (response.statusCode == 200) {
      // Json to Dart
      var output = jsonDecode(response.body);
      var apiResult = ApiResult.fromJson(output);
      if (apiResult.status == 'ok') {
        setState(() {
          _foodList = apiResult.data.map<FoodItem>((item) {
            return FoodItem.formJson(item);
          }).toList();
          _isLoading = false;
        });
      } else {
        //error
        setState(() {
          _isLoading = false;
          _isError = apiResult.message;
        });
      }
    } else {
      //error
      setState(() {
        _isLoading = false;
        _isError = '[${response.statusCode}]Network connection failed';
      });
    }

    // setState(() {//Model
    //   //_foodList = [];
    //   // _foodList = output['data'].map<FoodItem>((item) {
    //   //   return FoodItem.formJson(item);
    //   // }).toList();
    //
    //   // output['data'].forEach((item){
    //   //   print(item['name']+ ' ราคา '+item['price'].toString());
    //   //   var foodItem = FoodItem.formJson(item);
    //   //   _foodList!.add(foodItem);
    //   // });
    //
    // });
  }

  Widget _buildListItem(BuildContext context, int index) {
    var fooditem = _foodList![index];
    return Card(
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Image.network(
              fooditem.image,
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(fooditem.name),
          ],
        ),
      ),
    );
  }
}
