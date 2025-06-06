import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';

import { GET_ALL_RULES } from '../constants';
import { Rule, RulesResponse } from '../models';

const fetchRules = async (
  currentPage?: number,
  pageSize?: number
): Promise<RulesResponse> => {
  try {
    const response = await api.getByQueryParams('/rules', {
      currentPage,
      pageSize,
    });

    const data = response.data as RulesResponse;

    const PaginationResponse: RulesResponse = {
      totalCount: data.totalCount ?? 0,
      pageSize: data.pageSize,
      currentPage: data.currentPage,
      totalPages: data.totalPages,
      results: data.results,
    };
    return PaginationResponse;
  } catch (error) {
    throw new Error('Error fetching rules');
  }
};

export function useGetAllRules(PageNumber: number = 1, PageSize: number = 10) {
  return useQuery<RulesResponse>({
    queryKey: [GET_ALL_RULES, PageNumber, PageSize],
    queryFn: () => fetchRules(PageNumber, PageSize),
    refetchInterval: 3000,
  });
}

const fetchAllRules = async (): Promise<Rule[]> => {
  try {
    const response = await api.get('/rules');

    const data = response.data as RulesResponse;

    const PaginationResponse: RulesResponse = {
      totalCount: data.totalCount ?? 0,
      pageSize: data.pageSize,
      currentPage: data.currentPage,
      totalPages: data.totalPages,
      results: data.results,
    };
    return PaginationResponse.results;
  } catch (error) {
    throw new Error('Error fetching rules');
  }
};

export function useGetAllRulesWithoutPagination() {
  return useQuery<Rule[]>({
    queryKey: [GET_ALL_RULES],
    queryFn: () => fetchAllRules(),
    refetchInterval: 3000,
  });
}
