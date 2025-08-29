from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

from random_quotes.views import HealthCheckView

urlpatterns = [
    path('random_quotes/', include('random_quotes.urls')),
    path('admin/', admin.site.urls),
    path('health/', HealthCheckView.as_view(), name='health-check')
]  + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)