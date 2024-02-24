from pydantic import BaseModel, Field
from domain.models.transaction import Transaction
from base.entities.root_entity import RootEntity
from typing import List, Dict, NoReturn
from decimal import Decimal


class Account(BaseModel, RootEntity):

    id:str = Field(..., title="Id")
    transactions:List[Transaction] = Field(default=[], title="Transactions")
    balance:Decimal = Field(..., title="Balance")
    debit_count:int = Field(..., title="Debit count")
    credit_count:int = Field(..., title="Credit count")
    total_debit:Decimal = Field(..., title="Debit")
    total_credit:Decimal = Field(..., title="Credit")
    tx_x_month:Dict = Field(default = {}, title="Transactions x month")

    def add_transaction(self, transaction: Transaction) -> NoReturn:
        self.transactions.append(transaction)
        if transaction.is_credit:
            self.total_credit += transaction.amount
            self.credit_count += 1
            self.balance += transaction.amount
        else:
            self.total_debit += transaction.amount
            self.debit_count += 1
            self.balance -= transaction.amount
        if transaction.txdate.month not in self.tx_x_month:
            self.tx_x_month[transaction.txdate.month] = 0
        self.tx_x_month[transaction.txdate.month] += 1
