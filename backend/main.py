from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import date
import crud

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://127.0.0.1:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"message": "ehotel backend is running"}

@app.get("/hotels")
def get_hotels():
    try:
        return crud.get_hotels()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.get("/employees/{employee_id}")
def check_employee(employee_id: int):
    try:
        employee = crud.employee_exists(employee_id)

        if not employee:
            raise HTTPException(status_code=404, detail="Employee ID not found.")

        return employee
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.get("/rooms/available")
def get_available_rooms(start_date: date, end_date: date):
    try:
        return crud.get_available_rooms(start_date, end_date)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/rooms/filter")
def get_filter_rooms(
    min_price: int = None,
    max_price: int = None,
    capacity: str = None,
    view: str = None,
    amenity: str = None,
    start_date: date = None,
    end_date: date = None
):
    try:
        return crud.get_filtered_rooms(min_price, max_price, capacity, view, amenity, start_date, end_date)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
#allows for bookings to communicate with the frontend
class BookingRequest(BaseModel):
    customer_id: int
    hotel_id: int
    room_number: int
    start_date: date
    end_date: date

@app.get("/bookings")
def get_all_bookings():
    try:
        return crud.get_all_bookings()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/rentings")
def get_all_rentings():
    try:
        return crud.get_all_rentings()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.post("/bookings")
def create_booking(booking: BookingRequest):
    try:
        return crud.create_booking(booking.customer_id, booking.hotel_id, booking.room_number, booking.start_date, booking.end_date)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/bookings/cancel")
def cancel_booking(booking_id: int):
    try:
        return crud.cancel_booking(booking_id)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/rentings")
def check_in(booking_id: int):
    try:
        return crud.check_in(booking_id)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))