USE
[master]
GO
/****** Object:  Database [PickerBall]    Script Date: 23/02/2025 3:14:24 CH ******/
CREATE
DATABASE [PickerBall]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PickerBall', FILENAME = N'/var/opt/mssql/data/PickerBall.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PickerBall_log', FILENAME = N'/var/opt/mssql/data/PickerBall_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER
DATABASE [PickerBall] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PickerBall].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER
DATABASE [PickerBall] SET ANSI_NULL_DEFAULT OFF
GO
ALTER
DATABASE [PickerBall] SET ANSI_NULLS OFF
GO
ALTER
DATABASE [PickerBall] SET ANSI_PADDING OFF
GO
ALTER
DATABASE [PickerBall] SET ANSI_WARNINGS OFF
GO
ALTER
DATABASE [PickerBall] SET ARITHABORT OFF
GO
ALTER
DATABASE [PickerBall] SET AUTO_CLOSE OFF
GO
ALTER
DATABASE [PickerBall] SET AUTO_SHRINK OFF
GO
ALTER
DATABASE [PickerBall] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER
DATABASE [PickerBall] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER
DATABASE [PickerBall] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER
DATABASE [PickerBall] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER
DATABASE [PickerBall] SET NUMERIC_ROUNDABORT OFF
GO
ALTER
DATABASE [PickerBall] SET QUOTED_IDENTIFIER OFF
GO
ALTER
DATABASE [PickerBall] SET RECURSIVE_TRIGGERS OFF
GO
ALTER
DATABASE [PickerBall] SET  ENABLE_BROKER
GO
ALTER
DATABASE [PickerBall] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER
DATABASE [PickerBall] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER
DATABASE [PickerBall] SET TRUSTWORTHY OFF
GO
ALTER
DATABASE [PickerBall] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER
DATABASE [PickerBall] SET PARAMETERIZATION SIMPLE
GO
ALTER
DATABASE [PickerBall] SET READ_COMMITTED_SNAPSHOT ON
GO
ALTER
DATABASE [PickerBall] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER
DATABASE [PickerBall] SET RECOVERY FULL
GO
ALTER
DATABASE [PickerBall] SET  MULTI_USER
GO
ALTER
DATABASE [PickerBall] SET PAGE_VERIFY CHECKSUM
GO
ALTER
DATABASE [PickerBall] SET DB_CHAINING OFF
GO
ALTER
DATABASE [PickerBall] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO
ALTER
DATABASE [PickerBall] SET TARGET_RECOVERY_TIME = 60 SECONDS
GO
ALTER
DATABASE [PickerBall] SET DELAYED_DURABILITY = DISABLED
GO
ALTER
DATABASE [PickerBall] SET ACCELERATED_DATABASE_RECOVERY = OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'PickerBall', N'ON'
GO
ALTER
DATABASE [PickerBall] SET QUERY_STORE = ON
GO
ALTER
DATABASE [PickerBall] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PickerBall]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 23/02/2025 3:14:25 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory]
(
    [
    MigrationId] [
    nvarchar]
(
    150
) NOT NULL,
    [ProductVersion] [nvarchar]
(
    32
) NOT NULL,
    CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED
(
[
    MigrationId]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Achievements]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Achievements]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [UserId] [int] NOT NULL,
    [Title] [nvarchar]
(
    max
) NOT NULL,
    [Description] [nvarchar]
(
    max
) NOT NULL,
    [AwardedAt] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_Achievements] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[BlogCategories]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[BlogCategories]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [Name] [nvarchar]
(
    max
) NOT NULL,
    CONSTRAINT [PK_BlogCategories] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Friends]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Friends]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [User1Id] [int] NOT NULL,
    [User2Id] [int] NOT NULL,
    [Status] [int] NOT NULL,
    [CreatedAt] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_Friends] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Matches]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Matches]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [Title] [nvarchar]
(
    max
) NOT NULL,
    [Description] [nvarchar]
(
    max
) NOT NULL,
    [MatchDate] [datetime2]
(
    7
) NOT NULL,
    [CreateAt] [datetime2]
