"""
Implementation of an email handler for local executions
"""
import logging
import os
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from base.ports.email_handler import EmailHandler
from config import EMAIL_SENDER

logger = logging.getLogger(__name__)


class LocalEmailHandler(EmailHandler):
    """
    SMTP handler implementation to send emails
    """

    _password = os.environ["EMAIL_SENDER_PWD"]
    _smtp_server = os.environ["SMTP_SERVER"]
    _smtp_port = os.environ["SMTP_PORT"]

    def send_email(
        self, message: str, recipient: str, subject: str, msg_format: str = "html"
    ) -> bool:
        """
        Send an email using a SMTP server
        """
        msg = MIMEMultipart()
        msg["From"] = EMAIL_SENDER
        msg["To"] = recipient
        msg["Subject"] = subject

        # Attach message body
        msg.attach(MIMEText(message, msg_format))

        # Establish SMTP connection
        try:
            server = smtplib.SMTP(self._smtp_server, self._smtp_port)
            server.starttls()
            server.login(EMAIL_SENDER, self._password)
            # Send the email
            server.sendmail(EMAIL_SENDER, recipient, msg.as_string())
            logging.info("Email sent successfully!")
            return True
        except Exception as error:
            logging.error(error, exc_info=True)
            return False
        finally:
            # Close SMTP connection
            server.quit()
