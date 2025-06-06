import { FormOutlined, HomeOutlined } from '@ant-design/icons';
import { Link, Outlet, useLocation } from 'react-router-dom';
import { PageHeader } from '../../components/index.ts';
import { CONTENT_ITEMS } from '../../constants/index.ts';
import { AppLayout } from '../index.ts';

// todo: review
export const ContentLayout = () => {
  const { pathname } = useLocation();
  return (
    <>
      <AppLayout>
        <PageHeader
          title="Content"
          breadcrumbs={[
            {
              title: (
                <>
                  <HomeOutlined />
                  <span>home</span>
                </>
              ),
              path: '/',
            },
            {
              title: (
                <>
                  <FormOutlined />
                  <span>Content</span>
                </>
              ),
              menu: {
                items: CONTENT_ITEMS.map((d) => ({
                  key: d.title,
                  title: <Link to={d.path}>{d.title}</Link>,
                })),
              },
            },
            {
              title: pathname.split('/')[pathname.split('/').length - 1] || '',
            },
          ]}
        />
        <Outlet />
      </AppLayout>
    </>
  );
};
