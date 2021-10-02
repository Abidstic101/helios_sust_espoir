import 'package:flutter/material.dart';
import 'package:helios/data_model.dart';
import 'package:helios/networking.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphBuilder extends StatefulWidget {
  final String temporal;
  final String parameter;
  final double lat;
  final double long;
  final String start;
  final String end;
  GraphBuilder(
      {required this.temporal,
      required this.parameter,
      required this.lat,
      required this.long,
      required this.start,
      required this.end});

  @override
  _GraphBuilderState createState() => _GraphBuilderState();
}

class _GraphBuilderState extends State<GraphBuilder> {
  late ZoomPanBehavior _zoomPanBehavior;
  Network network = Network();
  Map<String, double> database = {};
  List<DataModel> dataEntries = [];

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    getData();
  }

  Future<void> getData() async {
    database = await network.getData(
      temporal: widget.temporal,
      parameter: widget.parameter,
      start: widget.start,
      end: widget.end,
      lat: widget.lat,
      long: widget.long,
    );
    dataEntry();
  }

  void dataEntry() {
    for (var element in database.entries) {
      dataEntries.add(
          DataModel(time: DateTime.parse(element.key), value: element.value));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      enableAxisAnimation: true,
      zoomPanBehavior: _zoomPanBehavior,
      primaryXAxis: DateTimeAxis(),
      series: <ChartSeries>[
        LineSeries<DataModel, DateTime>(
          dataSource: dataEntries,
          xValueMapper: (DataModel data, _) => data.time,
          yValueMapper: (DataModel data, _) => data.value,
        ),
      ],
    );
  }
}
