import { Routes, Route } from 'react-router-dom';
import HomeSearchPage from './pages/HomeSearchPage';
import BookingPage from './pages/BookingPage';
import EmployeeDashboard from './pages/EmployeeDashboard';

function App() {
  return (
    <Routes>
      <Route path="/" element={<HomeSearchPage />} />
      <Route path="/book/:hotelId/:roomNumber" element={<BookingPage />} />
      <Route path="/employee" element={<EmployeeDashboard />} />
    </Routes>
  );
}

export default App;