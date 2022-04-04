import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pixel_lab/widgets/widget.dart';
import 'package:pixel_lab/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pixel_lab/model/wallpaper_model.dart';

class Category extends StatefulWidget {
  final String categoryName;
  Category({this.categoryName = ''});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<WallpaperModel> wallpapers = List.empty(growable: true);

  @override
  void initState() {
    getCategoryWallpapers(widget.categoryName);
    super.initState();
  }

  getCategoryWallpapers(String query) async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=40"),
        headers: {
          "Authorization": apiKey,
        });

    // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              wallpapersList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}
