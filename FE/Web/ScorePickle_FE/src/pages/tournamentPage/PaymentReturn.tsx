import type React from 'react';
import {
  CheckCircleFilled,
  CloseCircleFilled,
  InfoCircleFilled,
} from '@ant-design/icons';
import { Card, Button } from 'antd';
import 'bootstrap/dist/css/bootstrap.min.css';
import { useCheckPayment } from '@src/modules/Payment/hooks/useCheckPayment';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { useEffect } from 'react';

// interface PaymentReturnProps {
//   vnp_Amount: string;
//   vnp_BankCode: string;
//   vnp_BankTranNo: string;
//   vnp_CardType: string;
//   vnp_OrderInfo: string;
//   vnp_PayDate: string;
//   vnp_ResponseCode: string;
//   vnp_TmnCode: string;
//   vnp_TransactionNo: string;
//   vnp_TransactionStatus: string;
//   vnp_TxnRef: string;
//   vnp_SecureHash: string;
// }
// interface PaymentReturnProps {
//     response: string;
// }

const PaymentReturn: React.FC = () =>
  //{
  //   response,
  //   vnp_Amount,
  //   vnp_BankCode,
  //   vnp_BankTranNo,
  //   vnp_CardType,
  //   vnp_OrderInfo,
  //   vnp_PayDate,
  //   vnp_ResponseCode,
  //   vnp_TmnCode,
  //   vnp_TransactionNo,
  //   vnp_TransactionStatus,
  //   vnp_TxnRef,
  //   vnp_SecureHash,
  //}
  {
    const currentUrl = window.location.href;
    const urlObj = new URL(currentUrl);

    // Sử dụng URLSearchParams để truy xuất các tham số từ query string
    const params = new URLSearchParams(urlObj.search);

    // Lấy giá trị của các tham số cần thiết
    const vnp_Amount = Number(params.get('vnp_Amount'));
    const vnp_CardType = params.get('vnp_CardType');
    const vnp_ResponseCode = params.get('vnp_ResponseCode');

    const user = useSelector((state: RootState) => state.auth.user);
    const { data: checkPayment } = useCheckPayment(user?.id || 0, currentUrl);

    useEffect(() => {
      if (checkPayment) {
        console.log('Check Payment Data:', checkPayment);
      } else {
        console.log('No payment data available.');
      }
    }, [checkPayment]);

    function getErrorMessage(responseCode) {
      switch (responseCode) {
        case '09':
          return "The customer's card/account is not registered for Internet Banking service at the bank.";
        case '10':
          return 'The customer has failed to authenticate the card/account information more than 3 times.';
        case '11':
          return 'The payment waiting period has expired. Please perform the transaction again.';
        case '12':
          return "The customer's card/account is locked.";
        case '13':
          return 'You have entered the transaction authentication password (OTP) incorrectly. Please perform the transaction again.';
        case '24':
          return 'The customer canceled the transaction.';
        case '51':
          return 'Your account does not have sufficient balance to perform the transaction.';
        case '52':
          return 'Your account has exceeded the daily transaction limit.';
        case '75':
          return 'The payment bank is under maintenance.';
        case '79':
          return 'The customer has entered the payment password incorrectly more times than allowed. Please perform the transaction again.';
        default:
          return 'Unknown error code.';
      }
    }
    return (
      <div
        className="container d-flex justify-content-center align-items-center"
        style={{ minHeight: '100vh' }}
      >
        <Card
          className="text-center"
          style={{ maxWidth: '500px', width: '100%' }}
        >
          <div className="py-4">
            <h4 className="mt-3" style={{ fontWeight: 'bold' }}>
              {(() => {
                switch (vnp_ResponseCode) {
                  case '00':
                    return (
                      <>
                        <CheckCircleFilled
                          style={{ fontSize: '48px', color: '#52c41a' }}
                        />
                        <br />
                        Payment successful!
                      </>
                    );
                  case '07':
                    return (
                      <>
                        <InfoCircleFilled
                          style={{ fontSize: '48px', color: 'yellow' }}
                        />
                        <br />
                        Deduction successful. Transaction is suspicious.
                      </>
                    );
                  default:
                    return (
                      <>
                        <CloseCircleFilled
                          style={{ fontSize: '48px', color: 'red' }}
                        />
                        <br />
                        Payment failed!
                      </>
                    );
                }
              })()}
            </h4>

            {vnp_ResponseCode !== '00' && (
              <h4 className="mb-5" style={{ fontSize: '16px' }}>
                <span className="fw-normal">
                  {getErrorMessage(vnp_ResponseCode)}
                </span>
              </h4>
            )}
            <div className="text-center mb-4 mt-5">
              <div className="mb-2">
                <span className="fw-semibold">Amount:</span>{' '}
                {(vnp_Amount / 100).toLocaleString('vi-VN')}
              </div>
              <div className="mb-2">
                <span className="fw-semibold">Payment Card Type:</span>{' '}
                {vnp_CardType}
              </div>
            </div>

            {vnp_ResponseCode !== '00' ? (
              <Button
                type="primary"
                size="large"
                className="w-100"
                style={{ backgroundColor: '#0d6efd', borderColor: '#0d6efd' }}
                onClick={() => {
                  window.location.href = '/my-tournament';
                }}
              >
                Back to registered tournament
              </Button>
            ) : (
              <Button
                type="primary"
                size="large"
                className="w-100"
                style={{ backgroundColor: '#0d6efd', borderColor: '#0d6efd' }}
                onClick={() => {
                  window.location.href = '/tournament-page';
                }}
              >
                Back to tournament page
              </Button>
            )}
          </div>
        </Card>
      </div>
    );
  };

export default PaymentReturn;
