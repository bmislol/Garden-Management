import 'package:flutter/material.dart';

class PotsDisplay extends StatefulWidget {
  final int chosenPots;
  final int budget;
  PotsDisplay({required this.chosenPots, required this.budget});

  @override
  _PotsDisplayState createState() => _PotsDisplayState();
}

class _PotsDisplayState extends State<PotsDisplay> {
  late int budget;
  late List<String?> potTypes;
  late List<int> wateringCounts;
  late String selectedAction;
  String selectedPlantType = 'flower';

  @override
  void initState() {
    super.initState();
    budget = widget.budget;
    potTypes = List.generate(widget.chosenPots, (_) => null);
    wateringCounts = List.generate(widget.chosenPots, (_) => 0);
    selectedAction = 'plant';
  }

  void handlePotAction(int index) {
    if (selectedAction == 'plant') {
      if (potTypes[index] != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pot already has a plant. Remove it first.')));
      } else {
        if (selectedPlantType == 'flower' && budget >= 10) {
          setState(() {
            budget -= 10;
            potTypes[index] = 'flower';
            wateringCounts[index] = 0;
          });
        } else if (selectedPlantType == 'tree' && budget >= 20) {
          setState(() {
            budget -= 20;
            potTypes[index] = 'tree';
            wateringCounts[index] = 0;
          });
        } else if (selectedPlantType == 'bush' && budget >= 30) {
          setState(() {
            budget -= 30;
            potTypes[index] = 'bush';
            wateringCounts[index] = 0;
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Not enough budget to buy this plant')));
        }
      }
    } else if (selectedAction == 'water') {
      if (potTypes[index] != null) {
        if (budget >= 25) {
          setState(() {
            budget -= 25;
            wateringCounts[index]++;
            if (wateringCounts[index] == 3) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${potTypes[index]} grew successfully!')));
              budget += potTypes[index] == 'flower' ? 15 : potTypes[index] == 'tree' ? 25 : 35;
              potTypes[index] = null;
              wateringCounts[index] = 0;
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not enough budget to water')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No plant to water')));
      }
    } else if (selectedAction == 'remove') {
      if (potTypes[index] != null) {
        setState(() {
          budget += potTypes[index] == 'flower' ? 10 : potTypes[index] == 'tree' ? 20 : 30;
          potTypes[index] = null;
          wateringCounts[index] = 0;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No plant to remove')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pots Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Budget: \$${budget}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(widget.chosenPots, (index) {
                return ElevatedButton(
                  onPressed: () => handlePotAction(index),
                  child: Text(potTypes[index] ?? 'Pot ${index + 1}'),
                );
              }),
            ),
            SizedBox(height: 20),
            Text(
              'Actions:',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 'plant',
                  groupValue: selectedAction,
                  onChanged: (value) {
                    setState(() {
                      selectedAction = value as String;
                    });
                  },
                ),
                Text('Plant'),
                Radio(
                  value: 'water',
                  groupValue: selectedAction,
                  onChanged: (value) {
                    setState(() {
                      selectedAction = value as String;
                    });
                  },
                ),
                Text('Water'),
                Radio(
                  value: 'remove',
                  groupValue: selectedAction,
                  onChanged: (value) {
                    setState(() {
                      selectedAction = value as String;
                    });
                  },
                ),
                Text('Remove'),
              ],
            ),
            if (selectedAction == 'plant')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 'flower',
                    groupValue: selectedPlantType,
                    onChanged: (value) {
                      setState(() {
                        selectedPlantType = value as String;
                      });
                    },
                  ),
                  Text('Flower (\$10)'),
                  Radio(
                    value: 'tree',
                    groupValue: selectedPlantType,
                    onChanged: (value) {
                      setState(() {
                        selectedPlantType = value as String;
                      });
                    },
                  ),
                  Text('Tree (\$20)'),
                  Radio(
                    value: 'bush',
                    groupValue: selectedPlantType,
                    onChanged: (value) {
                      setState(() {
                        selectedPlantType = value as String;
                      });
                    },
                  ),
                  Text('Bush (\$30)'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
