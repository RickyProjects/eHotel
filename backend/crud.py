#how to run queries:
#cd into backend
#python -m uvicorn main:app --reload

#in browser go to:
#http://127.0.0.1:8000

#or if you want to run something specific use something like these:
#http://127.0.0.1:8000/rooms/filter?min_price=100&max_price=300&capacity=double&view=sea
#http://127.0.0.1:8000/rooms/available?start_date=2025-05-9&end_date=2027-06-15

from database import get_connection

#format for a read function:
#def some_function():
#    conn = get_connection()
#    cur = conn.cursor()
#
#    cur.execute("YOUR SQL HERE")
#
#   result = cur.fetchall()   # or fetchone()
#
#   cur.close()
#   conn.close()
#
#   return result

# -----CREATE SECTION-----
def create_booking(customer_id, hotel_id, room_number, start_date, end_date):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO booking (customer_id, hotel_id, room_number, start_date, end_date, booking_date, status)
        VALUES (%s, %s, %s, %s, %s, CURRENT_DATE, 'pending')
    """, (customer_id, hotel_id, room_number, start_date, end_date))

    conn.commit()

    cur.close()
    conn.close()



# -----READ SECTION-----
def get_hotels():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT hotel_id, hotel_address FROM hotel;")

    rows = cur.fetchall()

    cur.close()
    conn.close()

    return rows

#maybe create a query that can get the average price of rooms for a given hotel or hotel chain

def get_available_rooms(start_date, end_date):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT r.*
        FROM room r
        WHERE r.is_damaged = FALSE
        AND NOT EXISTS (
            SELECT 1
            FROM booking b
            WHERE b.hotel_id = r.hotel_id
              AND b.room_number = r.room_number
              AND b.status IN ('pending', 'confirmed')
              AND b.start_date < %s
              AND %s < b.end_date
        )
        AND NOT EXISTS (
            SELECT 1
            FROM renting rt
            WHERE rt.hotel_id = r.hotel_id
              AND rt.room_number = r.room_number
              AND rt.status IN ('confirmed', 'completed')
              AND rt.start_date < %s
              AND %s < rt.end_date
        );
    """, (end_date, start_date, end_date, start_date))

    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows

#update to filter room for price, capacity, view, amenities
#currently only filters given a minimum and maximum price
def get_filtered_rooms(min_price=None, max_price=None, capacity=None, view=None, amenity=None):
    conn = get_connection()
    cur = conn.cursor()

    query = """
        SELECT r.*
        FROM room r
        WHERE r.is_damaged = FALSE
    """

    params = []

    if min_price is not None:
        query += " AND r.price >= %s"
        params.append(min_price)

    if max_price is not None:
        query += " AND r.price <= %s"
        params.append(max_price)

    if capacity is not None:
        query += " AND r.room_capacity = %s"
        params.append(capacity)

    if view is not None:
        query += " AND r.view = %s"
        params.append(view)

    if amenity is not None:
        query += """
            AND EXISTS (
                SELECT 1
                FROM amenities a
                WHERE a.hotel_id = r.hotel_id
                AND a.room_number = r.room_number
                AND a.amenity = %s
            )
        """
        params.append(amenity)

    query += " ORDER BY r.price;"

    cur.execute(query, tuple(params))

    rows = cur.fetchall()

    cur.close()
    conn.close()

    return rows

# -----UPDATE SECTION-----

# -----DELETE SECTION-----