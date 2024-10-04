part of '../../../flutter_loggy.dart';

class WrongPrinterException implements Exception {
  WrongPrinterException();

  @override
  String toString() {
    return 'ERROR: Loggy printer is not set as StreamPrinter!\n\n';
  }
}

/// This widget will display log from Loggy in a widget.
/// Widget needs [StreamPrinter] set as printer on loggy.
///
/// ```dart
/// Loggy.initLoggy(
///   logPrinter: StreamPrinter(PrettyDeveloperPrinter()),
/// );
/// ```
class LoggyStreamWidget extends StatelessWidget {
  const LoggyStreamWidget({
    this.logLevel = LogLevel.all,
    Key? key,
  }) : super(key: key);

  final LogLevel? logLevel;

  @override
  Widget build(BuildContext context) {
    final StreamPrinter? printer =
        Loggy.currentPrinter is StreamPrinter ? Loggy.currentPrinter as StreamPrinter? : null;

    if (printer == null) {
      throw WrongPrinterException();
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ValueListenableBuilder<List<LogRecord>>(
            valueListenable: printer.logRecord,
            builder: (BuildContext context, records, _) {
              return ListView(
                reverse: true,
                children: records
                    .where((LogRecord record) => record.level.priority >= logLevel!.priority)
                    .map((LogRecord record) => _LoggyItemWidget(record))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LoggyItemWidget extends StatelessWidget {
  const _LoggyItemWidget(this.record, {Key? key}) : super(key: key);

  final LogRecord record;

  @override
  Widget build(BuildContext context) {
    final Color logColor = _getLogColor();
    final String time = record.time.toIso8601String().split('T')[1];
    final Color dividerColor = ThemeData.dark().dividerColor;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  '${record.level.name.toUpperCase()} - $time',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: logColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                      ),
                ),
              ),
              Text(
                record.loggerName,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: logColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            record.message,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: logColor,
                  fontWeight: _getTextWeight(),
                  fontSize: 16.0,
                ),
          ),
          _LoggyItemStackWidget(record),
          Divider(color: dividerColor),
        ],
      ),
    );
  }

  FontWeight _getTextWeight() {
    switch (record.level) {
      case LogLevel.error:
        return FontWeight.w700;
      case LogLevel.debug:
        return FontWeight.w300;
      case LogLevel.info:
        return FontWeight.w300;
      case LogLevel.warning:
        return FontWeight.w400;
    }

    return FontWeight.w300;
  }

  Color _getLogColor() {
    switch (record.level) {
      case LogLevel.error:
        return Colors.redAccent;
      case LogLevel.debug:
        return Colors.lightBlue;
      case LogLevel.info:
        return Colors.lightGreen;
      case LogLevel.warning:
        return Colors.yellow;
    }

    return Colors.white;
  }
}
