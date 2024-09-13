import 'package:flutter/material.dart';

class SentMessageCard extends StatelessWidget {
  const SentMessageCard({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          color: const Color.fromARGB(255, 152, 242, 221),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 45, top: 10, bottom: 20),
                child: Text(message,
                    style: const TextStyle(fontSize: 17, color: Colors.grey)),
              ),
              const Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text("1:00",
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                      Icon(Icons.done_all)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
