PickleBall is a complete pickleball community platform backend built with ASP.NET Core 8.0, providing tournament management, match creation, player interactions, and payment processing capabilities.

Key Features
Match Management

Real-time match rooms with automatic team assignment via MatchService.CreateRoomWithTeamsAsync() 1
Best-of-3 scoring system with detailed score tracking through MatchScore entities
Public and private match support with live updates via SignalR
Tournament Operations

Complete tournament lifecycle management through TouramentServices 2
Player/team registration with approval workflows
Automated bracket management and match scheduling
Prize distribution and sponsor integration
User Ecosystem

Multi-role support: Players, Sponsors, Referees, Admins, Staff, Club Admins 3
Social features including friend networks and match requests
Comprehensive user management via UserServices 4
Technology Stack
Framework: ASP.NET Core 8.0
Database: SQL Server with Entity Framework Core
Real-time: SignalR with Azure SignalR Service
Payments: VNPAY and PayOS integration
Authentication: JWT tokens
Mapping: AutoMapper for object transformations
Architecture
The system follows a layered architecture with:

Controllers: API endpoints for match, tournament, user, and payment operations
Services: Business logic layer with dedicated services for each domain
Repositories: Data access layer with Entity Framework
Database: Comprehensive entity model supporting all business domains 5
External Integrations
Payment gateways (VNPAY, PayOS) for tournament fees and donations
Azure SignalR for scalable real-time communication
SMTP services for email notifications
Notes
The codebase demonstrates a well-structured enterprise application with clear separation of concerns, comprehensive business domain coverage, and robust external service integrations. The database schema supports complex tournament structures, team management, and detailed match scoring systems.

Wiki pages you might want to explore:

Overview (Leficios1/Pickerball_BE)

