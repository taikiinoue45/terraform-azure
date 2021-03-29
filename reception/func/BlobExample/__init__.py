import logging
import re
from pathlib import Path
from zipfile import ZipFile

import azure.functions as func
import pandas as pd


def main(inblob: func.InputStream) -> None:
    logging.info(f"Name: {inblob.name}")


def _exit() -> None:

    pass


def _check_zip_name(zip_path: Path) -> bool:

    product_name, anomaly_or_normal = zip_path.stem.split("_")

    if product_name not in ["Highlander", "RAV4", "RX"]:
        logging.error(
            f"Error: _check_zip_name."
            f"{product_name} of {zip_path.name} isn't correct."
            f"It must be Highlander, RAV4 or RX."
        )
        return False

    if anomaly_or_normal not in ["anomaly", "normal"]:
        logging.error(
            f"Error: _check_zip_name."
            f"{anomaly_or_normal} of {zip_path.name} isn't correct."
            f"It must be anomaly or normal."
        )
        return False

    return True


def _unzip(zip_path: Path) -> None:

    with ZipFile(zip_path, "r") as f:
        f.extractall(zip_path.parent)


def _check_dir_name(zip_stem: str, dir_name: str) -> bool:

    if zip_stem != dir_name:
        logging.error(
            f"Error: _check_dir_name."
            f"Unzipped directory name: {dir_name}."
            f"The stem of zip file: {zip_stem}."
        )
        return False

    return True


def _check_data_structure(dir_name: Path) -> bool:

    actual_data_structure = {str(p) for p in dir_name.glob("**/*[!.jpg]")}
    ideal_data_structure = {f"{str(dir_name)}/{i+1}" for i in range(4)}
    if actual_data_structure != ideal_data_structure:
        logging.error(
            f"Error: _check_data_structure."
            f"The actual data structure is {actual_data_structure}"
            f"The ideal data structure is {ideal_data_structure}"
        )
        return False

    return True


def _check_jpg_name(dir_path: Path) -> bool:

    pattern = re.compile(r"\d+_\d{10}_\d{10}_\d{14}.jpg")
    for p in dir_path.glob("*/*.jpg"):
        if not pattern.match(p.name):
            logging.error(
                f"Error: _check_jpg_name"
                f"{p} isn't correct."
                "Naming convention is \d+_\d{10}_\d{10}_\d{14}.jpg"
            )
            return False

    return True


def _check_camera_angle(dir_path: Path) -> bool:

    df = pd.DataFrame({})
    for p in dir_path.glob("*/*.jpg"):
        station = p.parent.stem
        product_id, camera_id, camera_angle, timestamp = p.stem.split("_")
        df.append(
            {
                "station": station,
                "product_id": product_id,
                "camera_id": camera_id,
                "camera_angle": camera_angle,
                "timestamp": timestamp,
            }
        )


def _check_product_id() -> bool:

    pass
