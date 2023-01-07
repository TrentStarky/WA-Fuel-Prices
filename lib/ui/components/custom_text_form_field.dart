import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String title;
  final bool enabled;
  final List<String> items;
  final bool search;
  final void Function(String?)? onChanged;
  final String? selected;
  final TextEditingController? controller;

  const CustomTextFormField({
    Key? key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.search = false,
    this.selected,
    this.controller,
  }) : super(key: key);


  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              '${widget.title}:',
              style: TextStyle(fontWeight: FontWeight.bold), //todo FONTS
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              children: [
                // ButtonTheme(
                //   //key: widget.valueKey,
                //   alignedDropdown: true,
                //   child: DropdownSearch<String>(
                //     //key: widget.tempKey,
                //     emptyBuilder: (context, temp) => const Scaffold(
                //       body: Center(
                //         child: Text('No locations found'),
                //       ),
                //     ),
                //     selectedItem: widget.selected,
                //     mode: Mode.BOTTOM_SHEET,
                //     showClearButton: widget.selected == null ? true : false,
                //     showSearchBox: widget.search,
                //     enabled: widget.enabled,
                //     searchFieldProps: TextFieldProps(
                //       controller: widget.controller,
                //     ),
                //     dropdownSearchDecoration: const InputDecoration(
                //       hintText: 'Search...',
                //       hintStyle: TextStyle(color: Colors.grey),
                //       contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                //       border: OutlineInputBorder(),
                //     ),
                //     items: widget.items,
                //     onChanged: widget.onChanged,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}