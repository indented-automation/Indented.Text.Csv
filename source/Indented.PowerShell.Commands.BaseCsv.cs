using Indented.Text.Csv;
using System;
using System.Text;
using System.Management.Automation;

public class BaseCsv : PSCmdlet
{
    #region Parameters
    [Parameter()]
    public Char Delimiter = ',';
    
    public String[] Header;

    [Parameter(ParameterSetName = "GetIndex")]
    public Int32 Index;
    
    [Parameter(ParameterSetName = "AsArray")]
    public SwitchParameter AsArray;
    #endregion

    #region Fields
    internal CsvReader csvReader;
    #endregion
    
    #region Methods
    internal void SetHeader()
    {
        if (MyInvocation.BoundParameters.ContainsKey("Header"))
        {
            csvReader.SetHeader(Header);
        }
        else
        {
            csvReader.ReadHeader(); 
        }
    }
    #endregion
}