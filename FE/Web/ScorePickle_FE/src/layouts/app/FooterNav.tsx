import { Layout } from 'antd';

const { Footer } = Layout;

type FooterNavProps = React.HTMLAttributes<HTMLDivElement>;

const FooterNav = ({ ...others }: FooterNavProps) => {
  return <Footer {...others}>ScorePickle © 2025</Footer>;
};

export default FooterNav;
