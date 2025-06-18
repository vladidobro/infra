# create_duckdb.py
import duckdb
import os

if __name__ == "__main__":
    print("Creating DuckDB file with mock data...")

    # Check if file exists
    if os.path.exists("guests.duckdb"):
        response = input(
            "Database already exists. Do you want to regenerate it? All data would be lost (y/n): "
        )
        if response.lower() != "y":
            print("Exiting without changes.")
            exit()

    # Connect (will create if not exists)
    con = duckdb.connect("guests.duckdb")

    # Create table
    con.execute(
        """
        DROP TABLE IF EXISTS guests;
        CREATE TABLE guests (
            name TEXT,
            code TEXT
        )
        """
    )

    # Insert mock data
    con.execute(
        """
    INSERT INTO guests VALUES
    ('Wrong', 'DuckDB path')
    """
    )

    print(f"DuckDB file '{os.path.abspath('guests.duckdb')}' created.")
