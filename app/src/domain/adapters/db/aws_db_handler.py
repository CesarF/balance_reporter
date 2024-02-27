"""
Implementation of a database handler for AWS
"""
import json
import logging
import os

import boto3

from base.ports.db_handler import DBHandler
from domain.models.account import Account
from errors import DatabaseException

logger = logging.getLogger(__name__)


class AWSDBHandler(DBHandler):
    """
    Represents a handler to manage database connections
    and operations
    """

    _DYNAMO_TABLE = os.environ["DYNAMO_TABLE"]

    def __init__(self):
        self.dynamodb_client = boto3.resource("dynamodb")

    def save(self, entity: Account) -> Account:
        """
        Stores the data in dynamodb
        """
        try:
            table = self.dynamodb_client.Table(self._DYNAMO_TABLE)

            # Store data in DynamoDB table
            table.put_item(Item={"Id": entity.id, "Data": json.loads(entity.json())})
            return entity
        except Exception as err:
            logger.error(err, exc_info=True)
            raise DatabaseException()
