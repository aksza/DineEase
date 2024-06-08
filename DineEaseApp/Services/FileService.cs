using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using System;

namespace DineEaseApp.Services;


public interface IFileService
{
    Task<string> SaveFileAsync(IFormFile imageFile, List<string> allowedFileExtensions);
    void DeleteFile(string fileNameWithExtension);
}

public class FileService : IFileService
{
    private IWebHostEnvironment _environment;
    public FileService(IWebHostEnvironment environment)
    {
        _environment= environment;
    }
    public async Task<string> SaveFileAsync(IFormFile imageFile, List<string> allowedFileExtensions)
{
    if (imageFile == null)
    {
        throw new ArgumentNullException(nameof(imageFile));
    }

    var contentPath = _environment.ContentRootPath;
        //var path = Path.Combine(contentPath, "Uploads");
        var path = Path.GetFullPath("E:\\egyetem\\allamvizsga\\DineEase\\dine_ease\\assets\\test_images");
    // path = "c://projects/ImageManipulation.Ap/uploads" ,not exactly, but something like that

    if (!Directory.Exists(path))
    {
        Directory.CreateDirectory(path);
    }

    // Check the allowed extenstions
    var ext = Path.GetExtension(imageFile.FileName);
    if (!allowedFileExtensions.Contains(ext))
    {
        throw new ArgumentException($"Only {string.Join(",", allowedFileExtensions)} are allowed.");
    }

    // generate a unique filename
    var fileName = $"{Guid.NewGuid().ToString()}{ext}";
    var fileNameWithPath = Path.Combine(path, fileName);
    using var stream = new FileStream(fileNameWithPath, FileMode.Create);
    await imageFile.CopyToAsync(stream);
    return fileName;
}


public void DeleteFile(string fileNameWithExtension)
{
    if (string.IsNullOrEmpty(fileNameWithExtension))
    {
        throw new ArgumentNullException(nameof(fileNameWithExtension));
    }
        //var contentPath = _environment.ContentRootPath;
        //var path = Path.Combine(contentPath, $"Uploads", fileNameWithExtension);
    var path = Path.GetFullPath("E:\\egyetem\\allamvizsga\\DineEase\\dine_ease\\assets\\test_images\\"+fileNameWithExtension);

    if (!File.Exists(path))
    {
        throw new FileNotFoundException($"Invalid file path");
    }
    File.Delete(path);
}

}