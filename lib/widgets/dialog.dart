// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:hiveflutter/models/product.dart';
import 'package:intl/intl.dart';

class ProductDialog extends StatefulWidget {
  final Product? product;
  final Function(String name, double amount, DateTime date, List specs)
      onClickedDone;

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
  final dateCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  var selectedDate;
  var productname;
  List listSpec = [];
  final _currencies = [
    "Orange",
    "Mango",
    "Biscuit",
    "Chocolate",
    "Pen",
    "IceCream",
    "Strawberry",
    "Milk"
  ];

  final specs = ["Fresh", "Cheap", "Costly", "Offer", "Deal of Day"];

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      final student = widget.product!;
      productname = student.name;
      amountCtrl.text = student.amount.toString();
      dateCtrl.text = DateFormat("dd-MM-yyyy").format(student.date);
      selectedDate = student.date;
      listSpec = student.specs;
    }
  }

  @override
  void dispose() {
    dateCtrl.dispose();
    amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
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
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.indigo),
      ),
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
              specField(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        cancelButton(context),
        addButton(context, isEditing: isEditing),
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }

  Widget nameField() => FormField<String>(
        validator: (value) {
          if (productname == null) {
            return 'Please select a Product';
          }
        },
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                errorText: state
                    .errorText, //by this method we can give error msg in dropdown field.
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: productname,
                hint: const Text("Select a Product"),
                isDense: true,
                onChanged: (String? newValue) {
                  setState(() {
                    productname = newValue;
                    state.didChange(newValue);
                  });
                },
                items: _currencies.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );

  Widget amtField() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Amount',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null
            ? 'Please enter a Amount'
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
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) {
              if (value!.isEmpty) return "Please enter a date";
              return null;
            },
          ),
        ),
      );

  Widget specField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Specs :"),
          Wrap(
            children: specs.map((e) {
              return InkWell(
                onTap: () {
                  setState(() {
                    listSpec.contains(e) ? listSpec.remove(e) : listSpec.add(e);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Chip(
                    backgroundColor:
                        listSpec.contains(e) ? Colors.indigo : Colors.grey,
                    label: Text(e),
                    labelStyle: TextStyle(
                        color:
                            listSpec.contains(e) ? Colors.white : Colors.black),
                    padding: const EdgeInsets.all(2),
                    elevation: 3,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );

  Widget cancelButton(BuildContext context) => customButton(context,
      title: 'Cancel', onPressed: () => Navigator.of(context).pop());

  Widget addButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';
    return customButton(
      context,
      title: text,
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = productname;
          final amount = double.tryParse(amountCtrl.text);
          final date = selectedDate;
          final specs = listSpec;
          widget.onClickedDone(name, amount!, date, specs);
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget customButton(BuildContext context,
      {required String title, required void Function()? onPressed}) {
    return SizedBox(
      width: 100,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.indigo,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(title, style: const TextStyle(color: Colors.white)),
        onPressed: onPressed,
      ),
    );
  }
}
