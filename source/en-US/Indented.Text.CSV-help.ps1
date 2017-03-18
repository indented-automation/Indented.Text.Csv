# This file is used by Indented.PowerShell.Help to complete help content

helpDocument {
  parameter AsArray {
    description = CSV convert is parsed and returned as a string array.
  }
  parameter Delimiter {
    description = The character used to delimit fields in the document. By default the comma character is used.
  }
  parameter Header {
    description = A string array describing the header.
  }
  parameter Index {
    description = Return a single item from a CSV document based on its indexed position (0 for the first field, 1 for the second, and so on).
  }
  parameter Item {
    description = Return a single item from a CSV document based on the name of the item from the header.
  }
  parameter NoHeader {
    description = The CSV content does not have a header (and no header is supplied). A header will be automatically generated when creating object output. For array or indexed returns this stops the first row being read as a header.
  }
  command ConvertFrom-Csv {
    synopsis = Convert CSV content from a string.
    description = Converts CSV formatted string values from the pipeline into either a PSObject representation, an array, or allows selection of a single indexed field.
    parameter InputObject {
      description = Accepts a delimited string from the pipeline. If a header is not explicitly specified the first converted line will be treated as the header.
    }
  }
  command Import-Csv {
    synopsis = Import CSV content from a file.
    description = Import CSV content from a file. The content of the file may be presented as either a PSObject representation, an array, or a single indexed field.
    parameter Encoding {
      description = The text encoding used by the document. By default the system default encoding is used (normally ANSI).
    }
    parameter Path {
      description = The path to a file containing content which should be imported.
    }
  }
}