(
    7
) NULL,
    [VenueId] [int] NULL,
    [Status] [int] NOT NULL,
    [MatchCategory] [int] NOT NULL,
    [MatchFormat] [int] NOT NULL,
    [WinScore] [int] NOT NULL,
    [Team1Score] [int] NULL,
    [Team2Score] [int] NULL,
    [IsPublic] [bit] NOT NULL,
    [RoomOwner] [int] NOT NULL,
    [RefereeId] [int] NULL,
    CONSTRAINT [PK_Matches] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[MatchesSendRequest]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[MatchesSendRequest]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [MatchingId] [int] NOT NULL,
    [PlayerRequestId] [int] NOT NULL,
    [PlayerRecieveId] [int] NOT NULL,
    [status] [int] NOT NULL,
    [CreateAt] [datetime2]
(
    7
) NOT NULL,
    [LastUpdatedAt] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_MatchesSendRequest] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Notifications]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [UserId] [int] NOT NULL,
    [Message] [nvarchar]
(
    max
) NOT NULL,
    [CreatedAt] [datetime2]
(
    7
) NOT NULL,
    [IsRead] [bit] NOT NULL,
    CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Payments]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Payments]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [UserId] [int] NOT NULL,
    [TournamentId] [int] NOT NULL,
    [Amount] [decimal]
(
    18,
    2
) NOT NULL,
    [Status] [int] NOT NULL,
    [Type] [int] NOT NULL,
    [PaymentDate] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Player]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Player]
(
    [
    PlayerId] [
    int]
    NOT
    NULL, [
    Province] [
    nvarchar]
(
    max
) NOT NULL,
    [City] [nvarchar]
(
    max
) NOT NULL,
    [TotalMatch] [int] NOT NULL,
    [TotalWins] [int] NOT NULL,
    [RankingPoint] [int] NOT NULL,
    [ExperienceLevel] [int] NOT NULL,
    [JoinedAt] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_Player] PRIMARY KEY CLUSTERED
(
[
    PlayerId]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Rankings]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Rankings]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [PlayerId] [int] NOT NULL,
    [TournamentId] [int] NOT NULL,
    [Points] [int] NOT NULL,
    [Position] [int] NOT NULL,
    CONSTRAINT [PK_Rankings] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Roles]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Roles]
(
    [
    RoleId] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [RoleName] [nvarchar]
(
    max
) NOT NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED
(
[
    RoleId]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Rules]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Rules]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [Title] [nvarchar]
(
    max
) NOT NULL,
    [Content] [nvarchar]
(
    max
) NOT NULL,
    [BlogCategoryId] [int] NOT NULL,
    CONSTRAINT [PK_Rules] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[RulesScores]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[RulesScores]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [MinDifference] [int] NOT NULL,
    [MaxDifference] [int] NOT NULL,
    [WinnerGain] [int] NOT NULL,
    [LoseGain] [int] NOT NULL,
    [CreateAt] [datetime2]
(
    7
) NOT NULL,
    [UpdateAt] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_RulesScores] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Sponsors]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Sponsors]
(
    [
    SponsorId] [
    int]
    NOT
    NULL, [
    CompanyName] [
    nvarchar]
(
    max
) NOT NULL,
    [LogoUrl] [nvarchar]
(
    max
) NULL,
    [UrlSocial] [nvarchar]
(
    max
) NOT NULL,
    [UrlSocial1] [nvarchar]
(
    max
) NULL,
    [ContactEmail] [nvarchar]
(
    max
) NOT NULL,
    [Descreption] [nvarchar]
(
    max
) NULL,
    [isAccept] [bit] NOT NULL,
    [JoinedAt] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_Sponsors] PRIMARY KEY CLUSTERED
(
[
    SponsorId]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[TeamMembers]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[TeamMembers]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [TeamId] [int] NOT NULL,
    [PlayerId] [int] NOT NULL,
    [JoinedAt] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_TeamMembers] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Teams]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Teams]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [Name] [nvarchar]
(
    max
) NOT NULL,
    [CaptainId] [int] NULL,
    [MatchingId] [int] NULL,
    CONSTRAINT [PK_Teams] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[TouramentMatches]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[TouramentMatches]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [TournamentId] [int] NOT NULL,
    [MatchesId] [int] NOT NULL,
    [CreateAt] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_TouramentMatches] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[TournamentProgresses]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[TournamentProgresses]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [TournamentRegistrationId] [int] NOT NULL,
    [RoundNumber] [int] NOT NULL,
    [IsEliminated] [bit] NOT NULL,
    [Wins] [int] NOT NULL,
    [Losses] [int] NOT NULL,
    [LastUpdated] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_TournamentProgresses] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[TournamentRegistrations]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[TournamentRegistrations]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [TournamentId] [int] NOT NULL,
    [PlayerId] [int] NOT NULL,
    [RegisteredAt] [datetime2]
