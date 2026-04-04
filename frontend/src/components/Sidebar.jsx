function Sidebar({ filters, onChange, onSearch }) {
  return (
    <div style={styles.sidebar}>
      <h3>Filters</h3>

      <label>Min Price</label>
      <input name="min_price" value={filters.min_price} onChange={onChange} />

      <label>Max Price</label>
      <input name="max_price" value={filters.max_price} onChange={onChange} />

      <label>Capacity</label>
      <select name="capacity" value={filters.capacity} onChange={onChange}>
        <option value="">Any</option>
        <option value="single">single</option>
        <option value="double">double</option>
        <option value="twin">twin</option>
        <option value="queen">queen</option>
        <option value="king">king</option>
        <option value="studio">studio</option>
        <option value="penthouse">penthouse</option>
      </select>

      <label>View</label>
      <select name="view" value={filters.view} onChange={onChange}>
        <option value="">Any</option>
        <option value="sea">sea</option>
        <option value="mountain">mountain</option>
        <option value="city">city</option>
      </select>

      <label>Start Date</label>
      <input type="date" name="start_date" value={filters.start_date} onChange={onChange} />

      <label>End Date</label>
      <input type="date" name="end_date" value={filters.end_date} onChange={onChange} />

      <button onClick={onSearch} style={styles.button}>
        Apply Filters
      </button>
    </div>
  );
}

const styles = {
  sidebar: {
    width: '20vw',
    background: '#ffffff',
    padding: '16px',
    borderRight: '1px solid #ccc',
    display: 'flex',
    flexDirection: 'column',
    gap: '8px',
    height: 'calc(100vh - 80px)', // minus header
    position: 'sticky',
    top: '80px',
  },
  button: {
    marginTop: '10px',
    padding: '8px',
    cursor: 'pointer',
  },
};

export default Sidebar;