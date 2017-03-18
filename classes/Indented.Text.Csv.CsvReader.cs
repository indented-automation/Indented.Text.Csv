using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Management.Automation;
using System.Reflection;
using System.Text;

///<summary>A CSV reader class which exposes methods to process a delimited file or string.</summary>
public class CsvReader
{
    #region Fields
    String       addType      = String.Empty;
    Char         delimiter    = ',';
    Boolean      endOfLine    = false;
    FileStream   fileStream;
    List<String> header       = new List<String>();
    String       path;
    StreamReader streamReader;
    Encoding     textEncoding = Encoding.Default;
    #endregion
    
    #region Constructors
    ///<summary>Initializes a new instance of the class <see cref="CsvReader" /> class.</summary>
    ///<remark>Create a reader with no bound file for string processing.</remark>
    public CsvReader() { }

    ///<summary>Initializes a new instance of the class <see cref="CsvReader" /> class with the specified path.</summary>
    ///<param name="path">A path to a file containing the content to be processed.</param>
    public CsvReader(String path)
    {
        this.path = path;
        OpenFile(path, textEncoding);
    }

    ///<summary>Initializes a new instance of the class <see cref="CsvReader" /> class with the specified path and encoding type.</summary>
    ///<param name="path">A path to a file containing the content to be processed.</param>
    public CsvReader(String path, Encoding encoding)
    {
        this.path = path;
        textEncoding = encoding;
        OpenFile(path, textEncoding);
    }
    #endregion
    
    #region Properties
    ///<summary>Gets or sets the delimiter character used when parsing content.</summary>
    public Char Delimiter
    {
        get { return delimiter; }
        set { delimiter = value; }
    }

    ///<summary>Gets the encoding used by a file.</summary>
    public Encoding TextEncoding
    {
        get { return textEncoding; } 
    }

    ///<summary>Gets the header values which will be used when returning a PSObject.</summary>
    public List<String> Header
    {
        get { return header; }
    }

    ///<summary>Gets the path to the file being used by the reader.</summary>
    public String Path
    {
        get { return path; }
    }

    ///<summary>Gets the current position in a file stream.</summary>
    public Int64 Position
    {
        get { 
            Int32 charPos = (Int32)typeof(StreamReader).InvokeMember(
                "charPos",
                BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.GetField,
                null,
                streamReader,
                null);
                
            Int32 charLen = (Int32)typeof(StreamReader).InvokeMember(
                "charLen",
                BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.GetField,
                null,
                streamReader,
                null);                
            
            return streamReader.BaseStream.Position - charLen + charPos;
        }
    }
    
    ///<summary>Gets a value indicating whether or not the stream has ended.</summary>
    public Boolean AtEndOfStream
    {
        get { return streamReader.EndOfStream; } 
    }
    #endregion

    #region Methods
    ///<summary>Close the CsvReader, releasing streams opened while using the reader.</summary>
    public void Close()
    {
        streamReader.Close();
        streamReader.Dispose();

        if (fileStream != null)
        {
            fileStream.Close();
            fileStream.Dispose();
        }
    }

    ///<summary>Fill a DataTable with the content of the CSV file.</summary>
    public DataTable FillDataTable()
    {
        DataTable dataTable = new DataTable();

        if (header.Count == 0)
        {
            ReadHeader();
            foreach (String column in header)
            {
                dataTable.Columns.Add(column);
            }
        }

        do
        {
            DataRow row = dataTable.NewRow();
            row.ItemArray = ReadLine().ToArray();
            dataTable.Rows.Add(row);
        } while (!AtEndOfStream);

        return dataTable;
    }

    ///<summary>Get the index of the specified item in the header.</summary>
    ///<param name="item">The name of the item to get.</param>
    public Int32 IndexOf(String item)
    {
        return header.IndexOf(item);
    }

    ///<summary>Open a file stream then a stream reader using the specified path and encoding type.</summary>
    ///<param name="path">The path to a CSV file.</param>
    ///<param name="encoding">The encoding type, by default the system default encoding is used.</param>
    public void OpenFile(String path, Encoding encoding)
    {
        fileStream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
        streamReader = new StreamReader(fileStream, encoding);
    }
    
    ///<summary>Open a stream reader using the specified string.</summary>
    ///<param name="csvString">A CSV string.</param>
    public void OpenStream(String csvString)
    {
        MemoryStream memoryStream = new MemoryStream(textEncoding.GetBytes(csvString));
        streamReader = new StreamReader(memoryStream);
    }

    ///<summary>Read a header line from a CSV file or string.</summary>
    ///<remarks>If the header begins #TYPE the type is extracted and another attempt to read a line is made.</remarks>
    public void ReadHeader()
    {
        List<String> header = ReadLine();
        if (header != null)
        {
            if (header[0].StartsWith("#TYPE"))
            {
                addType = header[0].Substring((header[0].IndexOf(" ") + 1), (header[0].Length - header[0].IndexOf(" ") - 1));
                header.Clear();
                
                if (streamReader.EndOfStream == false)
                {
                    header = ReadLine();
                }
            }
            if (header.Count > 0)
            {
                SetHeader(header.ToArray());
            }
        }
    }
    
