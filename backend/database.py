import psycopg2
from psycopg2.extras import RealDictCursor

def get_connection():
    return psycopg2.connect(
        host="localhost",
        dbname="hotel_db",
        user="postgres",
        password="ghjk",
        port=5432,
        cursor_factory=RealDictCursor
    )