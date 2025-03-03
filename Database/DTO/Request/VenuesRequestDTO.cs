﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class VenuesRequestDTO
    {
        public string? Name { get; set; }
        public string? Address { get; set; }
        public int? Capacity { get; set; }
        [Url] public string? UrlImage { get; set; }
        [ForeignKey("User")] public int? CreateBy { get; set; }
    }
    public class VenuesUpdateRequestDTO
    {
        public string? Name { get; set; }
        public string? Address { get; set; }
        public int? Capacity { get; set; }
        [Url]
        public string? UrlImage { get; set; }
        [ForeignKey("User")]
        public int? CreateBy { get; set; }
    }
}
