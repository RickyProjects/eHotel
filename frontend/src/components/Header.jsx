import logo from '../assets/logo.png';
import account from '../assets/account.png';
import headerBg from '../assets/headerbg.png';

function Header() {
  return (
    <div style={styles.header}>
        
      <div style={styles.left}>
        <img src={logo} alt="logo" style={styles.logo} />
      </div>

      <div style={styles.middle}>
        <h1 style={styles.title}>Place d’Ôrnob</h1>
      </div>    
      <div style={styles.right}>
        <h1 style={styles.lang}>Employee Dashboard</h1>
        <img src={account} alt="account" style={styles.account} />
      </div>
    </div>
  );
}

const styles = {
  header: {
    height: '12vh',
    position: 'relative',
    backgroundImage: `url(${headerBg})`,
    backgroundSize: 'cover',
    backgroundPosition: 'center 73%',
    backgroundRepeat: 'no-repeat',
    color: '#fff',
    color: '#fff',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: '0 24px',
    position: 'sticky',
    top: 0,
    zIndex: 10,
    background_image: '',
    boxShadow: '0 8px 12px rgba(0,0,0,0.4)',
  },
  left: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
  },
  logo: {
    width: '4.8vw',
    height: '4.8vh',
    objectFit: 'contain',
    filter: 'drop-shadow(0 2px 4px rgba(0,0,0,0.7))',
  },
  title: {
    fontSize: '3vw',
    margin: 0,
    textShadow: '0 2px 6px rgba(0,0,0,0.8)',
  },
  right: {
    display: 'flex',
    alignItems: 'center',
    gap: '16px',
  },
  lang: {
    cursor: 'pointer',
    fontSize: '1vw',
  },
  account: {
    fontSize: '20px',
    cursor: 'pointer',
    filter: 'drop-shadow(0 2px 4px rgba(0,0,0,0.7))',
  },
  middle: {
    position: 'absolute',
    left: '50%',
    transform: 'translateX(-50%)',
  },
};

export default Header;