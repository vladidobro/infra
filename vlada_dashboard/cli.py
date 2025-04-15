from . import app
import os
import sys
import streamlit

def main():
    args = [sys.executable, sys.executable, "-m", "streamlit", "run", app.__file__, '--', *sys.argv[1:]]
    print(args)
    os.execl(*args)
