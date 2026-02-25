import 'package:flutter/material.dart';

class AppTopbar extends StatelessWidget {
  const AppTopbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Dr. Blal Clinical Laboratory",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.notifications_none),
              const SizedBox(width: 20),
              const CircleAvatar(
                radius: 16,
                child: Text("A"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
