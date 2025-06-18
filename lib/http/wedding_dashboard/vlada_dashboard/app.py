import streamlit as st
import logging


from vlada_dashboard.utils.data_loader import load_guest_data, load_duckdb_guests
from vlada_dashboard.utils.filters import filter_accepted_applications, get_unused_codes
from vlada_dashboard.utils.guest_barplots import (
    plot_bar_children,
    plot_bar_accommodation,
    plot_bar_attendance,
)
from vlada_dashboard.utils.code_gauge import plot_code_gauge
from vlada_dashboard.utils.cum_guests_arrival import plot_guest_arrivals


# Get Streamlit logger
logger = logging.getLogger("streamlit")
logger.setLevel(logging.INFO)


def main():

    df, raw_data = load_guest_data(logger)

    st.set_page_config(page_title="Wedding Dashboard", layout="wide")
    st.title("💍 Wedding Registration Dashboard")

    #######################################
    ## Guests with Accepted Applications ##
    #######################################

    st.markdown(
        "<div style='border:1px solid black; padding:10px; border-radius:5px'>",
        unsafe_allow_html=True,
    )
    st.subheader("✅📊 Guests with Accepted Applications")
    df_filtered = filter_accepted_applications(df)
    st.dataframe(df_filtered)

    ###############################################
    ## Guests with Not Yet Accepted Applications ##
    ###############################################

    st.markdown(
        "<div style='border:1px solid black; padding:10px; border-radius:5px'>",
        unsafe_allow_html=True,
    )
    st.subheader("❌ Guests with Not Yet Accepted Applications")

    codes_and_names = load_duckdb_guests("guests.duckdb")
    unused_codes = get_unused_codes(raw_data)
    unused_guests = unused_codes.merge(
        codes_and_names, how="inner", left_on="code", right_on="code"
    )

    st.dataframe(unused_guests)

    #######################################
    ## Split layout for gauge + arrivals ##
    #######################################

    col1, col2 = st.columns([1, 1])

    with col1:
        st.markdown(
            "<div style='border:1px solid black; padding:10px; border-radius:5px'>",
            unsafe_allow_html=True,
        )
        st.subheader("🎯 Used Invitation Codes")
        plot_code_gauge(raw_data)
        st.markdown("</div>", unsafe_allow_html=True)

    with col2:
        st.markdown(
            "<div style='border:1px solid black; padding:10px; border-radius:5px'>",
            unsafe_allow_html=True,
        )
        st.subheader("📈 Cumulative Guest Arrivals")
        plot_guest_arrivals(df)
        st.markdown("</div>", unsafe_allow_html=True)

    ###############################
    ## Guest Statistics Barplots ##
    ###############################

    st.markdown(
        "<div style='border:1px solid black; padding:10px; border-radius:5px'>",
        unsafe_allow_html=True,
    )
    st.subheader("📊 Guest Statistics")
    col1, col2, col3 = st.columns(3)

    st.markdown("</div>", unsafe_allow_html=True)
    with col1:
        st.plotly_chart(plot_bar_children(df), use_container_width=True)

    with col2:
        st.plotly_chart(plot_bar_accommodation(df), use_container_width=True)

    with col3:
        st.plotly_chart(plot_bar_attendance(df), use_container_width=True)


if __name__ == "__main__":
    main()
