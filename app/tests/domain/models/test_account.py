from decimal import Decimal

from faker import Faker

from domain.models.account import Account
from domain.models.transaction import Transaction

fake = Faker()


def test_add_transactions(file_data):
    """
    Validates all the information in the account
    is updated properly
    """

    fake_id = fake.word()

    account = Account(id=fake_id)

    for data in file_data:
        id, txdate, amount, is_credit = data
        transaction = Transaction(
            id=id, txdate=txdate, amount=amount, is_credit=is_credit
        )
        account.add_transaction(transaction)

    assert account.id == fake_id
    assert account.balance == Decimal("39.74")
    assert account.total_debit == Decimal("30.76")
    assert account.debit_count == 2
    assert account.total_credit == Decimal("70.5")
    assert account.credit_count == 2
    assert account.tx_x_month == {"July": 2, "August": 2}
    assert len(account.transactions) == len(file_data)
