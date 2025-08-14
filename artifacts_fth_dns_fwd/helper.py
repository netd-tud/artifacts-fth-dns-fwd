from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from matplotlib.axes import Axes
from typing import Tuple

from artifacts_fth_dns_fwd.config import FIGURES_DIR

from tqdm import tqdm

import os
import pickle
import itertools

import pandas as pd

import time
from loguru import logger

def timeit(func):
    def wrapper(*args, **kwargs):
        start = time.perf_counter()  # High-resolution timer
        result = func(*args, **kwargs)
        end = time.perf_counter()
        logger.info(f"Function '{func.__name__}' executed in {end - start:.6f} seconds")
        return result
    return wrapper

def fig_ax(figsize: tuple, **kwargs) -> Tuple[Figure, Axes]:
    """Wrapper for plt.subplots with default figure size.

    Args:
        figsize: figsize for plt.sublots, default chosen based on paper kind
        **kwargs: kwargs for plt.subplots

    Returns:
        tuple[Figure, Axes]: similar to plt.subplots
    """
    return plt.subplots(figsize=figsize, **kwargs)


def save_plot(
    fig: Figure, file_name: str, directory: Path = FIGURES_DIR, autoclose: bool = False, dpi=200, pngonly=False
):
    """Save figure into FIGURES_DIR in high resolution png and pdf format.

    Args:
        fig: matplotlib figure
        file_name: filename without file extensions. Suggested pattern: f'{3ltr_plot_kind}_{description}'
        directory: destination folder, default: FIGURES_DIR
        autoclose: autoclose matplotlib figures
    """
    if file_name is not None:
        print(directory / f"{file_name}.png")
        fig.savefig(directory / f"{file_name}.png", bbox_inches="tight", dpi=dpi)
        if not pngonly:
            fig.savefig(directory / f"{file_name}.pdf", bbox_inches="tight")

    if autoclose:
        plt.close()


def load_or_process_pickle(pickle_path, process_func, *args, **kwargs):
    """
    Load a DataFrame from a pickle file if it exists,
    otherwise run the processing function, save the result, and return it.

    Args:
        pickle_path: Path to the pickle file.
        process_func: Function to generate the DataFrame.
        *args, **kwargs: Arguments passed to process_func.

    Returns:
        DataFrame: The loaded or processed DataFrame.
    """
    if os.path.exists(pickle_path):
        with open(pickle_path, 'rb') as f:
            return pickle.load(f)
    else:
        result = process_func(*args, **kwargs)
        with open(pickle_path, 'wb') as f:
            pickle.dump(result, f)
        return result

def flip(items, ncol):
    return list(itertools.chain(*[items[i::ncol] for i in range(ncol)]))
