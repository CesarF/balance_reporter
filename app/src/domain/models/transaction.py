from pydantic import BaseModel, Field
from datetime import date
from decimal import Decimal
from base.entities.root_entity import Entity


class Transaction(BaseModel, Entity):

    id: int = Field(..., title="Id")
    txdate: date = Field(title="Date")
    amount: Decimal = Field(..., title="Amount")
    is_credit: bool = Field(..., title="Credit+/Debit-")
