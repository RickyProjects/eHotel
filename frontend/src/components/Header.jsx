import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import logo from '../assets/logo.png';
import account from '../assets/account.png';
import headerBg from '../assets/headerbg.png';

function Header() {
  const navigate = useNavigate();

  const [showPopup, setShowPopup] = useState(false);
  const [employeeId, setEmployeeId] = useState('');
  const [error, setError] = useState('');

  async function handleEmployeeAccess() {
    setError('');

    if (!employeeId) {
      setError('Please enter an employee ID.');
      return;
    }

    try {
      const res = await fetch(`http://127.0.0.1:8000/employees/${employeeId}`);
      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.detail || 'Employee ID not found.');
      }

      sessionStorage.setItem('employee_id', data.employee_id);
      sessionStorage.setItem('employee_name', data.full_name);

      setShowPopup(false);
      setEmployeeId('');
      navigate('/employee');
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <>
      <div style={styles.header}>
        <div style={styles.left}>
          <img src={logo} alt="logo" style={styles.logo} />
        </div>

        <div style={styles.middle}>
          <h1 style={styles.title}>Place d’Ôrnob</h1>
        </div>

        <div style={styles.right}>
          <h1
            style={styles.lang}
            onClick={() => setShowPopup(true)}
          >
            Employee Dashboard
          </h1>
          <img src={account} alt="account" style={styles.account} />
        </div>
      </div>

      {showPopup && (
        <div style={styles.overlay}>
          <div style={styles.popup}>
            <h2 style={styles.popupTitle}>Employee Access</h2>

            <label style={styles.label}>Employee ID</label>
            <input
              type="number"
              value={employeeId}
              onChange={(e) => setEmployeeId(e.target.value)}
              style={styles.input}
            />

            {error && <p style={styles.error}>{error}</p>}

            <div style={styles.popupButtons}>
              <button style={styles.primaryButton} onClick={handleEmployeeAccess}>
                Enter
              </button>
              <button
                style={styles.secondaryButton}
                onClick={() => {
                  setShowPopup(false);
                  setEmployeeId('');
                  setError('');
                }}
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

const styles = {
  header: {
    height: '12vh',
    backgroundImage: `url(${headerBg})`,
    backgroundSize: 'cover',
    backgroundPosition: 'center 73%',
    backgroundRepeat: 'no-repeat',
    color: '#fff',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: '0 24px',
    position: 'sticky',
    top: 0,
    zIndex: 10,
    boxShadow: '0 8px 12px rgba(0,0,0,0.4)',
  },
  left: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    zIndex: 1,
  },
  middle: {
    position: 'absolute',
    left: '50%',
    transform: 'translateX(-50%)',
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
    zIndex: 1,
  },
  lang: {
    cursor: 'pointer',
    fontSize: '1.5vw',
    margin: 0,
    textShadow: '0 2px 6px rgba(0,0,0,0.8)',
  },
  account: {
    fontSize: '20px',
    cursor: 'pointer',
    filter: 'drop-shadow(0 2px 4px rgba(0,0,0,0.7))',
  },
  overlay: {
    position: 'fixed',
    inset: 0,
    background: 'rgba(0,0,0,0.45)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 9999,
  },
  popup: {
    background: '#fff',
    width: '360px',
    maxWidth: '90vw',
    padding: '24px',
    borderRadius: '14px',
    boxShadow: '0 10px 30px rgba(0,0,0,0.2)',
    color: '#111',
  },
  popupTitle: {
    marginTop: 0,
    marginBottom: '16px',
  },
  label: {
    display: 'block',
    marginBottom: '6px',
    fontWeight: 'bold',
  },
  input: {
    width: '100%',
    padding: '10px',
    marginBottom: '12px',
  },
  error: {
    color: 'red',
    marginTop: 0,
  },
  popupButtons: {
    display: 'flex',
    gap: '10px',
    marginTop: '10px',
  },
  primaryButton: {
    padding: '10px 14px',
    border: 'none',
    borderRadius: '8px',
    background: '#111',
    color: '#fff',
    cursor: 'pointer',
  },
  secondaryButton: {
    padding: '10px 14px',
    border: '1px solid #999',
    borderRadius: '8px',
    background: '#fff',
    cursor: 'pointer',
  },
};

export default Header;