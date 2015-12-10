using System;
using System.IO;

public class Utility
{
    public static String GetFullPath(String path, String currentPSPath)
    {
        if (Path.IsPathRooted(path))
        {
            return path;
        }
        else
        {
            return Path.GetFullPath(Path.Combine(currentPSPath, path));
        }
    }
}