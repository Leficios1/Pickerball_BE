import { useMutation } from '@tanstack/react-query';
import { SEND_OTP } from '../constants';
import { SendOtpResponse } from '../models';
import Api from '@src/api/api';
import { useDispatch } from 'react-redux';
import { setEmail, setOtp } from '@src/redux/user/userSlice';
import { message } from 'antd';
import { useNavigate } from 'react-router-dom';

const sendOtp = async (email: string): Promise<SendOtpResponse> => {
  const response = await Api.get<SendOtpResponse>(`/Auth/VerifyEmail/${email}`);
  const result = response.data;

  if (!result) {
    throw new Error('Not found your email address');
  }

  return result;
};

export function useSendOtp() {
  const navigate = useNavigate();
  const dispatch = useDispatch();

  return useMutation<SendOtpResponse, Error, string>({
    mutationKey: [SEND_OTP],
    mutationFn: sendOtp,
    onSuccess: (data) => {
      dispatch(setEmail(data.email));
      dispatch(setOtp(data.otp));
      console.log(data.otp);
      message.success('Send OTP to your email successfully');
      // navigate('/auth/verify-otp');
    },
    onError: () => {
      message.error('Not found your email address');
    },
  });
}
