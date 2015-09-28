from rest_framework import serializers

from .models import Message


class MessageSerializer(serializers.Serializer):
    name = serializers.CharField(required=True, allow_blank=False, max_length=500)
    email = serializers.CharField(required=True, allow_blank=False, max_length=500)
    message = serializers.CharField(required=True, allow_blank=False, max_length=5000)

    class Meta:
        model = Message

    def create(self, validated_data):
        """Create and return a new `Message` instance, given the validated data."""
        return Message.objects.create(**validated_data)

    def update(self, instance, validated_data):
        """Update and return an existing `Message` instance, given the validated data."""
        instance.name = validated_data.get('name', instance.name)
        instance.email = validated_data.get('email', instance.email)
        instance.message = validated_data.get('message', instance.message)

        instance.save()

        return instance