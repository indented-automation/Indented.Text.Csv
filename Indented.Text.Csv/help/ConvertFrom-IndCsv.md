---
external help file: Indented.Text.Csv.dll-Help.xml
Module Name: Indented.Text.Csv
online version:
schema: 2.0.0
---

# ConvertFrom-IndCsv

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### GetObject (Default)
```
ConvertFrom-IndCsv [-InputObject] <String> [-Delimiter <Char>] [-Header <String[]>] [-NoHeader]
 [<CommonParameters>]
```

### GetIndex
```
ConvertFrom-IndCsv [-InputObject] <String> [-Delimiter <Char>] [-Header <String[]>] [-NoHeader]
 [-Index <Int32>] [<CommonParameters>]
```

### GetItem
```
ConvertFrom-IndCsv [-InputObject] <String> [-Delimiter <Char>] [-Header <String[]>] [-NoHeader]
 [-Item <String>] [<CommonParameters>]
```

### AsArray
```
ConvertFrom-IndCsv [-InputObject] <String> [-Delimiter <Char>] [-Header <String[]>] [-NoHeader] [-AsArray]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AsArray
{{ Fill AsArray Description }}

```yaml
Type: SwitchParameter
Parameter Sets: AsArray
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Delimiter
{{ Fill Delimiter Description }}

```yaml
Type: Char
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Header
{{ Fill Header Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Index
{{ Fill Index Description }}

```yaml
Type: Int32
Parameter Sets: GetIndex
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
{{ Fill InputObject Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Item
{{ Fill Item Description }}

```yaml
Type: String
Parameter Sets: GetItem
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoHeader
{{ Fill NoHeader Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.String[]

### System.Management.Automation.PSObject

### System.String

## NOTES

## RELATED LINKS
