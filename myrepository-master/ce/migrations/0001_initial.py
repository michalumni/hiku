# encoding: utf8
from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Supplier',
            fields=[
                (u'id', models.AutoField(verbose_name=u'ID', serialize=False, auto_created=True, primary_key=True)),
                ('supplierName', models.CharField(max_length=200)),
                ('supplierSlug', models.CharField(max_length=200)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Review',
            fields=[
                (u'id', models.AutoField(verbose_name=u'ID', serialize=False, auto_created=True, primary_key=True)),
                ('supplier', models.ForeignKey(to='ce.Supplier', to_field=u'id')),
                ('timeSubmitted', models.DateTimeField(verbose_name='date published')),
                ('rating', models.IntegerField()),
                ('authorName', models.CharField(max_length=200)),
                ('reviewContent', models.TextField()),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
