/// Support for doing something awesome.
///
/// More dartdocs go here.
library logger;

import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;

import 'package:stack_trace/stack_trace.dart' show Trace, Frame;

part 'src/logger.dart';
part 'src/printers/default_printer.dart';
part 'src/printers/developer_printer.dart';
part 'src/printers/logger_printer.dart';
part 'src/printers/pretty_printer.dart';
part 'src/types/logger_type.dart';
part 'src/types/types.dart';
