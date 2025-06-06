import { useQuery } from '@tanstack/react-query';
import Api from '@src/api/api';
import { TournamentPayment } from '../models';
import { GET_ALL_BILLS_BY_TOURNAMENT_ID } from '../constants';

const fetchAllBillsByTournamentId = async (
  tournamentId: number
): Promise<TournamentPayment[]> => {
  const response = await Api.get<TournamentPayment[]>(
    `/payment/vn-pay/GetAllBillByTouramentId/${tournamentId}`
  );
  return response.data;
};

export function useGetAllBillsByTournamentId(tournamentId: number) {
  return useQuery<TournamentPayment[]>({
    queryKey: [GET_ALL_BILLS_BY_TOURNAMENT_ID, tournamentId],
    queryFn: () => fetchAllBillsByTournamentId(tournamentId),
    enabled: !!tournamentId,
  });
}
