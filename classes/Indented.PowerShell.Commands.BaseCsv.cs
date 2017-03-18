using Indented.Text.Csv;
using System;
using System.Text;
using System.Management.Automation;

public class BaseCsv : PSCmdlet
{
    #region Parameters
    [Parameter()]
    public Char Delimiter = ',';
    
    [Parameter()]
    public String[] Header;

    [Parameter()]
    public SwitchParameter NoHeader;

    [Parameter(ParameterSetName = "GetIndex")]
    public Int32 Index = -2;
    
    [Parameter(ParameterSetName = "GetItem")]
    public String Item;
    
    [Parameter(ParameterSetName = "AsArray")]
    public SwitchParameter AsArray;
    #endregion

    #region Fields
    internal CsvReader csvReader;
    #endregion
    
    #region Methods
    ///<summary>Consume a line for the header unless either instructed not to, or another header has been supplied.</summary>
    internal void SetHeader()
    {
        if (csvReader.Header.Count == 0)
        {
            if (MyInvocation.BoundParameters.ContainsKey("Header"))
            {
                csvReader.SetHeader(Header);
            }
            else if (NoHeader == false)
            {
                csvReader.ReadHeader(); 
            }
        }
    }
    
    ///<summary>WriteObject to the output pipeline.</summary>
    internal void WriteCsvObject()
    {
        if (csvReader.AtEndOfStream == false)
        {
            do {
                if (this.ParameterSetName == "GetIndex" || this.ParameterSetName == "GetItem")
                {
                    WriteObject(csvReader.ReadLine(Index));
                }
                else if (AsArray == true)
                {
                    WriteObject(csvReader.ReadLine().ToArray());
                }
                else
                {
                    WriteObject(csvReader.ReadLine(true));
                }
            } while (csvReader.AtEndOfStream == false);
        }
    }
    #endregion
}