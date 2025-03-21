#!/usr/bin/env python

import os
from pymongo import MongoClient
from bson import json_util
from pathlib import Path
from datetime import datetime
from urllib.parse import urlparse

MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017/svatba")
DATABASE = urlparse(MONGO_URI).path.lstrip("/")

if __name__ == "__main__":

    with MongoClient(MONGO_URI) as c:
        dump = {}
        for col in c[DATABASE].list_collection_names():
            dump[col] = list(c[DATABASE][col].find())

    data = json_util.dumps(dump, indent=2)
    bkdir = Path("mongo_dump")
    bkdir.mkdir(exist_ok=True)
    (bkdir / datetime.utcnow().strftime("%Y%m%dT%H%M%S.json")).write_text(data)
    Path("data/mongo_dump.json").write_text(data)
