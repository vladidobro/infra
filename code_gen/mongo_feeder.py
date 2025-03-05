#!/usr/bin/env python3
import sys
import csv
import pymongo

def main():
    if len(sys.argv) < 4:
        print("Usage: python feed_mongo.py <csv_file> <max_guests> <database_name>")
        sys.exit(1)

    csv_file = sys.argv[1]
    try:
        max_guests = int(sys.argv[2])
    except ValueError:
        print("The max_guests argument must be an integer.")
        sys.exit(1)
    
    database_name = sys.argv[3]

    client = pymongo.MongoClient("mongodb://localhost:27017/")
    db = client[database_name]
    coln = db.accesscodes

    documents = []
    try:
        with open(csv_file, mode='r', newline='') as f:
            reader = csv.DictReader(f)
            for row in reader:
                code = row.get("Code")
                if code:
                    doc = {
                        "code": code,
                        "max_guests": max_guests,
                        "used": False
                    }
                    documents.append(doc)
    except FileNotFoundError:
        print(f"CSV file '{csv_file}' not found.")
        sys.exit(1)
    
    if documents:
        result = coln.insert_many(documents)
        print(f"Inserted {len(result.inserted_ids)} documents into the coln of database '{database_name}'.")
    else:
        print("No valid records found in the CSV file.")

if __name__ == '__main__':
    main()