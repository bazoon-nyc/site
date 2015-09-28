from django.db import models
from django.contrib.auth.models import User
from django.contrib import admin

# Create your models here.
class Message(models.Model):
    name = models.CharField(max_length=500, blank=False, null=False)
    email = models.CharField(max_length=500, blank=False, null=False)
    message = models.TextField(max_length=5000, blank=False, null=False)
    date_created = models.DateTimeField(auto_now_add=True)
    date_updated = models.DateTimeField(auto_now=True)

    class Meta(object):
        ordering = ('date_updated', 'date_created',)

    def __unicode__(self):
        return "{name}".format(
            name=self.name
        )
