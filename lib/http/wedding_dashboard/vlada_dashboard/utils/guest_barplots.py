import streamlit as st
import plotly.express as px
import pandas as pd
import os
from dotenv import load_dotenv

load_dotenv()
SYMBOL_TRUE = os.getenv("SYMBOL_TRUE", "✔")
SYMBOL_FALSE = os.getenv("SYMBOL_FALSE", "❌")


def plot_bar_children(df: pd.DataFrame):
    # Now create barplot data
    count_df = (
        df["is_child"]
        .value_counts()
        .rename(index={SYMBOL_TRUE: "Child", SYMBOL_FALSE: "Adult"})
        .reset_index()
    )
    count_df.columns = ["Guest Type", "Count"]

    fig = px.bar(
        count_df,
        x="Guest Type",
        y="Count",
        title="Children vs. Adults",
        color="Guest Type",
        text="Count",
        color_discrete_map={"Child": "green", "Adult": "orange"},
    )
    fig.update_layout(showlegend=False, height=400)
    return fig


def plot_bar_accommodation(df: pd.DataFrame):
    acc_df = df["accommodation"].value_counts().reset_index()
    acc_df.columns = ["Accommodation", "Count"]

    fig = px.bar(
        acc_df,
        x="Accommodation",
        y="Count",
        title="Accommodation Type",
        text="Count",
        color="Accommodation",
    )
    fig.update_layout(showlegend=False, height=400)
    return fig


def plot_bar_attendance(df: pd.DataFrame):
    # Flatten list of attendance days (some guests may have multiple days)
    attendance_flat = df["attendance"].dropna().explode()
    att_df = attendance_flat.value_counts().reset_index()
    att_df.columns = ["Day", "Count"]

    fig = px.bar(
        att_df,
        x="Day",
        y="Count",
        title="Attendance for Each Day",
        text="Count",
        color="Day",
    )
    fig.update_layout(showlegend=False, height=400)
    return fig
