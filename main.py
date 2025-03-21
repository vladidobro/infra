import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import plotly.graph_objects as go
from datetime import datetime
import json

from streamlit_plotly_events import plotly_events


# -- Assume `data` is already loaded from a JSON file or MongoDB dump --
def main():
    with open("data/mongo_dump.json") as f:
        data = json.load(f)

    # --- Extract guests from data ---
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

    # Convert to DataFrame
    df = pd.DataFrame(guests)
    # --- Streamlit Dashboard ---
    # st.set_page_config(page_title="Wedding Dashboard", layout="wide")
    st.title("💍 Wedding Registration Dashboard")

    # --- 1. Who accepted the invite ---
    st.subheader("✅ Guests with Accepted Applications")

    # Filters
    col1, col2, col3 = st.columns(3)
    with col1:
        filter_accommodation = st.multiselect(
            "Accommodation Type",
            options=sorted(df["accommodation"].dropna().unique()),
            default=None,
        )
    with col2:
        filter_transport = st.multiselect(
            "Transportation Type",
            options=sorted(df["transport"].dropna().unique()),
            default=None,
        )
    with col3:
        filter_child = st.radio("Is Child?", options=["All", True, False], index=0)

    filtered_df = df.copy()
    filtered_df["is_child"] = filtered_df["is_child"].apply(lambda x: "✔" if x else "")
    if filter_accommodation:
        filtered_df = filtered_df[
            filtered_df["accommodation"].isin(filter_accommodation)
        ]
    if filter_transport:
        filtered_df = filtered_df[filtered_df["transport"].isin(filter_transport)]
    if filter_child != "All":
        filtered_df = filtered_df[filtered_df["is_child"] == filter_child]

    st.dataframe(filtered_df)

    # --- 2. Used vs Unused Codes (Speedometer-style Pie) ---
    used = sum(1 for c in data["codes"] if c.get("used"))
    unused = len(data["codes"]) - used

    fig_gauge = go.Figure(
        go.Indicator(
            mode="gauge+number",
            value=used,
            domain={"x": [0, 1], "y": [0, 1]},
            title={"text": "Used Codes"},
            gauge={
                "axis": {"range": [0, len(data["codes"])]},
                "bar": {"color": "green"},
                "steps": [{"range": [0, len(data["codes"])], "color": "lightgray"}],
            },
        )
    )

    st.subheader("🎯 Used Invitation Codes")
    st.plotly_chart(fig_gauge, use_container_width=True)

    # --- 3. Cumulative Arrival Times ---
    arrival_times = df["arrival_time"].dropna()
    fixed_date = datetime(2025, 6, 13)
    parsed_times = []
    for t in arrival_times:
        try:
            time_part = datetime.strptime(t.strip(), "%H:%M").time()
            parsed_times.append(datetime.combine(fixed_date.date(), time_part))
        except:
            continue
    parsed_times.sort()
    cumulative = list(range(1, len(parsed_times) + 1))

    # Extend cumulative line to last programme time
    if parsed_times:
        last_time = max(parsed_times)
        final_time = datetime.combine(
            fixed_date.date(), datetime.strptime("23:59", "%H:%M").time()
        )
        parsed_times.append(final_time)
        cumulative.append(cumulative[-1])

    # Wedding programme timeline
    program = [
        ("12:30", "arrival at Melmatěj"),
        ("13:30", "departure by wedding buses"),
        ("14:00", "ceremony start"),
        ("14:30", "group photos"),
        ("15:00", "bus back to reception"),
        ("15:30", "arrival of newlyweds"),
        ("16:00", "toasts & banquet"),
        ("17:00", "bouquet toss"),
        ("17:30", "first dance"),
    ]
    program_times = [
        datetime.combine(fixed_date.date(), datetime.strptime(p[0], "%H:%M").time())
        for p in program
    ]
    program_labels = [p[1] for p in program]

    # Create figure
    fig = go.Figure()
    fig.add_trace(
        go.Scatter(
            x=parsed_times,
            y=cumulative,
            mode="lines+markers",
            name="Guest Arrivals",
            line=dict(shape="hv", color="blue"),
        )
    )

    # Store selected event in session state
    if "selected_event" not in st.session_state:
        st.session_state.selected_event = None

    # Add vertical markers for programme events
    for i, t in enumerate(program_times):
        line_color = "red" if st.session_state.selected_event == i else "gray"
        fig.add_vline(x=t, line=dict(color=line_color, dash="dot"))

    fig.update_layout(
        title="Cumulative Guest Arrivals vs. Programme Timeline",
        xaxis_title="Time",
        yaxis_title="# of Guests Arrived",
        hovermode="x unified",
        height=500,
    )

    # Layout: Plot left, timeline right
    col_plot, col_programme = st.columns([3, 1])
    with col_plot:
        st.plotly_chart(fig, use_container_width=True)

    with col_programme:
        st.markdown("### 🕒 Programme (Click twice)")
        for i, (time_str, label) in enumerate(program):
            # Make each program item clickable
            if st.button(
                f"{time_str} - {label}",
                key=f"event_{i}",
                help="Click to highlight this event",
            ):
                st.session_state.selected_event = (
                    i if st.session_state.selected_event != i else None
                )

            # Style based on selection
            if st.session_state.selected_event == i:
                st.markdown(
                    f"<div style='background-color: #ffeeba; padding: 5px; border-radius: 5px'><b>{time_str}</b><br>{label}</div>",
                    unsafe_allow_html=True,
                )


if __name__ == "__main__":
    main()
