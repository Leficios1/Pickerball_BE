import { useQuery } from '@tanstack/react-query';
import { User } from '../models';
import Api from '../../../api/api';
import { FETCH_REFEREES, GET_REFEREE_BY_CODE } from '../constants';
import { RefereeResponse } from '@src/modules/Referee/models';

// export const fetchAllReferees = async (): Promise<User[]> => {
//   const response = await Api.get('/User/GetAllRefee');
//   return response.data as User[];
// };

// export function useGetAllReferees() {
//   return useQuery<User[]>({
//     queryKey: [FETCH_ALL_REFEREES],
//     queryFn: fetchAllReferees,
//   });
// }

export const fetchReferees = async (): Promise<User[]> => {
  const response = await Api.get('/User/getAllRefeeForMobile');
  return response.data as User[];
};

export function useGetReferees() {
  return useQuery<User[]>({
    queryKey: [FETCH_REFEREES],
    queryFn: fetchReferees,
  });
}

const fetchRefereeByCode = async (code: string): Promise<RefereeResponse[]> => {
  try {
    const response = await Api.get<RefereeResponse[]>(`/Refree/code/${code}`);
    // @ts-ignore
    return response;
  } catch (error) {
    throw new Error('Error fetching referee data');
  }
};

export function useGetRefereeBySponsorId(code: string) {
  return useQuery<RefereeResponse[]>({
    queryKey: [GET_REFEREE_BY_CODE, code],
    queryFn: () => fetchRefereeByCode(code),
    refetchInterval: 3000,
  });
}

export const fetchAllReferees = async (): Promise<RefereeResponse[]> => {
  const response = await Api.get('/User/GetAllRefee');
  return response.data as RefereeResponse[];
};

export function useGetAllReferees() {
  return useQuery<RefereeResponse[]>({
    queryKey: [FETCH_REFEREES],
    queryFn: fetchAllReferees,
    refetchInterval: 3000,
  });
}
