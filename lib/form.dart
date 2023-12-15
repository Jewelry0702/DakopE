import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:printer/databasehelper.dart';
import 'printutil.dart';
import 'package:flutter/services.dart';

class TicketForm extends StatefulWidget {
  String? data;
  TicketForm({super.key, this.data});
  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final BlueThermalPrinter instance = BlueThermalPrinter.instance;
  final List<String> items = [
    "No helmet",
    "Illegal parking",
    "No license",
    "Other Violation",
    "No Parking",
    "No U-Turn",
    "One-Way",
    "No Left-Turn",
    "Loading-Unloading"
  ];

  late Map<String, bool> itemChecked;

  bool valuefirst = false;
  bool valuesecond = false;
  bool isExpire = false;
  String inputText = "";
  // Controllers for each TextField
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dlPermitNoController = TextEditingController();
  final _plateNoController = TextEditingController();
  final _crNoController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _placeOfViolationController = TextEditingController();
  final _ownerController = TextEditingController();
  final _ownerAddressController = TextEditingController();
  final _officerNameController = TextEditingController();
  final _designationController = TextEditingController();

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${_dateController.text}'),
                Text('Driver\'s Name: ${_nameController.text}'),
                Text('Address: ${_addressController.text}'),
                Text('DL/Permit No: ${_dlPermitNoController.text}'),
                Text('Plate No: ${_plateNoController.text}'),
                Text('CR No: ${_crNoController.text}'),
                Text('Make: ${_makeController.text}'),
                Text('Model: ${_modelController.text}'),
                Text('Place of Violation: ${_placeOfViolationController.text}'),
                Text('Owner: ${_ownerController.text}'),
                Text('Owner Address: ${_ownerAddressController.text}'),
                Text(
                    'Violations: ${itemChecked.keys.where((item) => itemChecked[item]!).join(", ")}'),
                Text('Admitted: $valuefirst'),
                Text('Under protest: $valuesecond'),
                Text('Officer Name: ${_officerNameController.text}'),
                Text('Designation: ${_designationController.text}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                _printFormData(); // Call the function to print the form data
              },
              child: const Text('Print Receipt'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    itemChecked = {for (var item in items) item: false};
    if (widget.data != null) {
      _plateNoController.text = widget.data!;
      DatabaseHelper.instance
          .getDataFromPlateNum(widget.data!)
          .then((value) => {
                if (value.isNotEmpty)
                  {
                    setState(() {
                      _nameController.text = value.first['ownerName'];
                      _modelController.text = value.first['model'];
                      _crNoController.text = value.first['CRNum'];
                      _dlPermitNoController.text = value.first['permitNum'];
                      isExpire = value.first['isExpired'] == 1 ? true : false;
                    }),
                  }
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Citation Ticket'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Date:",
                  style: TextStyle(
                    fontFamily: "Times New Roman",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 120,
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'MM/dd/yyyy',
                        hintStyle: TextStyle(
                          fontFamily: "Arial",
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                        )),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      var d = pickedDate;
                      String format = "${d!.month}/${d.day}/${d.year}";
                      _dateController.text = format;
                    },
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Driver's Name:"),
          ),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: "Address:"),
          ),
          TextField(
            controller: _dlPermitNoController,
            decoration: const InputDecoration(labelText: "DL/Permit #:"),
          ),
          TextField(
            controller: _plateNoController,
            decoration: const InputDecoration(labelText: "Plate #:"),
          ),
          TextField(
            controller: _crNoController,
            decoration: const InputDecoration(labelText: "CR #:"),
          ),
          TextField(
            controller: _makeController,
            decoration: const InputDecoration(labelText: "Make:"),
          ),
          TextField(
            controller: _modelController,
            decoration: const InputDecoration(labelText: "Model:"),
          ),
          TextField(
            controller: _timeController,
            decoration: const InputDecoration(labelText: "Time of Violation:"),
          ),
          TextField(
            controller: _placeOfViolationController,
            decoration: const InputDecoration(labelText: "Place of Violation:"),
          ),
          TextField(
            controller: _ownerController,
            decoration: const InputDecoration(labelText: "Owner:"),
          ),
          TextField(
            controller: _ownerAddressController,
            decoration: const InputDecoration(labelText: "Owner Address:"),
          ),
          Center(
            child: PopupMenuButton<String>(
              onSelected: (selectedItem) {
                setState(() {
                  itemChecked[selectedItem] = !itemChecked[selectedItem]!;
                });
              },
              itemBuilder: (BuildContext context) {
                return items.map((item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Row(
                      children: [
                        Checkbox(
                          value: itemChecked[item],
                          onChanged: (bool? value) {
                            setState(() {
                              itemChecked[item] = value!;
                            });
                          },
                        ),
                        Text(item),
                      ],
                    ),
                  );
                }).toList();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Violations"),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text('Admitted'),
            value: valuefirst,
            onChanged: (value) {
              setState(() {
                valuefirst = value!;
              });
            },
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text('Under protest'),
            value: valuesecond,
            onChanged: (value) {
              setState(() {
                valuesecond = value!;
              });
            },
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text('Is Expire'),
            value: isExpire,
            onChanged: (value) {
              setState(() {
                isExpire = value!;
              });
            },
          ),
          TextField(
            controller: _officerNameController,
            decoration: const InputDecoration(labelText: "Officer Name:"),
          ),
          TextField(
            controller: _designationController,
            decoration: const InputDecoration(labelText: "Designation:"),
          ),
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _printFormData() {
    itemChecked.keys.where((item) => itemChecked[item]!).forEach((violation) {
      var insert = {
        'ownerName': _nameController.text,
        'plateNum': _plateNoController.text,
        'model': _modelController.text,
        'CRNum': _crNoController.text,
        'permitNum': _dlPermitNoController.text,
        'date': _dateController.text,
        'place': _placeOfViolationController.text,
        'violation': violation,
      };
      DatabaseHelper.instance.insertViolation(insert);
    });

    instance.isConnected.then((isConnected) {
      if (isConnected == true) {
        instance.printCustom("Date: ${_dateController.text}",
            Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom(
            "Drivers\\'s Name:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _nameController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom(
            "Address\\'s:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _addressController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom(
            "DL/Permit No:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _dlPermitNoController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom("Plate No:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _plateNoController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom("CR No:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _crNoController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom("Make:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _makeController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom("Model:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _modelController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom(
            "Place of Violation:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(_placeOfViolationController.text,
            Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom("Owner:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _ownerController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom(
            "Owner Address:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _ownerAddressController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom(
            "Violations:", Size.boldMedium.val, PAlign.left.val);

        itemChecked.keys.where((item) => itemChecked[item]!).forEach((element) {
          instance.printCustom(element, Size.boldMedium.val, PAlign.left.val);
          instance.printNewLine();
        });

        instance.printCustom("Admitted:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            valuefirst ? 'Yes' : 'No', Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom(
            "Under protest:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            valuesecond ? 'Yes' : 'No', Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom(
            "Officer Name:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _officerNameController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();

        instance.printCustom(
            "Designation:", Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
        instance.printCustom(
            _designationController.text, Size.boldMedium.val, PAlign.left.val);
        instance.printNewLine();
      }
    });
  }

  @override
  void dispose() {
    // Dispose the TextEditingControllers
    instance.disconnect();
    _dateController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _dlPermitNoController.dispose();
    _plateNoController.dispose();
    _crNoController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _placeOfViolationController.dispose();
    _ownerController.dispose();
    _ownerAddressController.dispose();
    _officerNameController.dispose();
    _designationController.dispose();
    super.dispose();
  }
}
