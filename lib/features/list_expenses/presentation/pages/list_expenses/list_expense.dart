//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:onfly_app/features/list_expenses/business/entities/expense_entity.dart';

import '../../../../../core/error/error_widget.dart';
import '../../controllers/remote/remote_expenses_controller.dart';
import '../../widgets/list_expense_item.dart';
import '../../widgets/total_amount_expenses.dart';

class ListExpenses extends StatelessWidget {
  ListExpenses({super.key});

  final RemoteExpensesController _remoteExpensesController =
      GetIt.instance<RemoteExpensesController>();
  // TODO
  //final Connectivity _connectivity = Connectivity();

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
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final title = snapshot.data![index].collectionName;
                    final description = snapshot.data![index].description;
                    final expenseDate = snapshot.data![index].expenseDate;
                    final amount = snapshot.data![index].amount;
                    final persisted = snapshot.data![index].persisted;
                    final id = snapshot.data![index].id;
                    return ListExpenseItem(
                      amount: amount!,
                      description: description!,
                      expenseDate: expenseDate!,
                      title: title!,
                      persisted: persisted!,
                      index: index,
                      id: id!,
                    );
                  },
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
              child: ErrorMessage(errorMessage: "Erro ao carregar os dados"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(
          '/addUpdateExpense',
          parameters: {"addExpenseMode": "true"},
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
