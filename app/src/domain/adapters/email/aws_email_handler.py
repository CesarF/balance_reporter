"""
Implementation of an email handler for SES
"""
from base.ports.email_handler import EmailHandler
from domain.models.account import Account


class AWSEmailHandler(EmailHandler):
    """
    AWS SES handler implementation to send emails
    """

    def send_email(self, entity: Account) -> bool:
        """
        Send an email using the entity information
        """
        entity
        raise NotImplementedError()
