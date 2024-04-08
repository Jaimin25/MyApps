import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TaskListSkeleton extends StatelessWidget {
  const TaskListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
            child: Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.white70,
              child: ListTile(
                onTap: () {},
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item number $index as title',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const Text(
                        'abcsddsfdsfsddffds',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ]),
                subtitle: const Row(children: [
                  Text(
                    '26 April, 2024',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(Icons.abc, size: 10.0),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text('High'),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
