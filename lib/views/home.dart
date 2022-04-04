import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_lab/data/data.dart';
import 'package:pixel_lab/model/categories_model.dart';
import 'package:pixel_lab/model/wallpaper_model.dart';
import 'package:pixel_lab/views/category.dart';
import 'package:pixel_lab/views/search.dart';
import 'package:pixel_lab/widgets/widget.dart';
import 'package:pixel_lab/constants.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategorieModel> categories = List.empty(growable: true);
  List<WallpaperModel> wallpapers = List.empty(growable: true);
  TextEditingController searchController = TextEditingController();

  String apiEndpoint = "https://api.pexels.com/v1/curated?per_page=40";

  getTrendingWallpapers() async {
    var response = await http.get(Uri.parse(apiEndpoint), headers: {
      "Authorization": apiKey,
    });

    //print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {});
  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 24),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'search wallpapers',
                          hintStyle: GoogleFonts.overpass(),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(
                              searchQuery: searchController.text,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        child: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                child: Text(
                  'Categories',
                  style: GoogleFonts.overpass(
                    textStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Overpass',
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 16,
              // ),
              Container(
                height: 100,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                        imgUrl: categories[index].imgUrl,
                        categoryTitle: categories[index].categorieName);
                  },
                ),
              ),
              // SizedBox(
              //   height: 16,
              // ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Best of the month',
                  style: GoogleFonts.overpass(
                    textStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Overpass',
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                ),
              ),
              wallpapersList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imgUrl, categoryTitle;

  CategoryTile({required this.imgUrl, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Category(
              categoryName: categoryTitle,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            ClipRRect(
              child: Image.network(
                imgUrl,
                height: 80,
                width: 130,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              height: 80,
              width: 130,
              alignment: Alignment.center,
              child: Text(
                categoryTitle,
                style: GoogleFonts.overpass(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
