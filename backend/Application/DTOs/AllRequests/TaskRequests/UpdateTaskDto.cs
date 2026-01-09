using Domain.Entities.Enum;

namespace Application.DTOs.AllRequests.TaskRequests
{
    public class UpdateTaskDto
    {
        public int TaskId { get; set; }
        public DateTime DueDate { get; set; }
        public string? Notes { get; set; }
        public TasksStatus Status { get; set; }
    }


}
