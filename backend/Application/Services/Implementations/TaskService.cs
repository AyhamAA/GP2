using Application.DTOs.AllRequests.TaskRequests;
using Application.DTOs.Requests.TaskRequests;
using Application.Repositories.Interfaces;
using Application.Services.Interfaces;
using Domain.Entities;
using Domain.Entities.Enum;
using Microsoft.EntityFrameworkCore;

namespace Application.Services.Implementations
{
    public class TaskService : ITaskService
    {
        private readonly IGenericRepository<RequestTask> _taskRepo;
        public TaskService(IGenericRepository<RequestTask> taskRepo)
        {
            _taskRepo = taskRepo;
        }

        public async Task AddTaskAsync(CreateTaskDto dto)
        {
            var task = new RequestTask
            {
                AdminId = dto.AdminId,
                DueDate = dto.DueDate,
                Notes = dto.Notes,
                Status = TasksStatus.Pending
            };

            await _taskRepo.Insert(task);
            await _taskRepo.SaveChanges();
        }

        public async Task CancelTaskAsync(TaskIdDto dto)
        {
            var task = await _taskRepo.GetAll().FirstOrDefaultAsync(t => t.TaskId == dto.TaskId);

            if (task == null)  
                
                throw new KeyNotFoundException("Task not found");

            task.Status = TasksStatus.Cancelled;

            await _taskRepo.SaveChanges();
        }

        public async Task UpdateTaskAsync(UpdateTaskDto dto)
        {
            var task = await _taskRepo.GetAll()
                .FirstOrDefaultAsync(t => t.TaskId == dto.TaskId);

            if (task == null)
                throw new KeyNotFoundException("Task not found");

            task.DueDate = dto.DueDate;
            task.Notes = dto.Notes;
            task.Status = dto.Status;

            await _taskRepo.SaveChanges();
        }

        public async Task<List<TaskResponseDto>> GetAllTasksAsync()
        {
            return await _taskRepo.GetAll()
                .Select(t => new TaskResponseDto
                {
                    TaskId = t.TaskId,
                    DueDate = t.DueDate,
                    Notes = t.Notes,
                    Status = t.Status
                })
                .ToListAsync();
        }

        public async Task<TaskResponseDto?> GetTaskDetailsAsync(TaskIdDto dto)
        {
            return await _taskRepo.GetAll()
                .Where(t => t.TaskId == dto.TaskId)
                .Select(t => new TaskResponseDto
                {
                    TaskId = t.TaskId,
                    DueDate = t.DueDate,
                    Notes = t.Notes,
                    Status = t.Status
                })
                .FirstOrDefaultAsync();
        }
    }

}
