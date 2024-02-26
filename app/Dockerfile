# FROM public.ecr.aws/lambda/python:3.11 as base
FROM python:3.11.6-slim as base
LABEL author="cesarf"
ARG POETRY_VERSION=1.5.1
WORKDIR /app

RUN pip install poetry==$POETRY_VERSION
RUN poetry config virtualenvs.create false
COPY poetry.lock pyproject.toml /app/
COPY src /app/src

# handler run
FROM base as local
RUN mkdir /app/data
RUN poetry install --with local
CMD ["uvicorn", "src.entrypoints.local:app", "--host", "0.0.0.0", "--port", "8080"]

FROM base as prod
RUN poetry install --with aws
CMD [ "main.aws" ]

# automatic testing. e.g pipelines
FROM base as pytest
COPY tests tests
COPY setup.cfg ./
RUN poetry install --with local,aws,dev
ENTRYPOINT [ "pytest" ]
CMD [ "--cov=src", "-v", "-s" ]
