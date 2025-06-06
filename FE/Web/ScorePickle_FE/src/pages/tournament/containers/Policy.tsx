import React, { useState, useEffect } from 'react';
import { Form, Button, Row, Col, message, Modal } from 'antd';
import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css';
import { Tournament } from '@src/modules/Tournament/models';
import { useUpdateTournament } from '@src/modules/Tournament/hooks/useUpdateTournament';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { RoleFactory } from '@src/modules/User/models';
import { useGetTournamentById } from '@src/modules/Tournament/hooks/useGetTournamentById';

export interface PolicyProps {
  id: number;
  data: Tournament;
  refetch: () => void;
}

const Policy: React.FC<PolicyProps> = ({ data, id, refetch }) => {
  const [form] = Form.useForm();
  const { mutate: updateTournament } = useUpdateTournament();
  const [policyContent, setPolicyContent] = useState<string>(data.note || '');
  const [isPolicyExists, setIsPolicyExists] = useState<boolean>(!!data.note);
  const user = useSelector((state: RootState) => state.auth.user);
  const { data: tournament } = useGetTournamentById(id);

  useEffect(() => {
    if (data) {
      form.setFieldsValue({
        note: data.note || '',
      });
      setPolicyContent(data.note || '');
    }
  }, [data, form]);

  const handleFinish = () => {
    const updatedValues = {
      note: policyContent,
    };

    updateTournament(
      { id, data: updatedValues },
      {
        onSuccess: () => {
          message.success('Policy updated successfully');
          refetch();
        },
        onError: () => {
          message.error('Failed to update policy');
        },
      }
    );
  };

  return (
    <div>
      {!isPolicyExists && (
        <Modal
          title="No Policy Found"
          visible={!isPolicyExists}
          onOk={() => setIsPolicyExists(true)}
          onCancel={() => setIsPolicyExists(true)}
        >
          <p>
            No policy found for this tournament. Please create a new policy.
          </p>
        </Modal>
      )}
      <Form
        form={form}
        layout="vertical"
        initialValues={{
          note: '',
        }}
        onFinish={handleFinish}
      >
        <Row gutter={16}>
          <Col span={24}>
            <Form.Item
              name="note"
              label="Note"
              rules={[{ required: true, message: 'Please input the terms!' }]}
            >
              <ReactQuill value={policyContent} onChange={setPolicyContent} />
            </Form.Item>
          </Col>
        </Row>
        {user?.roleId === RoleFactory.Sponsor &&
          tournament?.status.toLowerCase() === 'pending' && (
            <Form.Item>
              <Button
                type="primary"
                htmlType="submit"
                style={{ width: '100%' }}
              >
                Save
              </Button>
            </Form.Item>
          )}
      </Form>
    </div>
  );
};

export default Policy;
