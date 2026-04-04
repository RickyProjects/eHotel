import { useState } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import Header from '../components/Header';

function BookingPage() {
  const { hotelId, roomNumber } = useParams();
  const navigate = useNavigate();
  const location = useLocation();

  const room = location.state?.room;

  const [form, setForm] = useState({
    customer_id: '',
    start_date: '',
    end_date: '',
  });

  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  function handleChange(e) {
    const { name, value } = e.target;
    setForm((prev) => ({
      ...prev,
      [name]: value,
    }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setMessage('');
    setError('');

    try {
      const res = await fetch('http://127.0.0.1:8000/bookings', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          customer_id: Number(form.customer_id),
          hotel_id: Number(hotelId),
          room_number: Number(roomNumber),
          start_date: form.start_date,
          end_date: form.end_date,
        }),
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.detail || 'Booking failed.');
      }

      if (data.message && data.message.toLowerCase().includes('error')) {
        setError(data.message);
        return;
      }

      setMessage(data.message || 'Booking created successfully.');
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <>
      <Header />

      <div style={styles.page}>
        <div style={styles.card}>
          <h1>Book Room</h1>

          <p><strong>Hotel ID:</strong> {hotelId}</p>
          <p><strong>Room Number:</strong> {roomNumber}</p>

          {room && (
            <>
              <p><strong>Price:</strong> ${room.price}/night</p>
              <p><strong>Capacity:</strong> {room.room_capacity}</p>
              <p><strong>View:</strong> {room.view}</p>
            </>
          )}

          <form onSubmit={handleSubmit} style={styles.form}>
            <label>Customer ID</label>
            <input
              type="number"
              name="customer_id"
              value={form.customer_id}
              onChange={handleChange}
              required
            />

            <label>Start Date</label>
            <input
              type="date"
              name="start_date"
              value={form.start_date}
              onChange={handleChange}
              required
            />

            <label>End Date</label>
            <input
              type="date"
              name="end_date"
              value={form.end_date}
              onChange={handleChange}
              required
            />

            {message && <p style={{ color: 'green' }}>{message}</p>}
            {error && <p style={{ color: 'red' }}>{error}</p>}

            <div style={styles.buttons}>
              {!message && (
                <button type="submit" style={styles.primaryButton}>
                    Confirm Booking
                </button>
                )}

              <button
                type="button"
                style={styles.secondaryButton}
                onClick={() => navigate('/')}
              >
                Back
              </button>
            </div>
          </form>
        </div>
      </div>
    </>
  );
}

const styles = {
  page: {
    minHeight: 'calc(100vh - 80px)',
    background: '#eae6dc',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    padding: '30px',
  },
  card: {
    width: '500px',
    maxWidth: '90vw',
    background: '#fff',
    padding: '24px',
    borderRadius: '18px',
    boxShadow: '0 4px 16px rgba(0,0,0,0.1)',
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
    marginTop: '16px',
  },
  buttons: {
    display: 'flex',
    gap: '12px',
    marginTop: '14px',
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

export default BookingPage;