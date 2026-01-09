using Application.DTOs.AllRequests.TaskRequests;
using Application.DTOs.Requests.TaskRequests;
using Application.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedShareAppAPI.Controllers
{
    [ApiController]
    [Route("api/tasks")]
    [Authorize(Roles = "Admin")]
    public class TasksController : ControllerBase
    {
        private readonly ITaskService _taskService;

        public TasksController(ITaskService taskService)
        {
            _taskService = taskService;
        }
 
        [HttpPost("assign")]
        public async Task<IActionResult> AssignTask([FromBody] CreateTaskDto dto)
        {
            await _taskService.AddTaskAsync(dto);
            return Ok("Task assigned successfully.");
        }

        [HttpPut("cancel")]
        public async Task<IActionResult> CancelTask([FromBody] TaskIdDto dto)
        {
            await _taskService.CancelTaskAsync(dto);
            return Ok("Task cancelled successfully.");
        }

        [HttpPut("update")]
        public async Task<IActionResult> UpdateTask([FromBody] UpdateTaskDto dto)
        {
            await _taskService.UpdateTaskAsync(dto);
            return Ok("Task updated successfully.");
        }

        [HttpGet]
        public async Task<IActionResult> GetAllTasks()
        {
            return Ok(await _taskService.GetAllTasksAsync());
        }

        [HttpPost("details")]
        public async Task<IActionResult> GetTaskDetails([FromBody] TaskIdDto dto)
        {
            var task = await _taskService.GetTaskDetailsAsync(dto);

            if (task == null)
                return NotFound("Task not found.");

            return Ok(task);
        }
    }

}