(
    7
) NOT NULL,
    [IsApproved] [bit] NOT NULL,
    CONSTRAINT [PK_TournamentRegistrations] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Tournaments]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Tournaments]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [Name] [nvarchar]
(
    max
) NOT NULL,
    [Location] [nvarchar]
(
    max
) NOT NULL,
    [MaxPlayer] [int] NOT NULL,
    [Descreption] [nvarchar]
(
    max
) NULL,
    [Banner] [nvarchar]
(
    max
) NOT NULL,
    [Note] [nvarchar]
(
    max
) NULL,
    [TotalPrize] [decimal]
(
    18,
    2
) NOT NULL,
    [StartDate] [datetime2]
(
    7
) NOT NULL,
    [EndDate] [datetime2]
(
    7
) NOT NULL,
    [CreateAt] [datetime2]
(
    7
) NOT NULL,
    [Type] [int] NOT NULL,
    [Status] [nvarchar]
(
    max
) NOT NULL,
    [IsAccept] [bit] NOT NULL,
    [OrganizerId] [int] NOT NULL,
    CONSTRAINT [PK_Tournaments] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Users]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Users]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [FirstName] [nvarchar]
(
    max
) NOT NULL,
    [LastName] [nvarchar]
(
    max
) NOT NULL,
    [SecondName] [nvarchar]
(
    max
) NULL,
    [Email] [nvarchar]
(
    max
) NOT NULL,
    [PasswordHash] [nvarchar]
(
    max
) NOT NULL,
    [DateOfBirth] [datetime2]
(
    7
) NULL,
    [AvatarUrl] [nvarchar]
(
    max
) NULL,
    [Gender] [nvarchar]
(
    10
) NULL,
    [Status] [bit] NOT NULL,
    [RoleId] [int] NULL,
    [RefreshToken] [nvarchar]
(
    max
) NOT NULL,
    [CreateAt] [datetime2]
(
    7
) NULL,
    [RefreshTokenExpiryTime] [datetime2]
(
    7
) NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Table [dbo].[Venues]    Script Date: 23/02/2025 3:14:25 CH ******/
    SET ANSI_NULLS
    ON
    GO
    SET QUOTED_IDENTIFIER
    ON
    GO
CREATE TABLE [dbo].[Venues]
(
    [
    Id] [
    int]
    IDENTITY
(
    1,
    1
) NOT NULL,
    [Name] [nvarchar]
(
    max
) NOT NULL,
    [Address] [nvarchar]
(
    max
) NOT NULL,
    [Capacity] [int] NOT NULL,
    [UrlImage] [nvarchar]
(
    max
) NULL,
    [CreateBy] [int] NOT NULL,
    CONSTRAINT [PK_Venues] PRIMARY KEY CLUSTERED
(
[
    Id]
    ASC
)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
    ON [PRIMARY]
    )
    ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    GO
/****** Object:  Index [IX_Achievements_UserId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Achievements_UserId] ON [dbo].[Achievements]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Friends_User1Id]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Friends_User1Id] ON [dbo].[Friends]
(
	[User1Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Friends_User2Id]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Friends_User2Id] ON [dbo].[Friends]
(
	[User2Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Matches_RefereeId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Matches_RefereeId] ON [dbo].[Matches]
(
	[RefereeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Matches_RoomOwner]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Matches_RoomOwner] ON [dbo].[Matches]
(
	[RoomOwner] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Matches_VenueId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Matches_VenueId] ON [dbo].[Matches]
(
	[VenueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_MatchesSendRequest_MatchingId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_MatchesSendRequest_MatchingId] ON [dbo].[MatchesSendRequest]
(
	[MatchingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_MatchesSendRequest_PlayerRecieveId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_MatchesSendRequest_PlayerRecieveId] ON [dbo].[MatchesSendRequest]
(
	[PlayerRecieveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_MatchesSendRequest_PlayerRequestId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_MatchesSendRequest_PlayerRequestId] ON [dbo].[MatchesSendRequest]
(
	[PlayerRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Notifications_UserId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Notifications_UserId] ON [dbo].[Notifications]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Payments_TournamentId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Payments_TournamentId] ON [dbo].[Payments]
(
	[TournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Payments_UserId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Payments_UserId] ON [dbo].[Payments]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rankings_PlayerId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Rankings_PlayerId] ON [dbo].[Rankings]
(
	[PlayerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rankings_TournamentId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Rankings_TournamentId] ON [dbo].[Rankings]
(
	[TournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rules_BlogCategoryId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Rules_BlogCategoryId] ON [dbo].[Rules]
(
	[BlogCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TeamMembers_PlayerId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_TeamMembers_PlayerId] ON [dbo].[TeamMembers]
(
	[PlayerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TeamMembers_TeamId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_TeamMembers_TeamId] ON [dbo].[TeamMembers]
(
	[TeamId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Teams_CaptainId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Teams_CaptainId] ON [dbo].[Teams]
(
	[CaptainId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Teams_MatchingId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Teams_MatchingId] ON [dbo].[Teams]
(
	[MatchingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TouramentMatches_MatchesId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_TouramentMatches_MatchesId] ON [dbo].[TouramentMatches]
(
	[MatchesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TouramentMatches_TournamentId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_TouramentMatches_TournamentId] ON [dbo].[TouramentMatches]
(
	[TournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TournamentProgresses_TournamentRegistrationId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_TournamentProgresses_TournamentRegistrationId] ON [dbo].[TournamentProgresses]
(
	[TournamentRegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TournamentRegistrations_PlayerId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_TournamentRegistrations_PlayerId] ON [dbo].[TournamentRegistrations]
(
	[PlayerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TournamentRegistrations_TournamentId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_TournamentRegistrations_TournamentId] ON [dbo].[TournamentRegistrations]
(
	[TournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tournaments_OrganizerId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Tournaments_OrganizerId] ON [dbo].[Tournaments]
(
	[OrganizerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Users_RoleId]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Users_RoleId] ON [dbo].[Users]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Venues_CreateBy]    Script Date: 23/02/2025 3:14:25 CH ******/
