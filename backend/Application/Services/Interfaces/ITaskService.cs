using Application.DTOs.AllRequests.TaskRequests;
using Application.DTOs.Requests.TaskRequests;
using Domain.Entities;

namespace Application.Services.Interfaces
{
    public interface ITaskService
    {
        Task AddTaskAsync(CreateTaskDto dto);
        Task CancelTaskAsync(TaskIdDto dto);
        Task<List<TaskResponseDto>> GetAllTasksAsync();
        Task<TaskResponseDto?> GetTaskDetailsAsync(TaskIdDto dto);
        Task UpdateTaskAsync(UpdateTaskDto dto);
    }
}
