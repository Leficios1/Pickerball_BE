using Database.Model;

namespace Database.DTO.Response
{
    public class RefereeResponse
    {
        public UserResponseDTO User { get; set; }
        public Refree Referee { get; set; }
    }
}
