using Microsoft.AspNetCore.Http;

namespace Application.Services.Interfaces.FileService
{
    public interface IFileStorageService
    {
        Task<List<string>> UploadAsync(
            List<IFormFile> files,
            string folderName,
            int minFiles,
            int maxFiles
        );
    }


}
