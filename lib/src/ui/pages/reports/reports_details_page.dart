import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsDetailsPage extends StatefulWidget {
  const ReportsDetailsPage(
      {required this.title,
      this.dateTimeRange,
      this.onDateRangeChanged,
      required this.items,
      Key? key})
      : super(key: key);
  final DateTimeRange? dateTimeRange;
  final void Function(DateTimeRange dateTimeRange)? onDateRangeChanged;
  final List<ReportItemModel> items;
  final String title;

  @override
  State<ReportsDetailsPage> createState() => _ReportsDetailsPageState();
}

class _ReportsDetailsPageState extends State<ReportsDetailsPage> {
  DateTimeRange _dateTimeRange =
      DateTimeRange(start: DateTime(2022), end: DateTime.now());
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    if (widget.dateTimeRange != null) {
      _dateTimeRange = widget.dateTimeRange!;
    }
    _dateController = TextEditingController(
        text:
            '${_dateTimeRange.start.toString().substring(0, 10)} - ${_dateTimeRange.end.toString().substring(0, 10)}');
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${widget.title} Reports'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // date filter
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    children: [
                      const Text('Date range:'),
                      Expanded(
                        child: TextField(
                          controller: _dateController,
                          textAlign: TextAlign.right,
                          readOnly: false,
                          onTap: () async {
                            var dtr = await showDateRangePicker(
                                context: context,
                                initialDateRange: _dateTimeRange,
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2069));

                            if (dtr != null) {
                              _dateTimeRange = dtr;
                              _dateController.text =
                                  '${_dateTimeRange.start.toString().substring(0, 10)} - ${_dateTimeRange.end.toString().substring(0, 10)}';
                              widget.onDateRangeChanged?.call(_dateTimeRange);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // bar chart
              SizedBox(
                  height: 500,
                  child: BarChart(
                    BarChartData(
                        barGroups: widget.items.toChartData(20),
                        titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        )))),
                  )),

              //  labels
              DataTable(
                columns: const [
                  DataColumn(
                      label: Text('',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Amount',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Expense',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Score',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                ],
                rows: widget.items.toDataRow(),
              ),
            ],
          ),
        ));
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    Widget text = Text(
      widget.items[value.toInt()].label,
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }
}

class ReportItemModel {
  ReportItemModel({
    required this.label,
    required this.amount,
    required this.expense,
  });
  final String label;
  //final double amounter;
  final double expense;
  double amount = 0.0;

  // double amounts() {
  //   amounter.map((event) => amount = event);

  
  //   return amount;
  // }

  int get score {
    if (amount == 0 || expense == 0) {
      return 0;
    } else {
      return (100 - expense * 100 / amount).floor();
    }
  }
}

extension ListReportItemModelToChartData on List<ReportItemModel> {
  List<BarChartGroupData> toChartData(double width) {
    List<ReportItemModel> items = this;
    List<BarChartGroupData> l = [];
    for (var i = 0; i < length; i++) {
      l.add(BarChartGroupData(barsSpace: 4, x: i, barRods: [
        BarChartRodData(
            toY: items[i].amount, color: Colors.green, width: width),
        BarChartRodData(
            toY: items[i].expense, color: Colors.redAccent, width: width)
      ]));
    }
    return l;
  }

  List<DataRow> toDataRow() {
    return map<DataRow>((e) => DataRow(cells: [
          DataCell(Text(e.label)),
          DataCell(Text(e.amount.toString())),
          DataCell(Text(e.expense.toString())),
          DataCell(Text('${e.score}%')),
        ])).toList();
  }
}
