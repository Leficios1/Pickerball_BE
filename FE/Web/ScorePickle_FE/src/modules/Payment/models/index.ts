export interface Bill {
  userId: number;
  note: string;
  type: number;
  paymentMethod: any;
  id: number;
  tournamentId: number;
  amount: number;
  status: PaymentStatus;
  createdDate: string;
  paymentDate?: string;
  transactionId?: string;
}

export interface PaymentResponse {
  responseCodeMessage: string;
  transactionStatusMessage: string;
  vnPayResponse: VnPayResponse;
}

export interface VnPayResponse {
  bankTranNo: string;
  payDate: string;
  orderInfo: string;
  responseCode: string;
  transactionId: string;
  transactionStatus: string;
  cardType: number;
  txnRef: string;
  amount: number;
  bankCode: string;
  note: string;
}

export interface TournamentPayment {
  id: number;
  userId: number;
  tournamentId: number;
  amount: number;
  note: string;
  paymentMethod: string;
  status: PaymentStatus;
  type: TypePayment;
  paymentDate: string; // ISO 8601 date string, ví dụ "2025-04-30T01:39:32.9083351"
}

export enum TypePayment {
  Donate = 1,
  Fee = 2,
  Award = 3,
}

export enum PaymentStatus {
  Pending,
  Completed,
  Failed,
}

export interface SponsorRequest {
  sponnerId: number;
  touramentId: number;
  returnUrl: number;
  amount: number;
}
