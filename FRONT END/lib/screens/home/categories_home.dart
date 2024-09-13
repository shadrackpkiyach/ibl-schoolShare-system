import 'package:flutter/material.dart';

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TabBar(
                    isScrollable: true,
                    indicator: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20)),
                    tabs: const [
                      Tab(
                        text: 'work flow ',
                      ),
                      Tab(text: 'register'),
                      Tab(text: 'register')
                    ]),
              )
            ])),
      ),
    );
  }
}
