FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENV APP_PORT=5010
ENV PYTHONDONTWRITEBYTECODE=1
EXPOSE 5010
ENV MARKER=weblab
ARG VERSION=dev
RUN echo "$VERSION" > /app/VERSION
CMD ["python", "app.py"]
