ARG POETRY_VERSION=1.5.1

FROM python:3.11.6-slim as base
ARG POETRY_VERSION
LABEL author="cesarf" \
      version="local"
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

# automatic testing. e.g pipelines
FROM base as pytest
COPY tests tests
COPY setup.cfg ./
RUN poetry install --with local,aws,dev
ENTRYPOINT [ "pytest" ]
CMD [ "--cov=src", "-v", "-s" ]

FROM public.ecr.aws/lambda/python:3.11 as aws
ARG POETRY_VERSION
LABEL author="cesarf" \
      version="aws"
WORKDIR /app
COPY --from=base /app /app
RUN pip install poetry==$POETRY_VERSION
RUN poetry config virtualenvs.create false
RUN poetry install --with aws
CMD [ "entrypoints.aws.handler" ]
