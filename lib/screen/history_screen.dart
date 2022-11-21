import 'package:flutter/material.dart';
import 'package:hive_example/boxes.dart';
import 'package:hive_example/model/history_model.dart';
import 'package:hive_example/widgets/history_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Hive History Example'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<History>>(
          valueListenable: Boxes.getHistories().listenable(),
          builder: (context, box, _) {
            final histories = box.values.toList().cast<History>();

            return buildContent(histories);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => HistoryDialog(
              onClickedDone: addHistory,
            ),
          ),
        ),
      );

  Widget buildContent(List<History> histories) {
    if (histories.isEmpty) {
      return const Center(
        child: Text(
          'No history yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            'History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: histories.length,
              itemBuilder: (BuildContext context, int index) {
                final history = histories[index];
                return buildHistory(context, history);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildHistory(BuildContext context, History history) {
    final date = DateFormat.yMMMd().format(history.createdDate);
    final price = '\$${history.price.toStringAsFixed(0)}';

    return Card(
      color: Colors.white,
      child: ListTile(
        onLongPress: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HistoryDialog(
              history: history,
              onClickedDone: (name, price) => updateHistory(
                history,
                name,
                price,
              ),
            ),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            price,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          history.name,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(date),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          onPressed: () => deleteHistory(history),
          color: Colors.red,
        ),
      ),
    );
  }

  Future addHistory(String name, double price) async {
    final history =
        History(price: price, createdDate: DateTime.now(), name: name);

    final box = Boxes.getHistories();

    box.add(history);
  }

  void updateHistory(History history, String name, double price) {
    history.name = name;
    history.price = price;
    history.save();
  }

  void deleteHistory(History history) {
    history.delete();
  }
}
