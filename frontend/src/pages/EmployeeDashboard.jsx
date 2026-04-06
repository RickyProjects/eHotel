import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Header from '../components/Header';

function EmployeeDashboard() {
  const navigate = useNavigate();

  const [bookings, setBookings] = useState([]);
  const [rentings, setRentings] = useState([]);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const [showToast, setShowToast] = useState(false);
  const [loading, setLoading] = useState(true);

  const employeeId = sessionStorage.getItem('employee_id');
  const employeeName = sessionStorage.getItem('employee_name');

  async function loadData() {
    try {
      setError('');
      setLoading(true);

      const bookingsRes = await fetch('http://127.0.0.1:8000/bookings');
      const bookingsData = await bookingsRes.json();

      const rentingsRes = await fetch('http://127.0.0.1:8000/rentings');
      const rentingsData = await rentingsRes.json();

      setBookings(Array.isArray(bookingsData) ? bookingsData : []);
      setRentings(Array.isArray(rentingsData) ? rentingsData : []);
    } catch (err) {
      setError('Failed to load dashboard data.');
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    if (!employeeId) {
      navigate('/');
      return;
    }

    loadData();
  }, [employeeId, navigate]);

  useEffect(() => {
    if (message || error) {
      setShowToast(true);

      const fadeTimer = setTimeout(() => {
        setShowToast(false);
      }, 3500);

      const removeTimer = setTimeout(() => {
        setMessage('');
        setError('');
      }, 4100);

      return () => {
        clearTimeout(fadeTimer);
        clearTimeout(removeTimer);
      };
    }
  }, [message, error]);

  async function handleCheckIn(bookingId) {
    try {
      setMessage('');
      setError('');

      const res = await fetch(`http://127.0.0.1:8000/rentings?booking_id=${bookingId}`, {
        method: 'POST',
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.detail || 'Check-in failed.');
      }

      if (
        data.message &&
        (
          data.message.toLowerCase().includes('cannot') ||
          data.message.toLowerCase().includes('does not exist') ||
          data.message.toLowerCase().includes('cancelled') ||
          data.message.toLowerCase().includes('already') ||
          data.message.toLowerCase().includes('error')
        )
      ) {
        setError(data.message);
        return;
      }

      setMessage(data.message || 'Check-in successful.');
      await loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  function handleLogout() {
    sessionStorage.removeItem('employee_id');
    sessionStorage.removeItem('employee_name');
    navigate('/');
  }

  return (
    <>
      <Header />

      <div style={styles.page}>
        <div style={styles.topRow}>
          <div>
            <h1 style={styles.heading}>Employee Dashboard</h1>
            <p style={styles.subtext}>
              Logged in as: {employeeName || 'Unknown Employee'} (ID: {employeeId || 'N/A'})
            </p>
          </div>

          <button style={styles.logoutButton} onClick={handleLogout}>
            Log Out
          </button>
        </div>

        {loading ? (
          <div style={styles.section}>
            <p>Loading dashboard...</p>
          </div>
        ) : (
          <>
            <div style={styles.section}>
              <h2>All Bookings</h2>
              <div style={styles.tableWrapper}>
                <table style={styles.table}>
                  <thead>
                    <tr>
                      {[
                        'Booking ID',
                        'Customer ID',
                        'Hotel ID',
                        'Room',
                        'Start',
                        'End',
                        'Status',
                        'Action',
                      ].map((header, i) => (
                        <th
                          key={header}
                          style={{
                            ...styles.cell,
                            ...styles.headerCell,
                            background: i % 2 === 0 ? '#ffffff' : '#f3f3f3',
                          }}
                        >
                          {header}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {bookings.map((booking) => (
                      <tr key={booking.booking_id}>
                        {[
                          booking.booking_id,
                          booking.customer_id,
                          booking.hotel_id,
                          booking.room_number,
                          booking.start_date,
                          booking.end_date,
                          booking.status,
                        ].map((value, i) => (
                          <td
                            key={i}
                            style={{
                              ...styles.cell,
                              background: i % 2 === 0 ? '#ffffff' : '#f3f3f3',
                            }}
                          >
                            {value}
                          </td>
                        ))}

                        <td
                          style={{
                            ...styles.cell,
                            background: '#f3f3f3',
                          }}
                        >
                          {booking.status === 'pending' ? (
                            <button
                              style={styles.button}
                              onClick={() => handleCheckIn(booking.booking_id)}
                            >
                              Check In
                            </button>
                          ) : (
                            '-'
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            <div style={styles.section}>
              <h2>All Rentings</h2>
              <div style={styles.tableWrapper}>
                <table style={styles.table}>
                  <thead>
                    <tr>
                      {[
                        'Renting ID',
                        'Customer ID',
                        'Hotel ID',
                        'Room',
                        'Start',
                        'End',
                        'Check-in Date',
                        'Status',
                      ].map((header, i) => (
                        <th
                          key={header}
                          style={{
                            ...styles.cell,
                            ...styles.headerCell,
                            background: i % 2 === 0 ? '#ffffff' : '#f3f3f3',
                          }}
                        >
                          {header}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {rentings.map((renting) => (
                      <tr key={renting.renting_id}>
                        {[
                          renting.renting_id,
                          renting.customer_id,
                          renting.hotel_id,
                          renting.room_number,
                          renting.start_date,
                          renting.end_date,
                          renting.checkin_date,
                          renting.status,
                        ].map((value, i) => (
                          <td
                            key={i}
                            style={{
                              ...styles.cell,
                              background: i % 2 === 0 ? '#ffffff' : '#f3f3f3',
                            }}
                          >
                            {value}
                          </td>
                        ))}
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </>
        )}
      </div>

      {(message || error) && (
        <div
          style={{
            ...styles.toast,
            background: error ? '#d9534f' : '#28a745',
            opacity: showToast ? 1 : 0,
          }}
        >
          {error || message}
        </div>
      )}
    </>
  );
}

const styles = {
  page: {
    minHeight: 'calc(100vh - 12vh)',
    background: '#eae6dc',
    padding: '24px',
  },
  topRow: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '20px',
  },
  heading: {
    marginTop: 0,
    marginBottom: '6px',
  },
  subtext: {
    margin: 0,
  },
  logoutButton: {
    padding: '10px 14px',
    border: 'none',
    borderRadius: '8px',
    background: '#a72c2c',
    color: '#fff',
    cursor: 'pointer',
  },
  section: {
    background: '#fff',
    padding: '20px',
    borderRadius: '14px',
    marginBottom: '24px',
    boxShadow: '0 4px 12px rgba(0,0,0,0.08)',
  },
  tableWrapper: {
    overflowX: 'auto',
  },
  table: {
    width: '100%',
    borderCollapse: 'collapse',
    textAlign: 'left',
  },
  cell: {
    padding: '10px 12px',
    borderBottom: '1px solid #ddd',
    textAlign: 'left',
    verticalAlign: 'middle',
  },
  headerCell: {
    fontWeight: 'bold',
  },
  button: {
    padding: '6px 12px',
    border: 'none',
    borderRadius: '8px',
    background: '#1027ad',
    color: '#fff',
    cursor: 'pointer',
  },
  toast: {
    position: 'fixed',
    bottom: '20px',
    left: '50%',
    transform: 'translateX(-50%)',
    padding: '12px 20px',
    color: '#fff',
    borderRadius: '10px',
    boxShadow: '0 4px 12px rgba(0,0,0,0.2)',
    zIndex: 9999,
    fontWeight: 'bold',
    transition: 'opacity 0.5s ease-out',
  },
};

export default EmployeeDashboard;