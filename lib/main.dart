import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyHomePage(),
  ));
}

class Car {
  int id;
  bool isActive;

  Car({required this.id, this.isActive = false});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Car> cars = [];
  int clickCount = 0;
  dynamic _currId;
  final List<AnimationController> _animationControllers = [];

  viewListOfCars(Iterable<MapEntry<int, Car>> carsArr, bool isFirstRow,
      int plusesIndexes) {
    double cardWidth = (MediaQuery.of(context).size.width / 5) -
        ((MediaQuery.of(context).size.width / 5) * 0.1);
    double cardHeight = (cardWidth / 2) - (cardWidth * 0.1);

    return Container(
      padding: isFirstRow
          ? EdgeInsets.fromLTRB(0, 0, 0, cardHeight * 0.1)
          : EdgeInsets.fromLTRB(cardWidth / 1.85, 0, 0, cardHeight * 0.3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: carsArr.map((entry) {
          int index = entry.key + plusesIndexes;
          Car car = entry.value;

          AnimationController _animationController =
              _animationControllers[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                if (car.id != _currId && clickCount != 0) {
                  clickCount = 0;
                  _animationController.reverse();

                  int carIndex = cars.indexWhere((car) => car.id == _currId);
                  if (carIndex >= 0 && carIndex < cars.length) {
                    cars[carIndex].isActive = false;
                  }
                }

                clickCount++;
                car.isActive = true;

                // другий та наступні кліки, додавання анімації
                if (car.isActive && clickCount % 2 == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                _currId = car.id;
              });
            },
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: Stack(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      if (car.id == _currId) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0001)
                            ..rotateY(clickCount > 1
                                ? _animationController.value * pi
                                : 0),
                          child: car.isActive
                              ? Image.asset(
                                  'assets/images/autotruck_car_direct.png',
                                  height: cardHeight,
                                  width: cardWidth,
                                )
                              : Image.asset(
                                  'assets/images/autotruck_car.png',
                                  height: cardHeight,
                                  width: cardWidth,
                                ),
                        );
                      } else {
                        return car.isActive
                            ? Image.asset(
                                'assets/images/autotruck_car_direct.png',
                                height: cardHeight,
                                width: cardWidth,
                              )
                            : Image.asset(
                                'assets/images/autotruck_car.png',
                                height: cardHeight,
                                width: cardWidth,
                              );
                      }
                    },
                  ),
                  Positioned(
                    top: cardHeight / 3.5,
                    left: cardWidth / 2,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: cardHeight * 0.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      cars.add(Car(id: i + 1));
      _animationControllers.add(AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animate Truck'),
      ),
      body: Container(
        alignment: const Alignment(50, 50),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/autotruck_back.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            viewListOfCars(cars.asMap().entries.take(5), true, 0),
            viewListOfCars(cars.sublist(5).asMap().entries, false, 5),
          ],
        ),
      ),
    );
  }
}
