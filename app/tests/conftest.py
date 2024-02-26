import csv
import tempfile
from datetime import datetime
from decimal import Decimal

import pytest


@pytest.fixture
def temp_filepath():
    data = [
        ["Id", "Date", "Transaction"],
        [0, "7/15", "+60.5"],
        [1, "7/28", "-10.3"],
        [2, "8/2", "-20.46"],
        [3, "8/13", "+10"],
    ]
    with tempfile.NamedTemporaryFile(mode="w", delete=False, newline="") as temp_file:
        csv_writer = csv.writer(temp_file)
        csv_writer.writerows(data)

        return temp_file.name


@pytest.fixture
def file_data():
    return [
        (
            0,
            datetime.now().replace(
                minute=0, hour=0, second=0, month=7, day=15, microsecond=0
            ),
            Decimal("60.5"),
            True,
        ),
        (
            1,
            datetime.now().replace(
                minute=0, hour=0, second=0, month=7, day=28, microsecond=0
            ),
            Decimal("10.3"),
            False,
        ),
        (
            2,
            datetime.now().replace(
                minute=0, hour=0, second=0, month=8, day=2, microsecond=0
            ),
            Decimal("20.46"),
            False,
        ),
        (
            3,
            datetime.now().replace(
                minute=0, hour=0, second=0, month=8, day=13, microsecond=0
            ),
            Decimal("10"),
            True,
        ),
    ]
