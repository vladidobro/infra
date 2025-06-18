import streamlit as st
import duckdb
import sys
import logging
import json
import pandas as pd

from pymongo import MongoClient
from urllib.parse import urlparse


def load_guest_data(logger: logging.Logger) -> tuple[pd.DataFrame, dict]:
    """
    Loads guest data from either a JSON file or a MongoDB instance.
    Loads it only if it hasn't been loaded before.
    """
    if "df" in st.session_state and "raw_data" in st.session_state:
        return st.session_state.df, st.session_state.raw_data

    if len(sys.argv) > 1:
        logger.info("Loading data from MongoDB")
        mongo_uri = sys.argv[1]
        df, raw_data = load_guests_from_mongo(mongo_uri)
    else:
        logger.info("Loading data from JSON file")
        df, raw_data = load_guests_from_json("data/mongo_dump.json")

    st.session_state.df = df
    st.session_state.raw_data = raw_data
    return df, raw_data


def load_guests_from_json(path: str) -> tuple[pd.DataFrame, dict]:
    """
    Load guest data from a JSON file
    """
    with open(path) as f:
        data = json.load(f)
    return flatten_guest_data(data), data


def load_guests_from_mongo(mongo_uri: str) -> tuple[pd.DataFrame, dict]:
    """
    Load guest data from a MongoDB instance
    """
    parsed_db = urlparse(mongo_uri).path.lstrip("/")
    with MongoClient(mongo_uri) as client:
        dump = {}
        for col in client[parsed_db].list_collection_names():
            dump[col] = list(client[parsed_db][col].find())
    return flatten_guest_data(dump), dump


def flatten_guest_data(data: dict) -> pd.DataFrame:
    """
    Processes the raw data from MongoDB and returns a DataFrame with guest information.
    This dataframe is the basis for "Guests with Accepted Applications" in the dashboard.

    Args:
        data (dict): Raw data from MongoDB, output of data_loader.load_data()
    Returns:
        pd.DataFrame: DataFrame with guest information
    """
    guests = []
    for code_entry in data.get("codes", []):
        if "registration" in code_entry:
            reg = code_entry["registration"]
            if reg.get("accepted"):
                main = reg.get("main_guest", {})
                guests.append(
                    {
                        "name": main.get("name"),
                        "is_child": main.get("is_child"),
                        "transport": main.get("transportation_type"),
                        "accommodation": main.get("accomodation_type"),
                        "arrival_time": main.get("arrival_time"),
                        "avec": None,
                        "phone_number": reg.get("phone_number"),
                        "email": reg.get("email"),
                        "attendance": main.get("attendance_days"),
                    }
                )
                for g in reg.get("guests_list", []):
                    guests.append(
                        {
                            "name": g.get("name"),
                            "is_child": g.get("is_child"),
                            "transport": g.get("transportation_type"),
                            "accommodation": g.get("accomodation_type"),
                            "arrival_time": main.get("arrival_time"),
                            "avec": main.get("name"),
                            "phone_number": None,
                            "email": None,
                            "attendance": g.get("attendance_days"),
                        }
                    )
    return pd.DataFrame(guests)


@st.cache_data
def load_duckdb_guests(db_path: str = "guests.duckdb") -> pd.DataFrame:
    """
    Load guests' names and codes from a DuckDB database
    """
    con = duckdb.connect(db_path)
    df = con.execute("SELECT * FROM guests").fetchdf()
    con.close()
    return df