    ///<summary>Read an item from a CSV file.</summary>
    ///<returns>A string representing the item.</returns>
    private String ReadItem()
    {
        Char character = (Char)streamReader.Peek();
        if (character == '\r' || character == '\n')
        {
            streamReader.Read();
            if ((Char)streamReader.Peek() == '\n')
            {
                streamReader.Read();
            }

            endOfLine = true;
            return String.Empty;
        }
        else if (character == delimiter)
        {
            streamReader.Read();
            return String.Empty;
        }
        else if (character == '"')
        {
            return ReadQuotedItem();
        }
        else
        {
            return ReadSimpleItem();
        }
    }

    ///<summary>Read a line from a CSV file.</summary>
    ///<remarks>The reader reads items until a line break character outside of a quoted item is encountered.</remarks>
    ///<returns>A List of strings representing each item.</returns>
    public List<String> ReadLine()
    {
        List<String> items = new List<String>();

        endOfLine = false;
        while (endOfLine == false && streamReader.EndOfStream == false)
        {
            String item = ReadItem();
            if (endOfLine == false)
            {
                items.Add(item);
            }
        }
        
        return items;
    }
    
    ///<summary>Read a line from a CSV file.</summary>
    ///<remarks>The reader reads items until a line break character outside of a quoted item is encountered.</remarks>
    ///<returns>A PSObject representing the line.</returns>
    public PSObject ReadLine(Boolean AsObject)
    {
        List<String> items = ReadLine();

        if (header.Count < items.Count)
        {
            Int32 i = header.Count;
            do {
                header.Add(String.Format("H{0}", i++));
            } while (header.Count < items.Count);
        }
        
        PSObject psObject = new PSObject();
        if (addType != String.Empty)
        {
            psObject.TypeNames.Clear();
            psObject.TypeNames.Add(String.Format("CSV:{0}", addType));
        }
        
        for (Int32 j = 0; j < items.Count; j++)
        {
            psObject.Members.Add(new PSNoteProperty(header[j], items[j]));
        }
        
        return psObject;
    }

    ///<summary>Read a line from a CSV file.</summary>
    ///<remarks>The reader reads items until a line break character outside of a quoted item is encountered.</remarks>
    ///<returns>The item at the specified index.</returns>
    public String ReadLine(Int32 itemIndex)
    {
        List<String> items = ReadLine();
       
        // Allow this to generate an OutOfRangeException if itemIndex is too small or too large.
        return items[itemIndex];
    }
    
    ///<summary>Read a quoted item from a CSV file.</summary>
    ///<returns>A string representing the item (excluding the quotes used to encapsulate the value.</returns>
    private String ReadQuotedItem()
    {
        StringBuilder item = new StringBuilder();
        // Discard the first quote character
        streamReader.Read();
        
        Boolean IsComplete = false;
        do
        {
            Char character = (Char)streamReader.Read();
            if (character == '"' && (Char)streamReader.Peek() == '"')
            {
                // Double quoted, add both to the string
                item.Append(character);
                item.Append((Char)streamReader.Read());
            }
            else if (character == '"')
            {
                IsComplete = true;
            }
            else
            {
                item.Append(character); 
            }
        } while (IsComplete == false && streamReader.EndOfStream == false);

        // Advance to the next character which must be a delimiter for this to be a consistent CSV file.
        Char peekChar = (Char)streamReader.Peek();
        if (peekChar == delimiter)
        {
            streamReader.Read();
        }
        
        return item.ToString();
    }

    ///<summary>Read an item from a CSV file.</summary>
    ///<returns>A string representing the item.</returns>
    private String ReadSimpleItem()
    {
        StringBuilder item = new StringBuilder();
        Char peekChar;
        
        do
        {
            item.Append((Char)streamReader.Read());
            peekChar = (Char)streamReader.Peek();
        } while (streamReader.EndOfStream == false && peekChar != delimiter && peekChar != '\n' && peekChar != '\r');
        
        if (peekChar == delimiter)
        {
            streamReader.Read(); 
        }
      
        return item.ToString();
    }
    
    ///<summary>Move to s specific position in the file.</summary>
    public void Seek(Int64 position)
    {
        streamReader.BaseStream.Seek(position, SeekOrigin.Begin);
        streamReader.DiscardBufferedData();
    }
    
    ///<summary>Set the header to the specified set of values.</summary>
    public void SetHeader(String[] header)
    {
        this.header.Clear();
        foreach (String item in header)
        {
            this.header.Add(item);
        }
    }
    #endregion
}