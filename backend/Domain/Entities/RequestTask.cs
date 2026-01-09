using Domain.Entities.Enum;
using System.ComponentModel.DataAnnotations;

namespace Domain.Entities
{
    public class RequestTask
    {
        [Key]
        public int TaskId { get; set; }
        public TimeOnly Time { get; set; }
        public string Title { get; set; }
        public int AdminId { get; set; }
        public User? User { get; set; } 

        public DateTime AssignedDate { get; set; }
        public DateTime DueDate { get; set; }

        public TasksStatus Status { get; set; } = TasksStatus.Pending;

        public string? Notes { get; set; }
    }
}
