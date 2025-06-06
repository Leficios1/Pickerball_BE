export interface UpdateProfile {
  userId: number;
  firstName: string;
  lastName: string;
  secondName: string;
  dateOfBirth: string;
  gender: string;
  phoneNumber: string;
  avatarUrl: string;
  status: boolean;
}

export interface UpdateSponsorProfileRequest {
  id: number;
  companyName: string;
  logoUrl: string;
  urlSocial: string;
  urlSocial1: string | null;
  contactEmail: string;
  descreption: string;
}

export interface UpdateSponsorProfileResponse {
  id: number;
  companyName: string;
  logoUrl: string;
  urlSocial: string;
  urlSocial1: string;
  contactEmail: string;
  descreption: string;
  isAccept: boolean;
  joinedAt: Date;
}
