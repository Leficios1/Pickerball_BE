// Sample data for Match
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/models/models.dart';

List<Match> sampleMatches = [
  Match(
    id: 1,
    title: 'Match 1',
    description: 'Description for Match 1',
    matchDate: DateTime.now().add(Duration(days: 1)),
    createdAt: DateTime.now(),
    venueId: 1,
    status: MatchStatus.scheduled.value,
    matchCategory: MatchCategory.competitive.value,
    matchFormat: TournamentFormant.single.value,
    winScore: MatchWinScore.eleven.value,
    team1Score: null,
    team2Score: null,
    isPublic: true,
    roomOwner: 1,
    refereeId: 1,
  ),
  Match(
    id: 2,
    title: 'Match 2',
    description: 'Description for Match 2',
    matchDate: DateTime.now().add(Duration(days: 2)),
    createdAt: DateTime.now(),
    venueId: 2,
    status: MatchStatus.ongoing.value,
    matchCategory: MatchCategory.tournament.value,
    matchFormat: TournamentFormant.doubles.value,
    winScore: MatchWinScore.twentyOne.value,
    team1Score: 10,
    team2Score: 15,
    isPublic: false,
    roomOwner: 2,
    refereeId: 2,
  ),
];

// Sample data for Venues
List<Venues> sampleVenues = [
  Venues(
    id: 1,
    name: 'Venue 1',
    address: '123 Main St',
    capacity: 100,
    urlImage: 'https://example.com/venue1.jpg',
    createBy: 1,
  ),
  Venues(
    id: 2,
    name: 'Venue 2',
    address: '456 Elm St',
    capacity: 200,
    urlImage: 'https://example.com/venue2.jpg',
    createBy: 2,
  ),
];

// Sample data for User with role Referee
List<User> sampleUsers = [
  User(
    id: 1,
    firstName: 'John',
    lastName: 'Doe',
    secondName: 'A',
    email: 'john.doe@example.com',
    passwordHash: 'hashed_password',
    dateOfBirth: DateTime(1990, 1, 1),
    avatarUrl: 'https://example.com/avatar1.jpg',
    gender: Gender.male.label,
    status: true,
    roleId: RoleUser.referee.value,
    refreshToken: 'refresh_token_1',
    createAt: DateTime.now(),
    refreshTokenExpiryTime: DateTime.now().add(Duration(days: 30)),
    phoneNumber: '1234567890',
  ),
  User(
    id: 2,
    firstName: 'Jane',
    lastName: 'Smith',
    secondName: 'B',
    email: 'jane.smith@example.com',
    passwordHash: 'hashed_password',
    dateOfBirth: DateTime(1985, 5, 15),
    avatarUrl: 'https://example.com/avatar2.jpg',
    gender: Gender.female.label,
    status: true,
    roleId: RoleUser.referee.value,
    refreshToken: 'refresh_token_2',
    createAt: DateTime.now(),
    refreshTokenExpiryTime: DateTime.now().add(Duration(days: 30)),
    phoneNumber: '1234567890',
  ),
];
