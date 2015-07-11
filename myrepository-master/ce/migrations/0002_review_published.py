# encoding: utf8
from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ce', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='review',
            name='published',
            field=models.BooleanField(default=False),
            preserve_default=True,
        ),
    ]
