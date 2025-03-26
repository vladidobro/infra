import streamlit as st
import plotly.graph_objects as go
from datetime import datetime


def plot_guest_arrivals(df):
    fixed_date = datetime(2025, 6, 13)
    times = []
    for t in df["arrival_time"].dropna():
        try:
            t_obj = datetime.strptime(t.strip(), "%H:%M").time()
            times.append(datetime.combine(fixed_date.date(), t_obj))
        except:
            continue
    times.sort()
    cumulative = list(range(1, len(times) + 1))
    if times:
        times.append(
            datetime.combine(
                fixed_date.date(), datetime.strptime("23:59", "%H:%M").time()
            )
        )
        cumulative.append(cumulative[-1])

    program = [
        ("12:30", "arrival at Melmatěj"),
        ("13:30", "departure by wedding buses"),
        ("14:00", "ceremony start"),
        ("14:30", "group photos"),
    ]
    program_times = [
        datetime.combine(fixed_date.date(), datetime.strptime(t, "%H:%M").time())
        for t, _ in program
    ]

    if "selected_event" not in st.session_state:
        st.session_state.selected_event = 0

    col1, col2 = st.columns([3, 1])
    with col1:
        fig = go.Figure()
        fig.add_trace(
            go.Scatter(
                x=times,
                y=cumulative,
                mode="lines+markers",
                name="Arrivals",
                line=dict(shape="hv", color="blue"),
            )
        )
        for i, t in enumerate(program_times):
            color = "red" if i == st.session_state.selected_event else "gray"
            fig.add_vline(x=t, line=dict(color=color, dash="dot"))

        fig.update_layout(
            height=500,
            hovermode="x unified",
            title="Guests Arriving on Wedding Day",
            xaxis_title="Time",
            yaxis_title="Cumulative Guests",
        )
        st.plotly_chart(fig, use_container_width=True)

    with col2:
        st.markdown("### 🕒 Programme")
        sel = st.radio(
            "Highlight Event",
            options=range(len(program)),
            format_func=lambda i: f"{program[i][0]} - {program[i][1]}",
            index=st.session_state.get("selected_event", 0),
        )
        st.session_state.selected_event = sel
