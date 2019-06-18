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

Describe 'Import-IndCsv' {
    BeforeAll {
        $csvFile = Join-Path $TestDrive Test.csv

        Set-Content $csvFile -Value 'a,b,c,d'
    }

    It 'Returns null when the CSV is a single line and no header is defined' {
        Import-IndCsv -Path $csvFile | Should -BeNullOrEmpty
    }

    It 'Returns something when the CSV is a single line and a header is supplied' {
        Import-IndCsv -Path $csvFile -Header w,x,y,z | Should -Not -BeNullOrEmpty
    }

    It 'Returns c from a,b,c,d when Index is set to 2' {
        Import-IndCsv -Path $csvFile -Index 2 -NoHeader | Should -Be 'c'
    }

    It 'Returns a,b,c,d as a string array when AsArray is set' {
        $result = Import-IndCsv -Path $csvFile -AsArray -NoHeader

        ,$result | Should -BeOfType [System.String[]]
    }

    It 'Returns the value for b when Item is set to x' {
        Import-IndCsv -Path $csvFile -Item x -Header w,x,y,z | Should -Be 'b'
    }

    It 'Generates missing header items' {
        $result = Import-IndCsv -Path $csvFile -Header w
        ($result.PSObject.Properties | Select-Object -First 1 -Skip 1).Name | Should -Be 'H1'
    }

    It 'Ignores #TYPE lines' {
        Get-Process powershell | Select-Object -First 1 | Export-Csv -Path $csvFile

        $result = Import-IndCsv $csvFile

        @($result).Count | Should -Be 1
    }
}