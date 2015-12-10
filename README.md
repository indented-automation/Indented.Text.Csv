# Indented.Text.Csv

## Class

A generic CSV processor class that (should) be able to handle all well-built CSV formats. Provides support for tracking position within a text stream, line-by-line processing, and somewhat flexible return types (PSObject to satisfy PowerShell, String[] and Indexed item).

Built in response to a need for a (subjectively) very fast CSV processor where single fields could be extracted from extremely large data sets in PowerShell.

Help documentation for the comamnds is part-written, test driving Indented.PowerShell.Help.

## Cmdlets

### ConvertFrom-Csv

Converts a string to CSV format in much (or entirely) the same way as the native ConvertFrom-Csv command.

### Import-Csv

Reads text files and converts the content to the requested format.
