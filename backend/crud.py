#how to run queries:
#cd into backend
#python -m uvicorn main:app --reload

#in browser go to:
#http://127.0.0.1:8000

#or if you want to run something specific use something like these:
#http://127.0.0.1:8000/rooms/filter?min_price=100&max_price=300&capacity=double&view=sea
#http://127.0.0.1:8000/rooms/available?start_date=2025-05-9&end_date=2027-06-15

#if you want to test modifications
#in browser go to:
#http://127.0.0.1:8000/docs

from database import get_connection
from datetime import date

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

    try:
        cur.execute("SELECT COALESCE(MAX(booking_id), 0) + 1 AS next_id FROM booking;")
        next_booking_id = cur.fetchone()["next_id"]
        
        cur.execute("""
            INSERT INTO booking (
                booking_id, customer_id, hotel_id, room_number,
                start_date, end_date, booking_date, status
            )
            VALUES (%s, %s, %s, %s, %s, %s, CURRENT_DATE, 'pending')
        """, (next_booking_id, customer_id, hotel_id, room_number, start_date, end_date))

        conn.commit()

        return {
            "message": "Booking created successfully.",
            "booking_id": next_booking_id
        }

    except Exception as e:
        conn.rollback()
        return {
            "message": f"Error creating booking: {str(e)}"
        }

    finally:
        cur.close()
        conn.close()

#this is an insertion and an update
def get_all_bookings():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT booking_id, customer_id, hotel_id, room_number, start_date, end_date, booking_date, status FROM booking ORDER BY booking_id;")

    rows = cur.fetchall()

    cur.close()
    conn.close()

    return rows


def get_all_rentings():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT renting_id, customer_id, hotel_id, room_number, start_date, end_date, checkin_date, status FROM renting ORDER BY renting_id;")

    rows = cur.fetchall()

    cur.close()
    conn.close()

    return rows

def check_in(booking_id):
    conn = get_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            SELECT customer_id, hotel_id, room_number, start_date, end_date, status
            FROM booking
            WHERE booking_id = %s
        """, (booking_id,))
        booking = cur.fetchone()

        if not booking:
            return {"message": "booking_id does not exist."}

        if booking["status"] == "cancelled":
            return {"message": "Booking was previously cancelled."}

        if booking["status"] == "confirmed":
            return {"message": "Booking has already been checked in."}

        if booking["status"] != "pending":
            return {"message": f"Invalid booking status: {booking['status']}"}
        
        if date.today() < booking["start_date"]:
            return {"message": "Cannot check in before booking start date."}

        cur.execute("SELECT COALESCE(MAX(renting_id), 0) + 1 AS next_id FROM renting;")
        next_renting_id = cur.fetchone()["next_id"]

        # update booking first so triggers no longer see it as an active booking conflict
        cur.execute("""
            UPDATE booking
            SET status = 'confirmed'
            WHERE booking_id = %s
        """, (booking_id,))

        # now insert renting
        cur.execute("""
            INSERT INTO renting (
                renting_id, customer_id, hotel_id, room_number,
                start_date, end_date, checkin_date, status
            )
            VALUES (%s, %s, %s, %s, %s, %s, CURRENT_DATE, 'archived')
        """, (
            next_renting_id,
            booking["customer_id"],
            booking["hotel_id"],
            booking["room_number"],
            booking["start_date"],
            booking["end_date"]
        ))

        conn.commit()
        return {"message": "Check-in successful.", "renting_id": next_renting_id}

    except Exception as e:
        conn.rollback()
        return {"message": f"Error during check-in: {str(e)}"}

    finally:
        cur.close()
        conn.close()

# -----READ SECTION-----
def employee_exists(employee_id):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT employee_id, full_name, role, hotel_id
        FROM employee
        WHERE employee_id = %s
    """, (employee_id,))

    row = cur.fetchone()

    cur.close()
    conn.close()

    return row

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

    try:
        if start_date >= end_date:
            return {"message": "start_date must be before end_date."}

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
                    AND rt.status IN ('confirmed', 'archived')
                    AND rt.start_date < %s
                    AND %s < rt.end_date
              )
            ORDER BY r.hotel_id, r.room_number;
        """, (end_date, start_date, end_date, start_date))

        return cur.fetchall()

    finally:
        cur.close()
        conn.close()

def get_filtered_rooms(min_price=None, max_price=None, capacity=None, view=None, amenity=None, start_date=None, end_date=None):
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

    if start_date is not None and end_date is not None:
        query += """
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
                  AND rt.status IN ('confirmed', 'archived')
                  AND rt.start_date < %s
                  AND %s < rt.end_date
            )
        """
        params.extend([end_date, start_date, end_date, start_date])

    query += " ORDER BY r.price;"

    cur.execute(query, tuple(params))
    rows = cur.fetchall()

    cur.close()
    conn.close()

    return rows

# -----UPDATE SECTION-----

def cancel_booking(booking_id):
    conn = get_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            SELECT status
            FROM booking
            WHERE booking_id = %s
        """, (booking_id,))
        booking = cur.fetchone()

        if not booking:
            return {"message": "booking_id does not exist."}

        status = booking["status"]

        if status == "cancelled":
            return {"message": "Booking is already cancelled."}

        if status == "confirmed":
            return {"message": "Cannot cancel a booking that has already been checked in."}

        cur.execute("""
            UPDATE booking
            SET status = 'cancelled'
            WHERE booking_id = %s
        """, (booking_id,))

        conn.commit()
        return {"message": "Booking cancelled successfully."}

    except Exception as e:
        conn.rollback()
        return {"message": f"Error cancelling booking: {str(e)}"}

    finally:
        cur.close()
        conn.close()

# -----DELETE SECTION-----