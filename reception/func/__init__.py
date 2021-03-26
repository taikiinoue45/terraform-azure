import logging

import azure.functions as func


def main(myblob: func.InputStream) -> None:
    logging.info("Python Blob trigger function processed %s", myblob.name)
