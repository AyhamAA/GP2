
namespace Application.DTOs.Requests.TaskRequests
{
    public class CreateTaskDto
    {
        public int AdminId { get; set; }
        public DateTime DueDate { get; set; }
        public string? Notes { get; set; }
    }

}
