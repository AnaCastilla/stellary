import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Clase que crea la categoría con el checkbox y su respectivo nombre
class Category {
  String name;
  bool selected;

  Category(this.name, this.selected);
}

class CategoryWidget extends StatelessWidget {
  final Category? category;
  final Function(bool?)? onSelected;

  CategoryWidget({Key? key, this.category, this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: category!.selected,
          onChanged: onSelected,
          activeColor: Colors.deepPurple,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(
            category!.name,
            style: GoogleFonts.kodchasan(fontSize: 20),
          ),
        )
      ],
    );
  }
}
