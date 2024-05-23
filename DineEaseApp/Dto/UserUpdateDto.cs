namespace DineEaseApp.Dto
{
    public class UserUpdateDto
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNum { get; set; }
        public string Password { get; set; }
        public bool admin { get; set; }

    }
}
