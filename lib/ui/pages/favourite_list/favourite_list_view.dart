import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wa_fuel/ui/pages/favourite_list/favourite_list_viewmodel.dart';

class FavouriteListView extends StatelessWidget {
  const FavouriteListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FavouriteListViewModel>.reactive(
      viewModelBuilder: () => FavouriteListViewModel(),
      builder: (context, model, child) => ListView.separated(
          itemBuilder: (context, index) => Container(),
          itemCount: model.favourites.length,
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 1),
      ),
    );
  }
}