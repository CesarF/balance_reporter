"""
Implementation of a database handler for local resources
"""
import json
import logging
import os

from pymongo import MongoClient

from base.ports.db_handler import DBHandler
from domain.models.account import Account

logger = logging.getLogger(__name__)


class LocalDBHandler(DBHandler):
    """
    Implementation of a database handler to store data in
    a mongo database
    """

    _COLLECTION: str = "accounts"
    _mongo_db_name: str = None
    _connection: object = None

    def __new__(cls):
        """
        Creates a singleton instance
        """
        if not hasattr(cls, "instance"):
            cls.instance = super(LocalDBHandler, cls).__new__(cls)
            cls.instance._connect()
        return cls.instance

    @classmethod
    def _get_uri(cls) -> str:
        """Generates connection url"""
        mongo_user = os.environ["MONGO_USER"]
        mongo_pass = os.environ["MONGO_PASSWORD"]
        mongo_host = os.environ["MONGO_HOST"]
        mongo_port = os.environ["MONGO_PORT"]
        cls._mongo_db_name = os.environ["MONGO_DB_NAME"]
        return f"mongodb://{mongo_user}:{mongo_pass}@{mongo_host}:{mongo_port}/{cls._mongo_db_name}?authSource={cls._mongo_db_name}"  # noqa: E231

    @classmethod
    def _connect(cls) -> str:
        """get current connection with the database"""
        if cls._connection is None:
            uri = cls._get_uri()
            client = MongoClient(uri)
            cls._connection = client[cls._mongo_db_name]
            logger.warning(f"[DB] Connection stablished with: {cls._connection.name}")

    def save(self, entity: Account) -> Account:
        """process event"""
        collection = self._connection[self._COLLECTION]
        response = collection.insert_one(json.loads(entity.json()))
        logger.warning(f"[DB] Inserted data {response}")
