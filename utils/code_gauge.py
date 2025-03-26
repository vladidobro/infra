import plotly.graph_objects as go
import streamlit as st


def plot_code_gauge(data):
    used = sum(1 for c in data["codes"] if c.get("used"))
    total = len(data["codes"])
    fig = go.Figure(
        go.Indicator(
            mode="gauge+number",
            value=used,
            number={"suffix": f" / {total}"},
            title={"text": "Used Invitation Codes"},
            gauge={
                "axis": {"range": [0, total]},
                "bar": {"color": "green"},
                "steps": [{"range": [0, total], "color": "lightgray"}],
            },
        )
    )
    st.plotly_chart(fig, use_container_width=True)