CREATE
NONCLUSTERED INDEX [IX_Venues_CreateBy] ON [dbo].[Venues]
(
	[CreateBy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Achievements] WITH CHECK ADD CONSTRAINT [FK_Achievements_Users_UserId] FOREIGN KEY ([UserId])
    REFERENCES [dbo].[Users] ([Id])
    ON
DELETE
CASCADE
GO
ALTER TABLE [dbo].[Achievements] CHECK CONSTRAINT [FK_Achievements_Users_UserId]
    GO
ALTER TABLE [dbo].[Friends] WITH CHECK ADD CONSTRAINT [FK_Friends_Users_User1Id] FOREIGN KEY ([User1Id])
    REFERENCES [dbo].[Users] ([Id])
    GO
ALTER TABLE [dbo].[Friends] CHECK CONSTRAINT [FK_Friends_Users_User1Id]
    GO
ALTER TABLE [dbo].[Friends] WITH CHECK ADD CONSTRAINT [FK_Friends_Users_User2Id] FOREIGN KEY ([User2Id])
    REFERENCES [dbo].[Users] ([Id])
    GO
ALTER TABLE [dbo].[Friends] CHECK CONSTRAINT [FK_Friends_Users_User2Id]
    GO
ALTER TABLE [dbo].[Matches] WITH CHECK ADD CONSTRAINT [FK_Matches_Users_RefereeId] FOREIGN KEY ([RefereeId])
    REFERENCES [dbo].[Users] ([Id])
    GO
ALTER TABLE [dbo].[Matches] CHECK CONSTRAINT [FK_Matches_Users_RefereeId]
    GO
ALTER TABLE [dbo].[Matches] WITH CHECK ADD CONSTRAINT [FK_Matches_Users_RoomOwner] FOREIGN KEY ([RoomOwner])
    REFERENCES [dbo].[Users] ([Id])
    ON
DELETE
CASCADE
GO
ALTER TABLE [dbo].[Matches] CHECK CONSTRAINT [FK_Matches_Users_RoomOwner]
    GO
ALTER TABLE [dbo].[Matches] WITH CHECK ADD CONSTRAINT [FK_Matches_Venues_VenueId] FOREIGN KEY ([VenueId])
    REFERENCES [dbo].[Venues] ([Id])
    ON
DELETE
CASCADE
GO
ALTER TABLE [dbo].[Matches] CHECK CONSTRAINT [FK_Matches_Venues_VenueId]
    GO
ALTER TABLE [dbo].[MatchesSendRequest] WITH CHECK ADD CONSTRAINT [FK_MatchesSendRequest_Matches_MatchingId] FOREIGN KEY ([MatchingId])
    REFERENCES [dbo].[Matches] ([Id])
    ON
DELETE
CASCADE
GO
ALTER TABLE [dbo].[MatchesSendRequest] CHECK CONSTRAINT [FK_MatchesSendRequest_Matches_MatchingId]
    GO
ALTER TABLE [dbo].[MatchesSendRequest] WITH CHECK ADD CONSTRAINT [FK_MatchesSendRequest_Player_PlayerRecieveId] FOREIGN KEY ([PlayerRecieveId])
    REFERENCES [dbo].[Player] ([PlayerId])
    GO
ALTER TABLE [dbo].[MatchesSendRequest] CHECK CONSTRAINT [FK_MatchesSendRequest_Player_PlayerRecieveId]
    GO
ALTER TABLE [dbo].[MatchesSendRequest] WITH CHECK ADD CONSTRAINT [FK_MatchesSendRequest_Player_PlayerRequestId] FOREIGN KEY ([PlayerRequestId])
    REFERENCES [dbo].[Player] ([PlayerId])
    GO
ALTER TABLE [dbo].[MatchesSendRequest] CHECK CONSTRAINT [FK_MatchesSendRequest_Player_PlayerRequestId]
    GO
ALTER TABLE [dbo].[Notifications] WITH CHECK ADD CONSTRAINT [FK_Notifications_Users_UserId] FOREIGN KEY ([UserId])
    REFERENCES [dbo].[Users] ([Id])
    ON
DELETE
CASCADE
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_Users_UserId]
    GO
