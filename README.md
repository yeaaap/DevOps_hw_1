# Домашнее задание № 1

Лебедев М.Е., БИСТ-23-ПО-3. Вариант 10.

Запуск приложения и MariaDB:

```bash
bash run.sh
```

Приложение: http://localhost:8030/me и http://localhost:8030/notes.
База использует именованный том `lebedev-10-data` и порт хоста 8032.
Повторный запуск пересоздаёт контейнеры и сохраняет заметки в томе.

Обновление приложения:

```bash
docker build --build-arg VERSION=2.1 -t lebedev-10/probe:2.1 .
docker rm -f lebedev-10-web
docker run -d --name lebedev-10-web -p 8030:5010 --add-host host.docker.internal:host-gateway -e MARKER=weblab -e DATABASE_URL=mysql://root:lab@host.docker.internal:8032/lab lebedev-10/probe:2.1
```

Базу при обновлении приложения пересоздавать не требуется.
