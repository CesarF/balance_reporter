"""
Resources related with the command implementation
to process the credit and debit information
of an account
"""
import logging
from datetime import datetime
from decimal import Decimal
from typing import NoReturn, Tuple
from uuid import uuid4

from base.commands.base_command import BaseCommand
from base.ports.db_handler import DBHandler
from base.ports.email_handler import EmailHandler
from base.ports.file_handler import FileHandler
from config import FILE_PATH
from domain.models.account import Account
from domain.models.transaction import Transaction

logger = logging.getLogger("app.domain.commands.balance_command")


class BalanceProcessorCommand(BaseCommand):
    def __init__(
        self,
        db_handler: DBHandler,
        file_handler: FileHandler,
        email_handler: EmailHandler,
    ) -> None:
        super().__init__()
        self._db_handler = db_handler
        self._file_handler = file_handler
        self._email_handler = email_handler

    def _extract_data(self, row: Tuple) -> Tuple:
        try:
            str_id, str_txdate, str_amount = row
            if str_amount[0] not in ["-", "+"]:
                raise Exception("Invalid character in transaction amount")
            is_credit = str_amount[0] == "+"
            txdate = datetime.strptime(str_txdate, "%M/%d")
            return int(str_id), txdate, Decimal(str_amount[1:]), is_credit
        except Exception as err:
            logger.error(err, exc_info=True)
            raise Exception("Invalid file format")

    def __call__(self, _) -> NoReturn:
        # get file
        txlist = self._file_handler.load_file(FILE_PATH)

        account = Account(id=uuid4())

        # process file
        for tx in txlist:
            id, txdate, amount, is_credit = self._extract_data(tx)
            transaction = Transaction(
                id=id, txdate=txdate, amount=amount, is_credit=is_credit
            )
            account.add_transaction(transaction)

        # store data in database

        # send email
        self._email_handler.send_email_balance(account)
