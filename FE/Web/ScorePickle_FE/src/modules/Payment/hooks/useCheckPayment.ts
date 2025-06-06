import { useQuery } from '@tanstack/react-query';
import Api from '@src/api/api';
import { CHECK_PAYMENT } from '../constants';
import { PaymentResponse } from '../models';

export const checkPayment = async ({
  userId,
  urlResponse,
}: {
  userId: number;
  urlResponse: string;
}): Promise<PaymentResponse> => {
  // Gửi yêu cầu POST mà không cần bao bọc trong `body`
  const apiResponse = await Api.post<PaymentResponse>(
    `/payment/vn-pay/check-payment`,
    { userId, urlResponse }
  );
  console.log('checkPayment', apiResponse);
  return apiResponse.data as PaymentResponse;
};

export function useCheckPayment(userId: number, urlResponse: string) {
  return useQuery<PaymentResponse, Error>({
    queryKey: [CHECK_PAYMENT, userId, urlResponse], // Bao gồm cả userId và response trong queryKey
    queryFn: () => checkPayment({ userId, urlResponse }),
    // Tùy chọn thêm như cache, refetching, etc. có thể được đặt ở đây
  });
}
