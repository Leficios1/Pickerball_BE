import React from 'react';
import { Layout, Row, Col, Input, Button, Typography, Space } from 'antd';
import {
  FacebookFilled,
  InstagramFilled,
  PhoneFilled,
  SendOutlined,
} from '@ant-design/icons';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';

const { Footer } = Layout;
const { Title, Text } = Typography;

const CustomFooter: React.FC = () => {
  return (
    <Footer
      style={{
        background: 'linear-gradient(to right, #1e3a8a, #3b82f6)',
        padding: '80px 50px',
        borderTopLeftRadius: 6,
        borderTopRightRadius: 6,
        color: 'white',
        marginTop: '100px',
      }}
    >
      <motion.div
        initial={{ opacity: 0, y: 60 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.7 }}
      >
        <Row gutter={[32, 32]} justify="space-between">
          {/* Contact */}
          <Col xs={24} sm={12} md={6}>
            <Title level={4} style={{ color: '#0ff' }}>
              Contact
            </Title>
            <Space direction="vertical">
              <Space>
                <PhoneFilled style={{ fontSize: 20, color: 'white' }} />
                <Text className="text-white">0912 312 312</Text>
              </Space>
              <Space>
                <SendOutlined style={{ fontSize: 20, color: 'white' }} />
                <Text className="text-white">scorepickle@gmail.com</Text>
              </Space>
            </Space>
          </Col>

          {/* About */}
          <Col xs={24} sm={12} md={6}>
            <Title level={4} style={{ color: '#0ff' }}>
              About ScorePickle
            </Title>
            <Row gutter={16}>
              <Col span={12}>
                <Space direction="vertical">
                  <Link to="/blog" className="text-white">Blog</Link>
                  <Link to="/news" className="text-white">News</Link>
                  <Link to="/rules" className="text-white">Rules</Link>
                </Space>
              </Col>
              <Col span={12}>
                <Space direction="vertical">
                  <Link to="/about" className="text-white">About Us</Link>
                  <Link to="/support" className="text-white">Support</Link>
                  <Link to="/rule-page" className="text-white">Platform Rules</Link>
                </Space>
              </Col>
            </Row>
          </Col>

          {/* Register Email */}
          <Col xs={24} sm={12} md={6}>
            <Title level={4} style={{ color: '#0ff' }}>
              Organize Tournament
            </Title>
            <Input
              placeholder="Your email"
              type="email"
              style={{ marginTop: 10, height: 45 }}
            />
            <Button
              type="primary"
              style={{
                backgroundColor: '#001529',
                height: 45,
                marginTop: 10,
                width: 120,
              }}
            >
              Register
            </Button>
          </Col>

          {/* Socials */}
          <Col xs={24} sm={12} md={6}>
            <Title level={4} style={{ color: '#0ff' }}>
              Follow Us
            </Title>
            <Space direction="vertical">
              <Space>
                <FacebookFilled style={{ fontSize: 24, color: 'white' }} />
                <a
                  href="https://facebook.com/pickleball"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-white"
                >
                  facebook.com/pickleball
                </a>
              </Space>
              <Space>
                <InstagramFilled style={{ fontSize: 24, color: 'white' }} />
                <a
                  href="https://instagram.com/pickleball"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-white"
                >
                  instagram.com/pickleball
                </a>
              </Space>
            </Space>
          </Col>
        </Row>

        <div
          style={{
            textAlign: 'center',
            color: 'rgba(255,255,255,0.4)',
            marginTop: 60,
            fontSize: 13,
          }}
        >
          &copy; {new Date().getFullYear()} ScorePickle. All rights reserved.
        </div>
      </motion.div>
    </Footer>
  );
};

export default CustomFooter;
