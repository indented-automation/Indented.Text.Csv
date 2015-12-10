using Indented.Text.Csv;
using System;
using System.Text;
using System.Management.Automation;

[Cmdlet(VerbsData.ConvertFrom,
        "Csv",
        DefaultParameterSetName = "GetObject")]
[OutputType(typeof(PSObject), ParameterSetName = new String[] { "GetObject" })]
[OutputType(typeof(String), ParameterSetName = new String[] { "GetIndex" })]
[OutputType(typeof(String[]), ParameterSetName = new String[] { "AsArray" })]
public class ConvertFromCsv : BaseCsv
{
    #region Parameters
    [Parameter(Mandatory = true,
               Position = 0,
               ValueFromPipeline = true)]
    public String InputObject;
    #endregion
    
    #region Methods
    protected override void BeginProcessing()
    {
        csvReader = new CsvReader();
    }
    
    protected override void ProcessRecord()
    {
        csvReader.OpenStream(InputObject);
      
        if (csvReader.Header.Count == 0)
        {
            SetHeader();
        }
        
        if (MyInvocation.BoundParameters.ContainsKey("Index"))
        {
            WriteObject(csvReader.ReadLine(Index));
        }
        else if (AsArray == true)
        {
            WriteObject(csvReader.ReadLine());
        }
        else
        {
            WriteObject(csvReader.ReadLine(true));
        }
    }
    
    protected override void EndProcessing()
    {
        csvReader.Close();
    }
    #endregion
}