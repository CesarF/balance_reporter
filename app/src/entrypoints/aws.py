"""
Main file
"""
from domain.adapters.db.aws_db_handler import AWSDBHandler
from domain.adapters.email.aws_email_handler import AWSEmailHandler
from domain.adapters.file.aws_file_handler import AWSFileHandler
from domain.commands.balance_command import BalanceProcessorCommand


def handler(event, _) -> dict:
    """
    entrypoint to execute the application using AWS services
    """

    command = BalanceProcessorCommand(
        db_handler=AWSDBHandler(),
        file_handler=AWSFileHandler(),
        email_handler=AWSEmailHandler(),
    )

    result = command(event)
    return {"result": result}
