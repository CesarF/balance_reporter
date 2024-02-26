from decimal import Decimal
from typing import Dict, List, NoReturn

from pydantic import BaseModel, Field

from base.entities.root_entity import RootEntity
from config import HTML_TEMPLATE
from domain.models.transaction import Transaction


class Account(RootEntity, BaseModel):
    """
    Represents the account Entity
    """

    id: str = Field(title="Id")
    transactions: List[Transaction] = Field(default=[], title="Transactions")
    balance: Decimal = Field(default=0, title="Balance")
    debit_count: int = Field(default=0, title="Debit count")
    credit_count: int = Field(default=0, title="Credit count")
    total_debit: Decimal = Field(default=0, title="Debit")
    total_credit: Decimal = Field(default=0, title="Credit")
    tx_x_month: Dict = Field(default={}, title="Transactions x month")

    class Config:
        json_encoders = {Decimal: str}

    def add_transaction(self, transaction: Transaction) -> NoReturn:
        """Add a transaction to the account"""
        self.transactions.append(transaction)
        if transaction.is_credit:
            self.total_credit += transaction.amount
            self.credit_count += 1
            self.balance += transaction.amount
        else:
            self.total_debit += transaction.amount
            self.debit_count += 1
            self.balance -= transaction.amount
        month = transaction.txdate.strftime("%B")
        if month not in self.tx_x_month:
            self.tx_x_month[month] = 0
        self.tx_x_month[month] += 1

    def create_message(self) -> str:
        """Format a message using the data in the account"""
        rows = [
            f"<tr><td>{key}</td><td>{value}</td></tr>"
            for key, value in self.tx_x_month.items()
        ]
        return HTML_TEMPLATE.format(
            total_balance=self.balance,
            average_debit=self.total_debit / self.debit_count,
            average_credit=self.total_credit / self.credit_count,
            rows="".join(rows),
        )
