FROM REGISTRY/FROM_IMAGE:VERSION
MAINTAINER Artem Golub <artemgolub@gmail.com>

# Create directories.
RUN touch /var/log/django.log

# Start supervisor and run emperor.
ENTRYPOINT pip install -r /app/requirements/dev.txt && \
python /app/backend/manage.py collectstatic --noinput && \
python /app/backend/manage.py migrate && \
rm -rf /temp/uwsgi && \
mkdir -p /temp/uwsgi && \
ln -s /app/config/wsgi.ini /temp/uwsgi/ && \
uwsgi --emperor /temp/uwsgi/

EXPOSE 9000
