using Indented.Text.Csv;
using System;
using System.Text;
using System.Management.Automation;

[Cmdlet(VerbsData.Import,
        "Csv",
        DefaultParameterSetName = "GetObject")]
[OutputType(typeof(PSObject), ParameterSetName = new String[] { "GetObject" })]
[OutputType(typeof(String), ParameterSetName = new String[] { "GetIndex" })]
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
        Path = Utility.GetFullPath(Path, this.SessionState.Path.CurrentFileSystemLocation.Path);
      
        csvReader = new CsvReader(Path);
        
        SetHeader();

        do {
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
        } while (csvReader.AtEndOfStream != true);

        csvReader.Close();
    }
    #endregion
}