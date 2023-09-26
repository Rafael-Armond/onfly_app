import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../controllers/remote/remote_expenses_controller.dart';
import 'custom_button.dart';

class ListExpenseItem extends StatefulWidget {
  const ListExpenseItem({
    super.key,
    required this.title,
    required this.description,
    required this.expenseDate,
    required this.amount,
    required this.persisted,
    required this.index,
    required this.id,
  });

  final String title;
  final String description;
  final String expenseDate;
  final double amount;
  final bool persisted;
  final int index;
  final String id;

  @override
  State<ListExpenseItem> createState() => _ListExpenseItemState();
}

class _ListExpenseItemState extends State<ListExpenseItem> {
  bool isExpanded = false;

  final brCurrencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  final RemoteExpensesController _remoteExpensesController =
      GetIt.instance<RemoteExpensesController>();

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  String getFormatedDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/"
          "${dateTime.month.toString().padLeft(2, '0')}/"
          "${dateTime.year}";

      return formattedDate;
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(8.0),
      color: const Color.fromRGBO(173, 216, 230, 1.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(getFormatedDate(widget.expenseDate)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              brCurrencyFormat.format(widget.amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            widget.persisted
                                ? const Icon(Icons.cloud)
                                : const Icon(Icons.cloud_off),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: toggleExpanded,
                              child: isExpanded
                                  ? const Icon(Icons.arrow_upward)
                                  : const Icon(Icons.arrow_downward),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isExpanded,
              child: TextField(
                decoration: InputDecoration(
                  hintText: _remoteExpensesController
                      .allExpenses[widget.index].description,
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(4),
                ),
                keyboardType: TextInputType.text,
                maxLines: 2,
                readOnly: true,
                enabled: false,
              ),
            ),
            Visibility(
              visible: isExpanded,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Editar',
                      color: Colors.lightGreen,
                      callback: () =>
                          Get.toNamed('/addUpdateExpense', parameters: {
                        "addExpenseMode": "false",
                        "description": widget.description,
                        "expenseDate": widget.expenseDate,
                        "amount": widget.amount.toString(),
                        "idExpense": widget.id,
                      }),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Deletar',
                      color: Colors.red,
                      callback: () =>
                          _remoteExpensesController.deleteExpense(widget.id),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
