import pytest
import pandas as pd
from utils.data_loader import load_guests_from_json
import os


def test_load_guests_from_json():
    df, raw = load_guests_from_json("data/mongo_dump.json")
    assert isinstance(df, pd.DataFrame)
    assert isinstance(raw, dict)
    assert not df.empty
    assert "name" in df.columns
