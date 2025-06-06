import Api from '@src/api/api';
import { useQuery } from '@tanstack/react-query';

/**
 * Sponsor model interface
 */
export interface Sponsor {
  id: number;
  name: string;
  logo: string;
  description: string | null;
  website: string;
  donate: number;
}

/**
 * Fetches all sponsors for a specific tournament
 */
const fetchSponsorsByTournamentId = async (tournamentId: number): Promise<Sponsor[]> => {
  const response = await Api.get(
    `/Tourament/GetAllSponnerByTouramentId/${tournamentId}`
  );
  return response.data as Sponsor[]// Extract sponsors array from data property
};

/**
 * Hook to query sponsors for a specific tournament
 */
export function useGetSponsorsByTournamentId(tournamentId: number) {
  return useQuery<Sponsor[], Error>({
    queryKey: ['tournamentSponsors', tournamentId],
    queryFn: () => fetchSponsorsByTournamentId(tournamentId),
    enabled: !!tournamentId, // Only run query if tournamentId is provided
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}
