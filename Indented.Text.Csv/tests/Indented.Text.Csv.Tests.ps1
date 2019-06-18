# Note: Several of these tests are drawn from https://github.com/maxogden/csv-spectrum (thank you!)

#region:TestFileHeader
param (
   [Boolean]$UseExisting
)

if (-not $UseExisting) {
   $moduleBase = $psscriptroot.Substring(0, $psscriptroot.IndexOf('\test'))
   $stubBase = Resolve-Path (Join-Path $moduleBase 'test*\stub\*')
   if ($null -ne $stubBase) {
       $stubBase | Import-Module -Force
   }

   Import-Module $moduleBase -Force
}
#endregion

Describe 'csvReader' {
    BeforeAll {
        $csvFile = Join-Path $TestDrive Test.csv
    }

    BeforeEach {
        $csvReader = [Indented.Text.Csv.CsvReader]::new()
    }

    AfterEach {
        try { $csvReader.Close() } catch { }
    }

    It 'Can be instantiated from PowerShell' {
        $csvReader | Should -Not -BeNullOrEmpty
    }

    It 'Parses CSV content from a string' {
        $csvReader.OpenStream("a,b,c")
        $result = $csvReader.ReadLine()

        @($result).Count | Should -Be 3
    }

    It 'Parses formats using \n' {
        Set-Content $csvFile "a,b,c`nd,e,f"

        $csvReader.OpenFile(
            $csvFile,
            [System.Text.Encoding]::Default
        )

        $result = do {
            $csvReader.ReadLine($true)
        } until ($csvReader.AtEndOfStream)

        @($result).Count | Should -Be 2
        $csvReader.Close()
    }

    It 'Parses formats using Unicode encoding' {
        Set-Content $csvFile -Value "a,b,c`nd,e,f" -Encoding Unicode

        $csvReader.OpenFile(
            $csvFile,
            [System.Text.Encoding]::Unicode
        )

        $result = do {
            $csvReader.ReadLine($true)
        } until ($csvReader.AtEndOfStream)

        @($result).Count | Should -Be 2

        $csvReader.Close()
    }

    It 'Handles quotes inside a field' {
        $csvReader.OpenStream('a,b"c,d' )
        $Result = $csvReader.ReadLine()
        $Result[1] -eq 'b"c' | Should -BeTrue
    }

    It 'Handles quoted fields' {
        $csvReader.OpenStream('a,"bcd,""ef",g')
        $Result = $csvReader.ReadLine()
        $Result[1] -eq 'bcd,""ef' | Should -BeTrue
    }

    It 'Handles quoted fields containing line break characters' {
        $csvReader.OpenStream("a,`"bc`r`nde`nf`",g")
        $Result = $csvReader.ReadLine()
        $Result[1] -eq "bc`r`nde`nf" | Should -BeTrue
    }

    It 'Handles empty fields' {
        $csvReader.OpenStream('a,,b,c')
        $Result = $csvReader.ReadLine()
        $Result[1] -eq [String]::Empty | Should -BeTrue
    }

    It 'Handles empty quoted fields' {
        $csvReader.OpenStream('a,"",b,c')
        $Result = $csvReader.ReadLine()
        $Result[1] -eq [String]::Empty | Should -BeTrue
    }

    It 'Handles JSON embedded in CSV' {
        $csvReader.OpenStream('1,"{""type"": ""Point"", ""coordinates"": [102.0, 0.5]}"')
        [Array]$Result = $csvReader.ReadLine()
        $Result.Count | Should -Be 2
    }
}