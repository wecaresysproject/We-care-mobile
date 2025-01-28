// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "enterFirstName": MessageLookupByLibrary.simpleMessage(
      "Enter Your First Name",
    ),
    "enterLastName": MessageLookupByLibrary.simpleMessage(
      "Enter Your Last Name",
    ),
    "enterMobileNumber": MessageLookupByLibrary.simpleMessage(
      "Enter Mobile Number",
    ),
    "enterPassword": MessageLookupByLibrary.simpleMessage("Enter Password"),
    "familyName": MessageLookupByLibrary.simpleMessage("Family Name"),
    "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
    "mobileNumber": MessageLookupByLibrary.simpleMessage("Mobile Number"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordHint": MessageLookupByLibrary.simpleMessage(
      "Your password must contain",
    ),
  };
}
