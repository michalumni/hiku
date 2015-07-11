from django.conf.urls import patterns, include, url
from django.contrib import admin
admin.autodiscover()
from ce import views

urlpatterns = patterns('',

    url(r'^admin/', include(admin.site.urls)),
    url(r'^$', views.index, name='index'),
    url(r'^reviews/$', views.reviews, name='reviews'),
    url(r'^reviews/(?P<slug>[a-zA-Z_]+)/$', views.slug, name='slug'),
    url(r'^reviews/(?P<slug>[a-zA-Z_]+)/write/$', views.write, name='slug')
                      

)
