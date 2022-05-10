import 'package:flutter/material.dart';
import 'package:hiveflutter/models/product.dart';
import 'package:intl/intl.dart';

class ProductDialog extends StatefulWidget {
  final Product? product;
  final Function(
    String name,
    double amount,
    DateTime date,
    String description,
  ) onClickedDone;

  const ProductDialog({
    Key? key,
    this.product,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  var selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      final student = widget.product!;
      nameCtrl.text = student.name;
      amountCtrl.text = student.amount.toString();
      dateCtrl.text = DateFormat("dd-MM-yyyy").format(student.date);
      selectedDate = student.date;
      descriptionCtrl.text = student.description;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    dateCtrl.dispose();
    amountCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateCtrl.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final title = isEditing ? 'Edit Product' : 'Add Product';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              nameField(),
              const SizedBox(height: 8),
              amtField(),
              const SizedBox(height: 8),
              dateField(),
              const SizedBox(height: 8),
              descriptionField()
            ],
          ),
        ),
      ),
      actions: <Widget>[
        cancelButton(context),
        addButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget nameField() => TextFormField(
        controller: nameCtrl,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Product Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter Product Name' : null,
      );

  Widget amtField() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Amount',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null
            ? 'Enter a amount'
            : null,
        controller: amountCtrl,
      );

  Widget dateField() => GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextFormField(
            controller: dateCtrl,
            decoration: const InputDecoration(
              labelText: "Date",
              border: OutlineInputBorder(),
              icon: Icon(Icons.calendar_today),
            ),
            validator: (value) {
              if (value!.isEmpty) return "Please enter a date for your task";
              return null;
            },
          ),
        ),
      );

  Widget descriptionField() => TextFormField(
        controller: descriptionCtrl,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Description',
        ),
        validator: (value) =>
            value != null && value.isEmpty ? 'Enter a Description' : null,
      );

  Widget cancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget addButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameCtrl.text;
          final amount = double.tryParse(amountCtrl.text);
          final date = selectedDate;
          final description = descriptionCtrl.text;
          widget.onClickedDone(
            name,
            amount!,
            date,
            description,
          );
          Navigator.of(context).pop();
        }
      },
    );
  }
}
