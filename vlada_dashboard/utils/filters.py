import streamlit as st

from dotenv import load_dotenv
import os

load_dotenv()

SYMBOL_TRUE = os.getenv("SYMBOL_TRUE", "✔")
SYMBOL_FALSE = os.getenv("SYMBOL_FALSE", "❌")


def guest_filters(df):
    col1, col2, col3 = st.columns(3)
    with col1:
        acc = st.multiselect(
            "Accommodation", sorted(df["accommodation"].dropna().unique())
        )
    with col2:
        transport = st.multiselect(
            "Transport", sorted(df["transport"].dropna().unique())
        )
    with col3:
        child = st.radio("Is Child?", ["All", SYMBOL_TRUE, SYMBOL_FALSE], index=0)

    df["is_child"] = df["is_child"].apply(lambda x: SYMBOL_TRUE if x else SYMBOL_FALSE)

    if acc:
        df = df[df["accommodation"].isin(acc)]
    if transport:
        df = df[df["transport"].isin(transport)]
    if child != "All":
        df = df[df["is_child"] == child]

    return df
