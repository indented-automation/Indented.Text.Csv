---
external help file: Indented.Text.Csv.dll-Help.xml
Module Name: Indented.Text.Csv
online version:
schema: 2.0.0
---

# Import-IndCsv

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### GetObject (Default)
```
Import-IndCsv [-Path] <String> [-Encoding <Encoding>] [-Delimiter <Char>] [-Header <String[]>] [-NoHeader]
 [<CommonParameters>]
```

### GetIndex
```
Import-IndCsv [-Path] <String> [-Encoding <Encoding>] [-Delimiter <Char>] [-Header <String[]>] [-NoHeader]
 [-Index <Int32>] [<CommonParameters>]
```

### GetItem
```
Import-IndCsv [-Path] <String> [-Encoding <Encoding>] [-Delimiter <Char>] [-Header <String[]>] [-NoHeader]
 [-Item <String>] [<CommonParameters>]
```

### AsArray
```
Import-IndCsv [-Path] <String> [-Encoding <Encoding>] [-Delimiter <Char>] [-Header <String[]>] [-NoHeader]
 [-AsArray] [<CommonParameters>]
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

### -Encoding
{{ Fill Encoding Description }}

```yaml
Type: Encoding
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

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

### System.String

### System.String[]

## NOTES

## RELATED LINKS
