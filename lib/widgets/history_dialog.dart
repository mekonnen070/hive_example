import 'package:flutter/material.dart';
import 'package:hive_example/model/history_model.dart';

class HistoryDialog extends StatefulWidget {
  final History? history;
  final Function(String name, double price) onClickedDone;

  const HistoryDialog({
    Key? key,
    this.history,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _HistoryDialogState createState() => _HistoryDialogState();
}

class _HistoryDialogState extends State<HistoryDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.history != null) {
      final history = widget.history!;
      nameController.text = history.name;
      priceController.text = history.price.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.history != null;
    final title = isEditing ? 'Edit History' : 'Add History';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              buildName(),
              const SizedBox(height: 8),
              buildPrice(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildPrice() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Price',
        ),
        keyboardType: TextInputType.number,
        validator: (price) => price != null && double.tryParse(price) == null
            ? 'Enter a valid number'
            : null,
        controller: priceController,
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final price = priceController.text;

          widget.onClickedDone(name, double.tryParse(price)!);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
