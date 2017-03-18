using Indented.Text.Csv;
using System;
using System.Text;
using System.Management.Automation;

[Cmdlet(VerbsData.Import,
        "Csv",
        DefaultParameterSetName = "GetObject")]
[OutputType(typeof(PSObject), ParameterSetName = new String[] { "GetObject" })]
[OutputType(typeof(String), ParameterSetName = new String[] { "GetIndex", "GetItem" })]
[OutputType(typeof(String[]), ParameterSetName = new String[] { "AsArray" })]
public class ImportCsv : BaseCsv
{
    #region Parameters
    [Parameter(Mandatory = true,
               Position = 0,
               ValueFromPipelineByPropertyName = true)]
    [Alias("FullName")]
    public String Path;
    
    [Parameter()]
    public Encoding Encoding = Encoding.Default;
    #endregion
    
    #region Methods
    protected override void ProcessRecord()
    {
        Path = this.GetUnresolvedProviderPathFromPSPath(Path);
      
        csvReader = new CsvReader(Path);
        
        SetHeader();

        if (this.ParameterSetName == "GetItem" && Index == -2)
        {
            Index = csvReader.IndexOf(Item);
        }

        WriteCsvObject();
 
        csvReader.Close();
    }
    #endregion
}