from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, Field

from base.entities.root_entity import Entity


class Transaction(BaseModel, Entity):
    id: int = Field(title="Id")
    txdate: datetime = Field(title="Date")
    amount: Decimal = Field(title="Amount")
    is_credit: bool = Field(title="Credit+/Debit-")

    class Config:
        json_encoders = {Decimal: str}