ALTER TABLE [dbo].[Payments] WITH CHECK ADD CONSTRAINT [FK_Payments_Tournaments_TournamentId] FOREIGN KEY ([TournamentId])
    REFERENCES [dbo].[Tournaments] ([Id])
    GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_Tournaments_TournamentId]
    GO
ALTER TABLE [dbo].[Payments] WITH CHECK ADD CONSTRAINT [FK_Payments_Users_UserId] FOREIGN KEY ([UserId])
    REFERENCES [dbo].[Users] ([Id])
    GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_Users_UserId]
    GO
ALTER TABLE [dbo].[Player] WITH CHECK ADD CONSTRAINT [FK_Player_Users_PlayerId] FOREIGN KEY ([PlayerId])
    REFERENCES [dbo].[Users] ([Id])
    ON
DELETE
CASCADE
GO
ALTER TABLE [dbo].[Player] CHECK CONSTRAINT [FK_Player_Users_PlayerId]
    GO
ALTER TABLE [dbo].[Rankings] WITH CHECK ADD CONSTRAINT [FK_Rankings_Player_PlayerId] FOREIGN KEY ([PlayerId])
    REFERENCES [dbo].[Player] ([PlayerId])
    GO
ALTER TABLE [dbo].[Rankings] CHECK CONSTRAINT [FK_Rankings_Player_PlayerId]
    GO
ALTER TABLE [dbo].[Rankings] WITH CHECK ADD CONSTRAINT [FK_Rankings_Tournaments_TournamentId] FOREIGN KEY ([TournamentId])
    REFERENCES [dbo].[Tournaments] ([Id])
    ON
DELETE
CASCADE
GO
ALTER TABLE [dbo].[Rankings] CHECK CONSTRAINT [FK_Rankings_Tournaments_TournamentId]
    GO
ALTER TABLE [dbo].[Rules] WITH CHECK ADD CONSTRAINT [FK_Rules_BlogCategories_BlogCategoryId] FOREIGN KEY ([BlogCategoryId])
    REFERENCES [dbo].[BlogCategories] ([Id])
    GO
ALTER TABLE [dbo].[Rules] CHECK CONSTRAINT [FK_Rules_BlogCategories_BlogCategoryId]
    GO
ALTER TABLE [dbo].[Sponsors] WITH CHECK ADD CONSTRAINT [FK_Sponsors_Users_SponsorId] FOREIGN KEY ([SponsorId])
    REFERENCES [dbo].[Users] ([Id])
    ON
DELETE
CASCADE
GO
ALTER TABLE [dbo].[Sponsors] CHECK CONSTRAINT [FK_Sponsors_Users_SponsorId]
    GO
ALTER TABLE [dbo].[TeamMembers] WITH CHECK ADD CONSTRAINT [FK_TeamMembers_Player_PlayerId] FOREIGN KEY ([PlayerId])
    REFERENCES [dbo].[Player] ([PlayerId])
    GO
ALTER TABLE [dbo].[TeamMembers] CHECK CONSTRAINT [FK_TeamMembers_Player_PlayerId]
    GO
ALTER TABLE [dbo].[TeamMembers] WITH CHECK ADD CONSTRAINT [FK_TeamMembers_Teams_TeamId] FOREIGN KEY ([TeamId])
    REFERENCES [dbo].[Teams] ([Id])
    GO
