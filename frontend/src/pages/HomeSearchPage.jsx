import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import Header from '../components/Header';
import Sidebar from '../components/Sidebar';

function HomeSearchPage() {
  const [filters, setFilters] = useState({
    min_price: '',
    max_price: '',
    capacity: '',
    view: '',
    start_date: '',
    end_date: '',
  });

  const [rooms, setRooms] = useState([]);

  useEffect(() => {
    handleSearch();
  }, []);

  const navigate = useNavigate();

  function handleChange(e) {
    const { name, value } = e.target;
    setFilters((prev) => ({
      ...prev,
      [name]: value,
    }));
  }

  async function handleSearch() {
    const params = new URLSearchParams();

    Object.entries(filters).forEach(([k, v]) => {
      if (v !== '') params.append(k, v);
    });

    const res = await fetch(`http://127.0.0.1:8000/rooms/filter?${params}`);
    const data = await res.json();
    setRooms(Array.isArray(data) ? data : []);
  }

  return (
    <>
      <Header />

      <div style={styles.container}>
        <Sidebar
          filters={filters}
          onChange={handleChange}
          onSearch={handleSearch}
        />

        <div style={styles.main}>
         <h2>The best options for you:</h2>

          <div style={styles.grid}>
            {rooms.map((room) => (
              <div key={`${room.hotel_id}-${room.room_number}`} style={styles.card}>
                <img
                  src={`https://picsum.photos/600/500?random=${room.hotel_id}${room.room_number}`}
                  alt="room"
                  style={styles.image}
                />

                <div style={styles.info}>
                  <h3 style={{ margin: 0 }}>Hotel {room.hotel_id}</h3>
                  <p>Room {room.room_number}</p>
                  <p>${room.price}/night</p>

                  <button
                    style={styles.bookButton}
                    onClick={() =>
                      navigate(`/book/${room.hotel_id}/${room.room_number}`, {
                        state: { room },
                      })
                    }
                  >
                    Book
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </>
  );
}

const styles = {
  container: {
    display: 'flex',
  },
  main: {
    fontSize: '1vw',
    flex: 1,
    padding: '24px',
    background: '#eae6dc',
    minHeight: 'calc(100vh - 80px)',
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(2, 1fr)', // 2 columns like your mock
    gap: '20px',
  },
  card: {
    background: '#fff',
    borderRadius: '20px',
    overflow: 'hidden',
    border: '1px solid #ccc',
  },
  image: {
    width: '100%',
    height: '40vh',
    objectFit: 'cover',
    display: 'block',
  },
  info: {
    padding: '12px',
  },
  bookButton: {
    marginTop: '10px',
    padding: '8px 14px',
    cursor: 'pointer',
    border: 'none',
    borderRadius: '8px',
    background: '#111',
    color: '#fff',
  },
};

export default HomeSearchPage;