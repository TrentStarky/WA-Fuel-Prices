// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_layout_grid/flutter_layout_grid.dart';
// import 'package:wa_fuel/resources.dart';

// class ProductSelector extends StatefulWidget {
//   const ProductSelector({Key? key}) : super(key: key);
//
//   @override
//   _ProductSelectorState createState() => _ProductSelectorState();
// }
//
// class _ProductSelectorState extends State<ProductSelector> {
//   int _selected = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: LayoutGrid(
//         rowSizes: [1.fr],
//         columnSizes: [1.fr, 1.fr, 1.fr, 1.fr],
//         children: [
//           Center(
//             child: SelectedProductTile(
//               text: Resources.productsShort.values.elementAt(_selected),
//               color: Resources.productsColors.values.elementAt(_selected),
//             ),
//           ),
//           for (int ii = 0; ii < 4 /* Resources.productsShort.values.length*/; ii++)
//             if (ii != _selected)
//               ProductTile(
//                 text: Resources.productsShort.values.elementAt(ii),
//                 onTapCallback: () => setState(() => _selected = ii),
//                 color: Colors.black,
//               ),
//         ],
//       ),
//     );
//   }
// }
//
// class ProductTile extends StatelessWidget {
//   final String text;
//   final void Function() onTapCallback;
//   final Color color;
//
//   const ProductTile({Key? key, required this.text, required this.onTapCallback, required this.color}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GestureDetector(
//         onTap: onTapCallback,
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(width: 2),
//             color: Colors.white,
//           ),
//           child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, ),),
//         ),
//       ),
//     );
//   }
// }
//
// class SelectedProductTile extends StatelessWidget {
//   final String text;
//   final Color color;
//
//   const SelectedProductTile({Key? key, required this.text,  required this.color}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(width: 2),
//           color: color,
//         ),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(width: 2, color: color),
//             color: Colors.white,
//           ),
//           child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//         ),
//       ),
//     );
//   }
// }