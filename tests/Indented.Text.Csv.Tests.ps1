# General functionality

Describe "ConvertFrom-Csv" {
  # Returning an empty PSObject. Hmm.
  It "Return null when the CSV is a single line and no header is defined" {
    "a,b,c,d" | ConvertFrom-Csv | Should BeNullOrEmpty
  }

  It "Return something when the CSV is a single line and a header is supplied" {
    "a,b,c,d" | ConvertFrom-Csv -Header w,x,y,z | Should Not BeNullOrEmpty
  }

  It "Return c from a,b,c,d when Index is set to 2" {
    "a,b,c,d" | ConvertFrom-Csv -Index 2 -NoHeader | Should Be "c" 
  }

  It "Return a,b,c,d as a string array when AsArray is set" {
    $Result = "a,b,c,d" | ConvertFrom-Csv -AsArray -NoHeader
    # Pipeline support in Should means result needs to be passed as the second element of an array.
    ,$Result | Should BeOfType [System.String[]]
  }

  It "Return the value for b when Item is set to x" {
    "a,b,c,d" | ConvertFrom-Csv -Item x -Header w,x,y,z | Should Be "b"
  }
  
  It "Generate missing header items" {
    $Result = "a,b,c,d" | ConvertFrom-Csv -Header w
    ($Result.PSObject.Properties | Select -First 1 -Skip 1).Name | Should Be "H1"
  }
}

# RFC-4180 and csv-spectrum (https://github.com/maxogden/csv-spectrum (maxogden))

# All pass, but cases need to be written to ensure this remains so.