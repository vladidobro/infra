import json
import pandas as pd


def load_guests(path):
    with open(path) as f:
        data = json.load(f)

    guests = []
    for code_entry in data.get("codes", []):
        reg = code_entry.get("registration", {})
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

    return pd.DataFrame(guests), data
