"""
Implementation of an email handler for SES
"""
import logging

import boto3

from base.ports.email_handler import EmailHandler
from config import EMAIL_SENDER

logger = logging.getLogger(__name__)


class AWSEmailHandler(EmailHandler):
    """
    AWS SES handler implementation to send emails
    """

    def __init__(self):
        self.ses_client = boto3.client("ses")

    def send_email(
        self, message: str, recipient: str, subject: str, msg_format: str = "html"
    ) -> bool:
        """
        Send an email using SES
        """
        try:
            # Send the email
            response = self.ses_client.send_email(
                Destination={"ToAddresses": [recipient]},
                Message={
                    "Body": {
                        msg_format.capitalize(): {"Charset": "UTF-8", "Data": message}
                    },
                    "Subject": {"Charset": "UTF-8", "Data": subject},
                },
                Source=EMAIL_SENDER,
            )
            logging.info("Email sent successfully! Message ID:", response["MessageId"])
            return True
        except Exception as error:
            logging.error(error, exc_info=True)
            return False
