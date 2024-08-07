/*
Name: Extensions
Purpose: Extensions for anything in MudkiPC.

These are functions are added to already existing classes that require an extra function to work properly, and to make adding new features easier.
*/

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
