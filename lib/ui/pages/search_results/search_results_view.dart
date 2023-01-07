import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wa_fuel/app/app_colors.dart';
import 'package:wa_fuel/ui/pages/search_results/search_results_viewmodel.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchResultsViewModel>.reactive(
      viewModelBuilder: () => SearchResultsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('WA Fuel Prices'),
          centerTitle: true,
          backgroundColor: colorPrimaryOrange,
          elevation: 0,
        ),
        body: ListView(
          children: [

          ],
        ),
      ),
    );
  }
}