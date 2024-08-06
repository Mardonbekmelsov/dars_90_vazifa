import 'package:dars_90_vazifa/blocs/card/card_bloc.dart';
import 'package:dars_90_vazifa/blocs/card/card_state.dart';
import 'package:dars_90_vazifa/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardScreen extends StatefulWidget {
  final String userId;

  const CardScreen({required this.userId, super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {

final List<Gradient> gradients = [
  LinearGradient(colors: [Colors.teal, Colors.tealAccent]),
  LinearGradient(colors: [Colors.indigo, Colors.indigoAccent]),
  LinearGradient(colors: [Colors.cyan, Colors.cyanAccent]),
  LinearGradient(colors: [Colors.yellow, Colors.amber]),
  LinearGradient(colors: [Colors.deepOrange, Colors.orangeAccent]),
  LinearGradient(colors: [Colors.lime, Colors.limeAccent]),
  LinearGradient(colors: [Colors.brown, Colors.orange]),
  LinearGradient(colors: [Colors.grey, Colors.blueGrey]),
  LinearGradient(colors: [Colors.blue, Colors.cyan]),
  LinearGradient(colors: [Colors.purple, Colors.deepPurpleAccent]),
];


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => HomeScreen()),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.h,
          ),
        ),
        title: Text(
          'Cards',
          style: TextStyle(fontSize: 20.h),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CardBloc, CardState>(
                builder: (context, state) {
                  if (state is CardLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CardLoaded) {
                    return ListView.builder(
                      itemCount: state.cards.length,
                      itemBuilder: (context, index) {
                        final card = state.cards[index];
                        final gradient = gradients[index % gradients.length];
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${card.fullname}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text('${card.number}',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5),
                              Text('${card.expiryDate.toLocal()}'.split(' ')[0],
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5),
                              Text('\$${card.balance.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5),
                              Text('${card.bankName}',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5),
                              Text('${card.cardName}',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5),
                              Text('${card.type}',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is CardOperationFailure) {
                    return Center(
                      child: Text('Failed to load cards: ${state.error}'),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