ALTER TABLE [dbo].[TeamMembers] CHECK CONSTRAINT [FK_TeamMembers_Teams_TeamId]
    GO
ALTER TABLE [dbo].[Teams] WITH CHECK ADD CONSTRAINT [FK_Teams_Matches_MatchingId] FOREIGN KEY ([MatchingId])
    REFERENCES [dbo].[Matches] ([Id])
    GO
ALTER TABLE [dbo].[Teams] CHECK CONSTRAINT [FK_Teams_Matches_MatchingId]
    GO
ALTER TABLE [dbo].[Teams] WITH CHECK ADD CONSTRAINT [FK_Teams_Player_CaptainId] FOREIGN KEY ([CaptainId])
    REFERENCES [dbo].[Player] ([PlayerId])
    GO
ALTER TABLE [dbo].[Teams] CHECK CONSTRAINT [FK_Teams_Player_CaptainId]
    GO
ALTER TABLE [dbo].[TouramentMatches] WITH CHECK ADD CONSTRAINT [FK_TouramentMatches_Matches_MatchesId] FOREIGN KEY ([MatchesId])
    REFERENCES [dbo].[Matches] ([Id])
    GO
ALTER TABLE [dbo].[TouramentMatches] CHECK CONSTRAINT [FK_TouramentMatches_Matches_MatchesId]
    GO
ALTER TABLE [dbo].[TouramentMatches] WITH CHECK ADD CONSTRAINT [FK_TouramentMatches_Tournaments_TournamentId] FOREIGN KEY ([TournamentId])
    REFERENCES [dbo].[Tournaments] ([Id])
    GO
ALTER TABLE [dbo].[TouramentMatches] CHECK CONSTRAINT [FK_TouramentMatches_Tournaments_TournamentId]
    GO
ALTER TABLE [dbo].[TournamentProgresses] WITH CHECK ADD CONSTRAINT [FK_TournamentProgresses_TournamentRegistrations_TournamentRegistrationId] FOREIGN KEY ([TournamentRegistrationId])
    REFERENCES [dbo].[TournamentRegistrations] ([Id])
    GO
ALTER TABLE [dbo].[TournamentProgresses] CHECK CONSTRAINT [FK_TournamentProgresses_TournamentRegistrations_TournamentRegistrationId]
    GO
ALTER TABLE [dbo].[TournamentRegistrations] WITH CHECK ADD CONSTRAINT [FK_TournamentRegistrations_Player_PlayerId] FOREIGN KEY ([PlayerId])
    REFERENCES [dbo].[Player] ([PlayerId])
    GO
ALTER TABLE [dbo].[TournamentRegistrations] CHECK CONSTRAINT [FK_TournamentRegistrations_Player_PlayerId]
    GO
ALTER TABLE [dbo].[TournamentRegistrations] WITH CHECK ADD CONSTRAINT [FK_TournamentRegistrations_Tournaments_TournamentId] FOREIGN KEY ([TournamentId])
    REFERENCES [dbo].[Tournaments] ([Id])
    ON
DELETE
CASCADE
GO
ALTER TABLE [dbo].[TournamentRegistrations] CHECK CONSTRAINT [FK_TournamentRegistrations_Tournaments_TournamentId]
    GO
ALTER TABLE [dbo].[Tournaments] WITH CHECK ADD CONSTRAINT [FK_Tournaments_Sponsors_OrganizerId] FOREIGN KEY ([OrganizerId])
    REFERENCES [dbo].[Sponsors] ([SponsorId])
    GO
ALTER TABLE [dbo].[Tournaments] CHECK CONSTRAINT [FK_Tournaments_Sponsors_OrganizerId]
    GO
ALTER TABLE [dbo].[Users] WITH CHECK ADD CONSTRAINT [FK_Users_Roles_RoleId] FOREIGN KEY ([RoleId])
    REFERENCES [dbo].[Roles] ([RoleId])
    GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Roles_RoleId]
    GO
ALTER TABLE [dbo].[Venues] WITH CHECK ADD CONSTRAINT [FK_Venues_Users_CreateBy] FOREIGN KEY ([CreateBy])
    REFERENCES [dbo].[Users] ([Id])
    GO
ALTER TABLE [dbo].[Venues] CHECK CONSTRAINT [FK_Venues_Users_CreateBy]
    GO
    USE [master]
    GO
ALTER
DATABASE [PickerBall] SET  READ_WRITE
GO
