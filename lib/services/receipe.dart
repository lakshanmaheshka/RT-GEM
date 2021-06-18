import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rt_gem/utils/receipe_models/hits.dart';

class ReceipesService {
  List<Hits> hits = [];

  Future<void> getReceipe() async {
    String url =
        "https://api.edamam.com/search?q=banana&app_id=0ed45bdb&app_key=fac40fdccd25562fac93d16edddc2c12";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element) {
      Hits hits = Hits(
        recipeModel: element['recipe'],
      );
      // hits.recipeModel = add(Hits.fromMap(hits.recipeModel));
    });
  }
}
