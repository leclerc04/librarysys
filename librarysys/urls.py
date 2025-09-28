"""
URL configuration for librarysys project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
# 路由配置

from django.contrib import admin
from django.urls import path
from . import views
from .LibraryModel import views as library_views



urlpatterns = [
    path('admin/', admin.site.urls),  # 后台管理路由
    # 可在此添加自定义路由，如：
    # path('blog/', include('blog.urls')),
    path("",views.hello,name="hello"),
    path("runoob/",views.runoob),
    path("book/save/",library_views.save_book),
    path("book/get/",library_views.get_books),
]