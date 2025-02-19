using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class SponnerRequestDTO
    {
        public int? Id { get; set; }
        public string CompanyName { get; set; } = null!;
        public string? LogoUrl { get; set; }
        [Url]
        public string UrlSocial { get; set; } = null!;
        [Url]
        public string? UrlSocial1 { get; set; } = null!;
        public string ContactEmail { get; set; } = null!;
        public string? Descreption { get; set; }

    }
}
