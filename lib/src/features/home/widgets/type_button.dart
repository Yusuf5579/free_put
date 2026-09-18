import 'package:flutter/material.dart';

class TypeButton extends StatefulWidget {
  const TypeButton({super.key, });
  @override
  State<TypeButton> createState() => _TypeButtonState();
}

class _TypeButtonState extends State<TypeButton> {
  int currentSection = 0;
  List<String> sections = ['All', 'Documents', 'Images', 'Videos'];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: .horizontal,
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () {
              setState(() {
                currentSection = index;
              });
            },
            child: Container(
              margin: .only(right: 10),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: currentSection == index ? Colors.black : Colors.white,
              ),
              padding: .only(top: 6, left:15, bottom: 6, right: 15 ),
              alignment: .center,
              child: Text(
                sections[index],
                style: TextStyle(color:  currentSection == index ? Colors.white : Colors.black,),
              ),
            ),
          );
        },
      ),
    );
  }
}
