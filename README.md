# Pickerball_BE

Tourament Details
 "Tournament": {
    "Id": 1001,
    "Name": "Autumn Open 2025",
    "Location": "Central Park Courts",
    "MaxPlayer": 64,
    "Description": "Open tournament for all skill levels.",
    "Banner": "https://example.com/images/tournament-banner.jpg",
    "Note": "Please check in at least 30 minutes before your match.",
    "TotalPrize": 2000,
    "StartDate": "2025-09-05T09:00:00",
    "EndDate": "2025-09-06T19:00:00",
    "Type": "Singles",
    "OrganizerId": 2,
        "MatchDetails": [
          {
            "MatchId": 3001,
	    "Player1Id": 120
            "Player2Id": 121,
            "ScheduledTime": "2025-09-05T12:00:00",
            "Score": "21-18, 21-16",
            "Result": "Won"
          },
          {
            "MatchId": 3002,
	    "Player1Id": 123
            "Player2Id": 124,
            "ScheduledTime": "2025-09-05T12:00:00",
            "Score": "18-21, 16-21",
            "Result": "Lost"
          }
        ]
    "Registrations": [
      {
        "Id": 501,
        "PlayerId": 120,
        "PaymentId": 4501,
        "RegisteredAt": "2025-08-15T10:00:00",
        "IsApproved": true,
        "PlayerDetails": {
          "Name": "John Doe",
          "Email": "john.doe@example.com",
          "Ranking": 15,
          "AvatarUrl": "////"
        },
        "PaymentStatus": "Completed",
      },
      {
        "Id": 502,
        "PlayerId": 121,
        "PaymentId": 4502,
        "RegisteredAt": "2025-08-16T11:00:00",
        "IsApproved": true,
        "PlayerDetails": {
          "Name": "Jane Smith",
          "Email": "jane.smith@example.com",
          "Ranking": 18
        },
        "PaymentStatus": "Completed",
        ]
      }
    ]
  }
}

