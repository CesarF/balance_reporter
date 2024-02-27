"""
Main file
"""
import json
import logging

from domain.adapters.db.aws_db_handler import AWSDBHandler
from domain.adapters.email.aws_email_handler import AWSEmailHandler
from domain.adapters.file.aws_file_handler import AWSFileHandler
from domain.commands.balance_command import BalanceProcessorCommand

logger = logging.getLogger(__name__)


def handler(event, _) -> dict:
    """
    entrypoint to execute the application using AWS services
    """
    try:
        logger.info("START %s", event)

        command = BalanceProcessorCommand(
            db_handler=AWSDBHandler(),
            file_handler=AWSFileHandler(),
            email_handler=AWSEmailHandler(),
        )

        result = command()
        logger.info("ENDS %s", result)
        return {
            "statusCode": 200,
            "body": json.dumps({"result": result}),
        }
    except Exception as err:
        logger.error(err, exc_info=True)
        return {
            "statusCode": 503,
            "body": json.dumps({"error": str(err)}),
        }
