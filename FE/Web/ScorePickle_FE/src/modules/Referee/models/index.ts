export interface RefereeResponse {
  refreeId: number;
  user: User;
  refreeCode: string;
  refreeLevel: string | null;
  refreeNote: string | null;
  createdAt: string;
  lastUpdatedAt: string;
  isAccept: boolean;
  tournamentReferees: any | null;
}

interface User {
  id: number;
  firstName: string;
  lastName: string;
  secondName: string | null;
  email: string;
  passwordHash: string;
  dateOfBirth: string; // Or Date if you want to convert it to a Date object
  avatarUrl: string;
  gender: 'Male' | 'Female' | 'Other'; // Adjust as needed for the gender options
  phoneNumber: string;
  status: boolean;
  reason: string | null;
  roleId: number;
  refreshToken: string;
  createAt: string; // Or Date if you want to convert it to a Date object
  refreshTokenExpiryTime: string; // Or Date if you want to convert it to a Date object
  role: any | null;
  player: any | null;
  sponsor: any | null;
  payments: any | null;
  achievements: any | null;
  notifications: any | null;
  venues: any | null;
}
