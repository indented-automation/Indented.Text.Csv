# Note: Several of these tests are drawn from https://github.com/maxogden/csv-spectrum (thank you!)

Describe 'ConvertFrom-Csv' {
  It 'Returns null when the CSV is a single line and no header is defined' {
    'a,b,c,d' | ConvertFrom-Csv | Should BeNullOrEmpty
  }

  It 'Returns something when the CSV is a single line and a header is supplied' {
    'a,b,c,d' | ConvertFrom-Csv -Header w,x,y,z | Should Not BeNullOrEmpty
  }

  It 'Returns c from a,b,c,d when Index is set to 2' {
    'a,b,c,d' | ConvertFrom-Csv -Index 2 -NoHeader | Should Be 'c' 
  }

  It 'Returns a,b,c,d as a string array when AsArray is set' {
    $Result = 'a,b,c,d' | ConvertFrom-Csv -AsArray -NoHeader
    # Pipeline support in Should means result needs to be passed as the second element of an array.
    ,$Result | Should BeOfType [System.String[]]
  }

  It 'Returns the value for b when Item is set to x' {
    'a,b,c,d' | ConvertFrom-Csv -Item x -Header w,x,y,z | Should Be 'b'
  }
  
  It 'Generates missing header items' {
    $Result = 'a,b,c,d' | ConvertFrom-Csv -Header w
    ($Result.PSObject.Properties | Select -First 1 -Skip 1).Name | Should Be 'H1'
  }
  
  It 'Returns two objects if a single string contains multiple CSV lines' {
    [Array]$Result = "a,b,c,d`r`nd,e,f,g" | ConvertFrom-Csv -NoHeader
    $Result.Count | Should Be 2
  }
  
  It 'Ignores #TYPE lines' {
    [Array]$Result = Get-Process powershell | Select-Object -First 1 | ConvertTo-Csv | ConvertFrom-Csv
    $Result.Count | Should Be 1
  }
}

Describe 'Import-Csv' {
  $CsvFile = "Test.csv"
  Set-Content $CsvFile 'a,b,c,d'
  
  It 'Returns null when the CSV is a single line and no header is defined' {
    Import-Csv -Path $CsvFile | Should BeNullOrEmpty
  }

  It 'Returns something when the CSV is a single line and a header is supplied' {
    Import-Csv -Path $CsvFile -Header w,x,y,z | Should Not BeNullOrEmpty
  }

  It 'Returns c from a,b,c,d when Index is set to 2' {
    Import-Csv -Path $CsvFile -Index 2 -NoHeader | Should Be 'c' 
  }

  It 'Returns a,b,c,d as a string array when AsArray is set' {
    $Result = Import-Csv -Path $CsvFile -AsArray -NoHeader
    # Pipeline support in Should means result needs to be passed as the second element of an array.
    ,$Result | Should BeOfType [System.String[]]
  }

  It 'Returns the value for b when Item is set to x' {
    Import-Csv -Path $CsvFile -Item x -Header w,x,y,z | Should Be 'b'
  }
  
  It 'Generates missing header items' {
    $Result = Import-Csv -Path $CsvFile -Header w
    ($Result.PSObject.Properties | Select -First 1 -Skip 1).Name | Should Be 'H1'
  }
  
  It 'Ignores #TYPE lines' {
    Get-Process powershell | Select-Object -First 1 | Export-Csv -Path $CsvFile
    [Array]$Result = Import-Csv $CsvFile
    $Result.Count | Should Be 1
  }
  
  if (Test-Path $CsvFile) { Remove-Item $CsvFile }
}

Describe 'CsvReader' {
  $CsvFile = "$psscriptroot\Test.csv"
  $CsvReader = New-Object Indented.Text.Csv.CsvReader

  It 'Can be instantiated from PowerShell' {
    $CsvReader | Should Not BeNullOrEmpty
  }
  
  It 'Parses CSV content from a string' {
    $CsvReader.OpenStream("a,b,c")
    [Array]$Result = $CsvReader.ReadLine()
    $Result.Count | Should Be 3
  }
  
  It 'Parses formats using \n' {
    Set-Content $CsvFile "a,b,c`nd,e,f"
    $CsvReader.OpenFile($CsvFile, [System.Text.Encoding]::Default)
    $Result = do {
      $CsvReader.ReadLine($true)
    } while ($CsvReader.AtEndOfStream -eq $false)
    $Result.Count | Should Be 2
    $CsvReader.Close()
  }
  
  It 'Parses formats using Unicode encoding' {
    Set-Content $CsvFile "a,b,c`nd,e,f" -Encoding 'Unicode'
    $CsvReader.OpenFile($CsvFile, [System.Text.Encoding]::Unicode)
    $Result = do {
      $CsvReader.ReadLine($true)
    } while ($CsvReader.AtEndOfStream -eq $false)
    $Result.Count | Should Be 2
    $CsvReader.Close()
  }
  
  It 'Handles quotes inside a field' {
    $CsvReader.OpenStream('a,b"c,d' )
    $Result = $CsvReader.ReadLine()
    $Result[1] -eq 'b"c' | Should Be $true
  }
  
  It 'Handles quoted fields' {
    $CsvReader.OpenStream('a,"bcd,""ef",g')
    $Result = $CsvReader.ReadLine()
    $Result[1] -eq 'bcd,""ef' | Should Be $true 
  }
  
  It 'Handles quoted fields containing line break characters' {
    $CsvReader.OpenStream("a,`"bc`r`nde`nf`",g")
    $Result = $CsvReader.ReadLine()
    $Result[1] -eq "bc`r`nde`nf" | Should Be $true
  }
  
  It 'Handles empty fields' {
    $CsvReader.OpenStream('a,,b,c')
    $Result = $CsvReader.ReadLine()
    $Result[1] -eq [String]::Empty | Should Be $true 
  }
  
  It 'Handles empty quoted fields' {
    $CsvReader.OpenStream('a,"",b,c')
    $Result = $CsvReader.ReadLine()
    $Result[1] -eq [String]::Empty | Should Be $true
  }
  
  It 'Handles JSON embedded in CSV' {
    $CsvReader.OpenStream('1,"{""type"": ""Point"", ""coordinates"": [102.0, 0.5]}"')
    [Array]$Result = $CsvReader.ReadLine()
    $Result.Count | Should Be 2
  }
  
  if (Test-Path $CsvFile) { Remove-Item $CsvFile }
}