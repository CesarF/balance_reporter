FROM public.ecr.aws/lambda/python:3.11 as base
LABEL author="cesarf"
ARG POETRY_VERSION=1.5.1
WORKDIR /app

RUN pip install poetry==$POETRY_VERSION
RUN poetry config virtualenvs.create false
COPY poetry.lock pyproject.toml README.md ./
COPY src src

# handler run
FROM base as local
RUN poetry install --with local
CMD [ "src.main.local" ]

FROM base as prod
RUN poetry install --with aws
CMD [ "src.main.aws" ]

# automatic testing. e.g pipelines
FROM base as pytest
COPY tests tests
COPY setup.cfg ./
RUN poetry install --with local, aws, dev
ENTRYPOINT [ "pytest" ]
CMD [ "--cov=src", "-v", "-s", "--cov-fail-under=80", "--cov-report term-missing" ]
