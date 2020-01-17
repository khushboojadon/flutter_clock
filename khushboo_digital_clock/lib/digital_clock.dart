import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flip_panel/flip_panel.dart';
import 'globals.dart' as globals;

final Color background = Colors.white;

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  Color _color;
  Color _secondColor;
  var _temperature = '';
  var _location = '';

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
      _temperature = widget.model.temperatureString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.

      _timer = Timer(
        Duration(seconds: 1) -
            /* Duration(seconds: _dateTime.second) -*/
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _color = Colors.white;
    _secondColor = Colors.white;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text('Hours',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                    ),
                    FlipWidget(
                      child: hour,
                      bgColor: _color,
                      txtColor: Colors.black,
                      duration: Duration(hours: 1),
                    ),
                  ],
                ),
                Text(":", style: TextStyle(color: Colors.white, fontSize: 100)),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text('Minutes',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                    ),
                    FlipWidget(
                      child: minute,
                      bgColor: _secondColor,
                      txtColor: Colors.black,
                      duration: Duration(minutes: 1),
                    ),
                  ],
                ),
                Text(":", style: TextStyle(color: Colors.white, fontSize: 100)),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text('Seconds',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                    ),
                    FlipWidget(
                      child: second,
                      bgColor: _secondColor,
                      txtColor: Colors.black,
                      duration: Duration(seconds: 1),
                    ),
                  ],
                ),
              ]),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 30.0),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Text(
                          _location,
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                          semanticsLabel:
                              "${globals.semantics['location']} $_location",
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _temperature,
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                          semanticsLabel:
                              "${globals.semantics['temperature']} $_temperature",
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class FlipWidget extends StatelessWidget {
  final String child;
  final Color bgColor, txtColor;
  final Duration duration;
  const FlipWidget({this.child, this.bgColor, this.txtColor, this.duration});

  @override
  Widget build(BuildContext context) {
    return FlipPanel.builder(
      itemBuilder: (context, index) => Container(
        alignment: Alignment.center,
        width: 110.0,
        height: 110.0,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Text(
          child,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 80.0, color: txtColor),
        ),
      ),
      itemsCount: child.length,
      period: duration,
      loop: -1,
    );
  }
}
