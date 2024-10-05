/* Demonstrating a ListView -- a very flexible widget */

import 'package:flutter/Material.dart';

class App5 extends StatelessWidget {
  // final List<String> items = const ['Lions', 'Tigers', 'Bears', 'Oh my!'];

  const App5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My first list app'),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => print('Add button clicked')),
      body: ListView(
          // can you add the tiles 'Lions', 'Tigers', 'Bears', and 'Oh my!'? use list
          children: [
            //example of change below
            ListTile(
              title: const Text('Hello World!'),
              onTap: () => print('"Hello World!" clicked'),
            ),
          ]),
    );
  }
}


//children: items.map((items){ 
//  return ListTile(
//     title: Text(item),
//     onTap: () => print('$item was tapped'))    }).toList.()