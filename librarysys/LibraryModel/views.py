from django.shortcuts import render
from .models import Book
from django.http import HttpResponse


def save_book(request):
    Book.objects.create(
        name=request.POST['name'],
        author=request.POST['author'],
        publisher=request.POST['publisher'],
        publication_date=request.POST['publication_date'],
        price=request.POST['price'],
        stock=request.POST['stock'],
    )
    return HttpResponse("<p>Book saved successfully!</p>")


def get_books(request):
    print('bushigeen')
    books = Book.objects.all()
    return HttpResponse(books)
    # books = Book.objects.all().values()
    # return JsonResponse(list(books), safe=False)
