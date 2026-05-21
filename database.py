import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv
import os

load_dotenv()

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432'),
    'database': os.getenv('DB_NAME', 'lab_films&directors'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '28042006Nastya')
}

def get_db_connection():
    conn = psycopg2.connect(**DB_CONFIG)
    return conn

def get_db_cursor():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    return cur, conn