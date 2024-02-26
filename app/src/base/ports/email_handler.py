"""
Resources to implement a email sender handler
"""
from abc import ABC, abstractmethod


class EmailHandler(ABC):
    """
    Represents a handler to send emails
    """

    @abstractmethod
    def send_email(
        self, message: str, recipient: str, subject: str, msg_format: str = "html"
    ) -> bool:
        """
        abstract function to send email
        """
        raise NotImplementedError()
