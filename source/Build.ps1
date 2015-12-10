$TypeDefinition = Get-ChildItem $psscriptroot -Filter *.cs | ForEach-Object {
  Write-Verbose $_.BaseName

  $Namespaces = $_.BaseName.Split('.') | Select-Object -SkipLast 1
  $Namespaces | ForEach-Object {
    "namespace $_ {"
  }
  Get-Content $_.FullName -Raw
  $Namespaces | ForEach-Object {
    '}'
  }
} | Out-String

Write-Verbose $TypeDefinition

$Params = @{
  TypeDefinition = $TypeDefinition
  Language       = 'CSharp'
  OutputAssembly = "$psscriptroot\..\Indented.Text.Csv.dll"
  OutputType     = 'Library'
}
Add-Type @Params