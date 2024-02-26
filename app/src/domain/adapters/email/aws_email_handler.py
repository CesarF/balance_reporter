"""
Implementation of an email handler for SES
"""
from base.ports.email_handler import EmailHandler


class AWSEmailHandler(EmailHandler):
    """
    AWS SES handler implementation to send emails
    """

    def send_email(
        self, message: str, recipient: str, subject: str, msg_format: str = "html"
    ) -> bool:
        """
        Send an email using the entity information
        """
        raise NotImplementedError()
