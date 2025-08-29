from django.urls import path
from django.conf import settings
from django.conf.urls.static import static

from . import views

urlpatterns = [
    path('', views.quote_list, name='quote_list'),
    path('/top', views.top_quote_list, name='top'),
    path('<int:quote_id>/', views.quote_detail, name='quote_detail'),
    path('<int:quote_id>/like/', views.like_quote, name='like_quote'),
    path('<int:quote_id>/dislike/', views.dislike_quote, name='dislike_quote'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)