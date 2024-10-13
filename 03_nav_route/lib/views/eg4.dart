/* Topics demonstrated:
 * - Common list -> detail drill-down pattern
 * - Simplifying state management using the `provider` package
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/macguffin.dart';

class MacGuffinCollection with ChangeNotifier {
  final List<MacGuffin> _macGuffins;

  MacGuffinCollection(int numMacGuffins)
      : _macGuffins = List.generate(numMacGuffins,
            (index) => MacGuffin(name: 'MacGuffin ${index + 1}'));

  int get length => _macGuffins.length;

  MacGuffin operator [](int index) => _macGuffins[index];

  void update(int index, MacGuffin macGuffin) {
    _macGuffins[index] = macGuffin;
    notifyListeners(); //notices update to data
  }
}

class App4 extends StatelessWidget {
  const App4({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App 2',
      home: ChangeNotifierProvider(
          // this widget ensures that the collection will be created only once
          create: (context) => MacGuffinCollection(50),

          // MacGuffins are inherited rather than passed explicitly
          child: const MacGuffinsListPage()),
    );
  }
}

//stateful widget will wrap the list state, this means if a change is made from one route when they go bakc the position is the same

class MacGuffinsListPage extends StatelessWidget {
  const MacGuffinsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('MacGuffins')),

        // we are a consumer of the MacGuffinCollection, so will be rebuilt
        // whenever the collection notifies us that it has changed
        body: Consumer<MacGuffinCollection>(
            builder: (context, collection, _) => ListView.builder(
                itemCount: collection.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(collection[index].name),
                    subtitle: Text(collection[index].description ?? ''),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        // ChangeNotifierProvider is scoped by route, so
                        // we need to create a new one for the new route, but
                        // we also use a different constructor to pass the
                        // existing collection (rather than creating a new one)
                        return ChangeNotifierProvider<
                                MacGuffinCollection>.value(
                            value: collection,

                            // new route inherits the collection, so we don't have
                            // to pass it the MacGuffin object, just the index
                            child: MacGuffinEditPage(index));
                      }));
                    },
                  );
                })));
  }
}

class MacGuffinEditPage extends StatefulWidget {
  final int index;

  const MacGuffinEditPage(this.index, {super.key});

  @override
  State<MacGuffinEditPage> createState() => _MacGuffinEditPageState();
}

class _MacGuffinEditPageState extends State<MacGuffinEditPage> {
  late MacGuffin _editedMacGuffin;
  late MacGuffinCollection _collection;

  @override
  void initState() {
    super.initState();
    // grab the collection and the MacGuffin we're editing from the context
    _collection = Provider.of<MacGuffinCollection>(context, listen: false);

    // make a copy of the one we're editing so we can cancel/commit changes
    _editedMacGuffin = MacGuffin.from(_collection[widget.index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Edit MacGuffin')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextFormField(
                  initialValue: _editedMacGuffin.name,
                  decoration: const InputDecoration(hintText: 'Name'),
                  onChanged: (value) => _editedMacGuffin.name = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextFormField(
                  initialValue: _editedMacGuffin.description,
                  decoration: const InputDecoration(hintText: 'Description'),
                  onChanged: (value) => _editedMacGuffin.description = value,
                ),
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  // just update the MacGuffin in the collection -- it will
                  // take care of notifying its listeners
                  _collection.update(widget.index, _editedMacGuffin);

                  // no need to return anything!
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
