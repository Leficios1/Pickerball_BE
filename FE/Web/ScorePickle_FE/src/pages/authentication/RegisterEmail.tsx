import {
  Button,
  Col,
  Flex,
  Form,
  Input,
  Row,
  Spin,
  theme,
  Typography,
} from 'antd';
import { useMediaQuery } from 'react-responsive';
import { useState } from 'react';
import { useSendOtp } from '@src/modules/Auth/hooks/useSendOtp';
import { useNavigate } from 'react-router-dom';
import { PATH_AUTH } from '@src/constants';
import { Link } from 'react-router-dom';

const { Title, Text } = Typography;

type FieldType = {
  email?: string;
};

export const RegisterEmail = () => {
  const {
    token: { colorPrimary },
  } = theme.useToken();
  const navigate = useNavigate();
  const isMobile = useMediaQuery({ maxWidth: 769 });
  const [loading, setLoading] = useState(false);
  const { mutate: sendOtp } = useSendOtp();

  if (loading) {
    return (
      <Spin className="d-flex justify-content-between align-items-center"></Spin>
    );
  }

  const onFinish = async (values: any) => {
    try {
      setLoading(true);
      await sendOtp(values.email); // đợi mutate hoàn tất
    } catch (error) {
      console.error('Error sending OTP:', error);
    } finally {
      setLoading(false);
    }
  };

  const onFinishFailed = (errorInfo: any) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <>
      <Row
        style={{ minHeight: isMobile ? 'auto' : '100vh', overflow: 'hidden' }}
      >
        <Col xs={24} lg={12}>
          <Flex
            vertical
            align="center"
            justify="center"
            className="text-center"
            style={{
              background: colorPrimary,
              height: '100%',
              padding: '1rem',
            }}
          >
            <div></div>
          </Flex>
        </Col>
        <Col xs={24} lg={12}>
          <Flex
            vertical
            align={isMobile ? 'center' : 'flex-start'}
            justify="center"
            gap="middle"
            style={{ height: '100%', width: '100%', padding: '2rem' }}
          >
            <Title className="m-0">Register account</Title>
            <Text>Enter your email to resgister account.</Text>
            <Form
              name="sign-up-form"
              layout="vertical"
              labelCol={{ span: 24 }}
              wrapperCol={{ span: 24 }}
              initialValues={{ remember: true }}
              onFinish={onFinish}
              onFinishFailed={onFinishFailed}
              autoComplete="off"
              requiredMark={false}
              style={{ width: '100%' }}
            >
              <Form.Item<FieldType>
                label="Email"
                name="email"
                rules={[{ required: true, message: 'Please input your email' }]}
              >
                <Input />
              </Form.Item>
              <Form.Item>
                <Flex align="center" gap="small">
                  <Button
                    type="primary"
                    htmlType="submit"
                    size="middle"
                    loading={loading}
                  >
                    Submit
                  </Button>
                  <Button
                    type="text"
                    size="middle"
                    loading={loading}
                    onClick={() => navigate('/auth/signin')}
                  >
                    Cancel
                  </Button>
                </Flex>
              </Form.Item>
            </Form>

            <Flex gap={4}>
              <Text>Already have an account?</Text>
              <Link to={PATH_AUTH.signin}>Sign in here</Link>
            </Flex>
          </Flex>
        </Col>
      </Row>
    </>
  );
};
