from django.db import models
from django.core.exceptions import ValidationError
from django.core.files.base import ContentFile
import logging

logger = logging.getLogger(__name__)

from utils.findImage import parseImage
import check_media_files_after_upload


class Source(models.Model):
    source_name = models.CharField(blank=False, max_length=500, unique=True)
    def __str__(self):
        return self.source_name
    

class Quote(models.Model):
    logger.info(f"DB Model")
    text = models.CharField(blank=False, max_length=200, unique=True)
    likes = models.PositiveIntegerField(default=0)
    dislikes = models.PositiveIntegerField(default=0)
    weight = models.FloatField(blank=False)
    views_count = models.BigIntegerField(default=0)
    image = models.ImageField(upload_to='quotes/', blank=True, null=True)
    source = models.ForeignKey(Source, on_delete=models.CASCADE, blank=False, related_name='quotes')

    def save(self, *args, **kwargs):

        if not self.pk and not self.image:
            self.uploadImage()

        super().save(*args, **kwargs)

    def uploadImage(self):
        try:
            print(f"Image upload started")
            logger.info(f"Image upload started")
            parsed_image = parseImage(self.source)
            if parsed_image:

                print(f"Image upload end")
                img_name = f"quote_{self.source}.jpg"
                self.image.save(img_name, ContentFile(parsed_image), save=False)

                print(f"Image uploaded successfully!")
                print(f"Image name: {self.image.name}")
                print(f"Image path: {self.image.path}")
                print(f"Image URL: {self.image.url}")
                print(f"File exists: {os.path.exists(self.image.path)}")
                logger.info(f"Image uploaded: {self.image.name}")
                logger.info(f"Image path: {self.image.path}")

                self.check_media_files_after_upload()

        except Exception as e:
            logger.info(f"Error: {e}")

    def clean(self):
        if self.source.quotes.count() >= 3 and not self.pk:
            raise ValidationError("У источника не может быть больше 3 цитат.")

    def __str__(self):
        return f'Цитата из \"{self.source}\": {self.text[10:]}...'
