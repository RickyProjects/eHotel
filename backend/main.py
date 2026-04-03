from fastapi import FastAPI, HTTPException
from datetime import date
import crud

app = FastAPI()

@app.get("/")
def root():
    return {"message": "ehotel backend is running"}

@app.get("/hotels")
def get_hotels():
    try:
        return crud.get_hotels()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/rooms/available")
def get_available_rooms(start_date: str, end_date: str):
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
    amenity:str = None,
    start_date:date = None,
    end_date:date = None
):
    return crud.get_filtered_rooms(min_price, max_price, capacity, view, amenity, start_date, end_date)

@app.post("/bookings")
def create_booking(customer_id: int, hotel_id: int, room_number: int, start_date: str, end_date: str):
    try:
        crud.create_booking(customer_id, hotel_id, room_number, start_date, end_date)
        return {"message": "booking created successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.post("/bookings/cancel")
def cancel_booking(booking_id:int):
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