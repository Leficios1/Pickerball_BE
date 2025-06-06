import { useQuery } from '@tanstack/react-query';
import { GET_ALL_TOURNAMENTS } from '../constants';
import { Tournament } from '../models';
import api from '@src//api/api';
import { Pagination } from '@src/modules/Pagination/models';

// const fetchTournaments = async (
//   PageNumber?: number,
//   PageSize?: number
// ): Promise<Pagination<Tournament>> => {
//   try {
//     const response = await api.getByQueryParams('/Tourament/GetAllTournament', {
//       PageNumber,
//       PageSize,
//     });
//     const pagination: Pagination<Tournament> = {
//       data: response.data as Tournament[],
//       currentPage: PageNumber ?? 1,
//       pageSize: PageSize ?? 10,
//       totalItems: response.totalItems ?? 0,
//       totalPages: response.totalPages ?? 0,
//     };
//     return pagination as Pagination<Tournament>;
//   } catch (error) {
//     throw new Error('Error fetching tournaments');
//   }
// };

// export function useGetAllTournaments(
//   PageNumber: number = 1,
//   PageSize: number = 10
// ) {
//   return useQuery<Pagination<Tournament>>({
//     queryKey: [GET_ALL_TOURNAMENTS, PageNumber, PageSize],
//     queryFn: () => fetchTournaments(PageNumber, PageSize),
//     refetchInterval: 3000,
//   });
// }

const fetchTournamentsByCreateAt = async (
  PageNumber?: number,
  PageSize?: number,
  isOrderbyCreateAt: boolean = true
): Promise<Pagination<Tournament>> => {
  try {
    const response = await api.getByQueryParams('/Tourament/GetAllTournament', {
      PageNumber,
      PageSize,
      isOrderbyCreateAt,
    });
    const pagination: Pagination<Tournament> = {
      data: response.data as Tournament[],
      currentPage: PageNumber ?? 1,
      pageSize: PageSize ?? 10,
      totalItems: response.totalItems ?? 0,
      totalPages: response.totalPages ?? 0,
    };
    return pagination as Pagination<Tournament>;
  } catch (error) {
    throw new Error('Error fetching tournaments');
  }
};

export function useGetAllTournamentsByCreateAt(
  PageNumber: number = 1,
  PageSize: number = 10,
  isOrderbyCreateAt: boolean = true
) {
  return useQuery<Pagination<Tournament>>({
    queryKey: [GET_ALL_TOURNAMENTS, PageNumber, PageSize, isOrderbyCreateAt],
    queryFn: () =>
      fetchTournamentsByCreateAt(PageNumber, PageSize, isOrderbyCreateAt),
    refetchInterval: 3000,
  });
}

const fetchTournamentsForPlayer = async (): Promise<Tournament[]> => {
  try {
    const response = await api.getByQueryParams('/Tourament/GetAllTournament');
    const tournaments = response.data as Tournament[];

    // Lọc bỏ các tournament có status là 'Pending'
    return tournaments
      .filter(
        (tournament) =>
          tournament.status !== 'Pending' && tournament.status !== 'Disable'
      )
      .sort(
        (a, b) =>
          new Date(a.startDate).getTime() - new Date(b.startDate).getTime()
      );
  } catch (error) {
    throw new Error('Error fetching tournaments');
  }
};
export function useGetAllTournamentsForPlayer() {
  return useQuery<Tournament[]>({
    queryKey: [GET_ALL_TOURNAMENTS],
    queryFn: () => fetchTournamentsForPlayer(),
  });
}

const fetchTournamentsForHomePage = async (): Promise<Tournament[]> => {
  try {
    const response = await api.getByQueryParams('/Tourament/GetAllTournament');
    const tournaments = response.data as Tournament[];

    // Lọc bỏ các tournament có status là 'Pending'
    return tournaments
      .filter((tournament) => tournament.status === 'Scheduled')
      .sort(
        (a, b) =>
          new Date(a.startDate).getTime() - new Date(b.startDate).getTime()
      );
  } catch (error) {
    throw new Error('Error fetching tournaments');
  }
};
export function useGetAllTournamentsForHomePage() {
  return useQuery<Tournament[]>({
    queryKey: [GET_ALL_TOURNAMENTS],
    queryFn: () => fetchTournamentsForHomePage(),
  });
}

const fetchAllTournament = async (): Promise<Tournament[]> => {
  try {
    const response = await api.get('/Tourament/GetAllTournament');
    return response.data as Tournament[];
  } catch (error) {
    throw new Error('Error fetching tournaments');
  }
};

export function useGetTournaments() {
  return useQuery<Tournament[]>({
    queryKey: [GET_ALL_TOURNAMENTS],
    queryFn: fetchAllTournament,
    refetchInterval: 3000,
  });
}

const fetchTournaments = async (): Promise<Tournament[]> => {
  try {
    const response = await api.get('/Tourament/GetAllTournament');
    return response.data as Tournament[];
  } catch (error) {
    throw new Error('Error fetching tournaments');
  }
};

export function useGetAllTournaments() {
  return useQuery<Tournament[]>({
    queryKey: [GET_ALL_TOURNAMENTS],
    queryFn: fetchTournaments,
    refetchInterval: 3000,
  });
}
