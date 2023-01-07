// import 'package:flutter/material.dart' hide FormField;
// import 'package:stacked/stacked.dart';
// import 'package:wa_fuel/app/app_colors.dart';
// import 'package:wa_fuel/app/app_constants.dart';
// import 'package:wa_fuel/ui/components/custom_text_form_field.dart';
// import 'package:wa_fuel/ui/pages/search/search_viewmodel.dart';
//
// class SearchView extends StatefulWidget {
//   const SearchView({Key? key}) : super(key: key);
//
//   @override
//   State<SearchView> createState() => _SearchViewState();
// }
//
// class _SearchViewState extends State<SearchView> with SingleTickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<SearchViewModel>.reactive(
//       viewModelBuilder: () => SearchViewModel(),
//       builder: (context, model, child) => ListView(
//         children: [
//           CustomTextFormField(
//             title: 'Product',
//             items: AppConstants.rssProducts.values.toList(),
//             onChanged: model.changeProduct,
//           ),
//           CustomTextFormField(
//             title: 'Brand',
//             items: AppConstants.rssBrands.values.toList(),
//             onChanged: model.changeBrand,
//           ),
//           AnimatedSize(
//             alignment: Alignment.topCenter,
//             duration: const Duration(milliseconds: 500),
//             child: SizedBox(
//               height: (model.selectedArea == SelectedArea.suburb) ? 0 : null,
//               child: CustomTextFormField(
//                 title: 'Region',
//                 search: true,
//                 items: AppConstants.rssRegions.values.toList(),
//                 onChanged: model.changeRegion,
//               ),
//             ),
//           ),
//           AnimatedSize(
//             duration: const Duration(milliseconds: 500),
//             child: SizedBox(
//               height: (model.selectedArea != SelectedArea.none) ? 0 : null,
//               child: Center(
//                 child: Text('-- OR --'),
//               ),
//             ),
//           ),
//           AnimatedSize(
//             alignment: Alignment.topCenter,
//             duration: const Duration(milliseconds: 500),
//             child: SizedBox(
//               height: (model.selectedArea == SelectedArea.region) ? 0 : null,
//               child: CustomTextFormField(
//                 title: 'Suburb',
//                 search: true,
//                 items: AppConstants.rssSuburbs.toList(),
//                 onChanged: model.changeSuburb,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 elevation: 0, primary: colorPrimaryOrange),
//             onPressed: model.search,
//             child: Text('Search'),
//           )
//         ],
//       ),
//     );
//   }
// }
