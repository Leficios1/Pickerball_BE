import React, { useEffect, useState } from 'react';
import { Form, Select, Button, message, Row, Col } from 'antd';
import axios from 'axios';
import { useCreatePlayer } from '@src/modules/User/hooks/useRegisterUser';
import { RootState } from '@src/redux/store';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';

const { Option } = Select;

const PlayerForm: React.FC = () => {
  const [form] = Form.useForm();
  const [provinces, setProvinces] = useState<any[]>([]);
  const [districts, setDistricts] = useState<any[]>([]);
  const [loadingDistricts, setLoadingDistricts] = useState<boolean>(false);
  const { mutate } = useCreatePlayer();
  const playerId = useSelector((state: RootState) => state.user.userId);
  const navigate = useNavigate();
  const user = useSelector((state: RootState) => state.auth.user);
  const [userId, setUserId] = useState(0);

  useEffect(() => {
    setUserId(user?.id ?? 0);
    if (!user?.id && !playerId) {
      navigate('/auth/signin');
    }
  }, [user?.id]);

  useEffect(() => {
    axios
      .get('https://vn-public-apis.fpo.vn/provinces/getAll?limit=-1')
      .then((response) => {
        const provinceItems = response.data?.data?.data || [];
        setProvinces(provinceItems);
      })
      .catch(() => {
        message.error('Cannot loading province');
      });
  }, []);

  const handleProvinceChange = (provinceCode: string) => {
    form.setFieldsValue({ city: undefined });
    setDistricts([]);
    setLoadingDistricts(true);

    axios
      .get(
        `https://vn-public-apis.fpo.vn/districts/getByProvince?provinceCode=${provinceCode}&limit=-1`
      )
      .then((response) => {
        setDistricts(response.data.data.data || []);
        setLoadingDistricts(false);
      })
      .catch(() => {
        message.error('Cannot loading city');
        setLoadingDistricts(false);
      });
  };

  const onFinish = (values: any) => {
    mutate({
      ...values,
      playerId: playerId ?? userId,
    });
  };

  return (
    <div className="container py-5">
      <Row justify="center">
        <Col xs={24} md={20} lg={16}>
          <h3 className="text-center mb-4">Register as a Player</h3>
          <Form
            form={form}
            layout="vertical"
            onFinish={onFinish}
            style={{ maxWidth: 600, margin: '0 auto', padding: '2rem' }}
          >
            <Form.Item
              label="Province"
              name="province"
              rules={[{ required: true, message: 'Please select a province' }]}
            >
              <Select
                placeholder="Select a province"
                onChange={(code) => {
                  const selectedProvince = provinces.find(
                    (p) => p.code === code
                  );
                  form.setFieldsValue({
                    province: selectedProvince?.name,
                    city: undefined,
                  });
                  handleProvinceChange(code); // Gọi API bằng code
                }}
                showSearch
                optionFilterProp="children"
              >
                {provinces.map((province) => (
                  <Option key={province.code} value={province.code}>
                    {province.name}
                  </Option>
                ))}
              </Select>
            </Form.Item>

            <Form.Item
              label="District"
              name="city"
              rules={[{ required: true, message: 'Please select a district' }]}
            >
              <Select
                placeholder="Select a district"
                loading={loadingDistricts}
                disabled={!districts.length}
                showSearch
                optionFilterProp="children"
              >
                {districts.map((district) => (
                  <Option key={district.name} value={district.name}>
                    {district.name}
                  </Option>
                ))}
              </Select>
            </Form.Item>

            <Form.Item>
              <Button type="primary" htmlType="submit" block>
                Register
              </Button>
            </Form.Item>
          </Form>
        </Col>
      </Row>
    </div>
  );
};

export default PlayerForm;
