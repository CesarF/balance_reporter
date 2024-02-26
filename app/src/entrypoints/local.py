"""
entrypoint to execute the application in the local environment
"""
import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from domain.adapters.db.local_db_handler import LocalDBHandler
from domain.adapters.email.local_email_handler import LocalEmailHandler
from domain.adapters.file.local_file_handler import LocalFileHandler
from domain.commands.balance_command import BalanceProcessorCommand

logger = logging.getLogger(__name__)
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

command = None


@app.on_event("startup")
def startup_event():
    logger.info("Starting analysis process")
    global command
    command = BalanceProcessorCommand(
        db_handler=LocalDBHandler(),
        file_handler=LocalFileHandler(),
        email_handler=LocalEmailHandler(),
    )


@app.post("/execute")
def execute():
    """
    Execute endpoint
    """
    global command
    result = command()
    return JSONResponse({"result": result})
