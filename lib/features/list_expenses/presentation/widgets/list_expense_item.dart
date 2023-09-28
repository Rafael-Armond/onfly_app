import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onfly_app/features/list_expenses/business/entities/expense_entity.dart';

import '../controllers/remote/remote_expenses_controller.dart';
import 'custom_button.dart';

class ListExpenseItem extends StatefulWidget {
  const ListExpenseItem({
    super.key,
    required this.expenseEntity,
    required this.persisted,
    required this.index,
  });
  final ExpenseEntity expenseEntity;
  final bool persisted;
  final int index;

  @override
  State<ListExpenseItem> createState() => _ListExpenseItemState();
}

class _ListExpenseItemState extends State<ListExpenseItem> {
  bool isExpanded = false;

  final brCurrencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  final _remoteExpensesController = Get.find<RemoteExpensesController>();

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
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
                          widget.expenseEntity.collectionName ??
                              widget.expenseEntity.description!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _remoteExpensesController.getFormatedDate(
                              widget.expenseEntity.expenseDate!),
                        ),
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
                          children: [
                            Text(
                              brCurrencyFormat
                                  .format(widget.expenseEntity.amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            widget.expenseEntity.persisted!
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
                      callback: () => Get.toNamed(
                        '/addUpdateExpense',
                        arguments: {
                          "addExpenseMode": false,
                          "expenseEntity": widget.expenseEntity,
                        },
                      ),
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
                      callback: () => _remoteExpensesController
                          .deleteExpense(widget.expenseEntity.id!),
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
