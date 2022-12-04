import 'package:flutter/material.dart';

import 'modals/magic_box.dart';

class SAConstants {
  static final Map<String, MagicBox> defaultMagicBoxes = {
    "box_one": MagicBox(
        id: "box_one",
        position: const Offset(700, 250),
        borderRadius: 10,
        boxSize: const Size(200, 150),
        child: Container(
          decoration:   BoxDecoration(
              color: Colors.blueAccent,
              gradient: const LinearGradient(colors: [Color(0xff7F00FF), Color(0xffE100FF)]),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow:const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 2,
                blurRadius: 10,
              )
            ]
          ),
          child: const Center(
            child: Text(
              "Flutter",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 32),
            ),
          ),
        )),
    "box_two": MagicBox(
        id: "box_two",
        position: const Offset(100, 100),
        borderRadius: 10,
        boxSize: const Size(200, 150),
        child: Container(
          decoration:   BoxDecoration(
              color: Colors.blueAccent,
            gradient: const LinearGradient(colors: [
              Color(0xffffb347),
              Color(0xffffcc33),
            ],),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow:const [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 2,
                  blurRadius: 10,
                )
              ]
          ),
          child: const Center(
            child: Text(
              "React",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 32),
            ),
          ),
        )),
    "box_three": MagicBox(
        id: "box_three",
        position: const Offset(400, 100),
        borderRadius: 10,
        boxSize: const Size(200, 100),
        child: Container(
          decoration:  BoxDecoration(
            color: Colors.black,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow:const [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 2,
                  blurRadius: 10,
                )
              ]
          ),
          child: const Center(
            child: Text(
              "Paras Jain",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 32),
            ),
          ),
        ))
  };

  static const LinearGradient gradient = LinearGradient(colors: [Color(0xffe53935),Color(0xffe35d5b)] );
  //
}
