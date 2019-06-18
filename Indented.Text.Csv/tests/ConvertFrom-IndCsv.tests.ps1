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

Describe 'ConvertFrom-Csv' {
    It 'Returns null when the CSV is a single line and no header is defined' {
        'a,b,c,d' |
            ConvertFrom-IndCsv |
            Should -BeNullOrEmpty
    }

    It 'Returns something when the CSV is a single line and a header is supplied' {
        'a,b,c,d' |
            ConvertFrom-IndCsv -Header w,x,y,z |
            Should -Not -BeNullOrEmpty
    }

    It 'Returns c from a,b,c,d when Index is set to 2' {
        'a,b,c,d' |
            ConvertFrom-IndCsv -Index 2 -NoHeader |
            Should -Be 'c'
    }

    It 'Returns a,b,c,d as a string array when AsArray is set' {
        $result = 'a,b,c,d' | ConvertFrom-IndCsv -AsArray -NoHeader

        ,$result | Should -BeOfType [System.String[]]
    }

    It 'Returns the value for b when Item is set to x' {
        'a,b,c,d' |
            ConvertFrom-IndCsv -Item x -Header w,x,y,z |
            Should -Be 'b'
    }

    It 'Generates missing header items' {
        $result = 'a,b,c,d' | ConvertFrom-IndCsv -Header w

        ($result.PSObject.Properties | Select-Object -First 1 -Skip 1).Name | Should -Be 'H1'
    }

    It 'Returns two objects if a single string contains multiple CSV lines' {
        $result = "a,b,c,d`r`nd,e,f,g" | ConvertFrom-IndCsv -NoHeader

        @($result).Count | Should -Be 2
    }

    It 'Ignores #TYPE lines' {
        [Array]$result = Get-Process powershell |
            Select-Object -First 1 |
            ConvertTo-Csv |
            ConvertFrom-IndCsv

        @($result).Count | Should -Be 1
    }
}