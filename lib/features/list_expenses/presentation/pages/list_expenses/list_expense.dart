import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onfly_app/features/list_expenses/business/entities/expense_entity.dart';

import '../../../../../core/error/error_widget.dart';
import '../../controllers/remote/remote_expenses_controller.dart';
import '../../widgets/list_expense_item.dart';
import '../../widgets/total_amount_expenses.dart';

class ListExpenses extends StatelessWidget {
  ListExpenses({super.key});

  final _remoteExpensesController = Get.find<RemoteExpensesController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Onfly",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ExpenseEntity>>(
        initialData: _remoteExpensesController.allExpenses,
        future: _remoteExpensesController.onGetExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenWidth * 0.09,
                ),
                child: const CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data!.isNotEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenWidth * 0.09,
                ),
                child: Obx(
                  () => ListView.builder(
                    itemCount: _remoteExpensesController.allExpenses.length,
                    itemBuilder: (context, index) {
                      final persisted = snapshot.data![index].persisted;
                      return ListExpenseItem(
                        expenseEntity: snapshot.data![index],
                        index: index,
                        persisted: persisted!,
                      );
                    },
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ErrorMessage(errorMessage: "Erro ao carregar os dados"),
              ),
            );
          }

          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ErrorMessage(errorMessage: "Não há despesas cadastradas"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(
          '/addUpdateExpense',
          arguments: {"addExpenseMode": true},
        ),
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        child: Obx(
          () => TotalAmountExpenses(
            amount: _remoteExpensesController.totalAmount.value,
          ),
        ),
      ),
    );
  }
}
