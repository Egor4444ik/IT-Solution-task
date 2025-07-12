from django.shortcuts import render, get_object_or_404, redirect
from .models import Quote

import logging

logger = logging.getLogger(__name__)

def top_quote_list(request):
    quotes = Quote.objects.all().order_by('-likes')
    current_quotes = quotes[10:] if len(quotes)>10 else quotes
    return render(request, 'random_quotes/top.html', {'quotes': current_quotes})

def quote_list(request):
    quotes = Quote.objects.all().order_by('-weight')
    return render(request, 'random_quotes/index.html', {'quotes': quotes})

def quote_detail(request, quote_id):
    quote = get_object_or_404(Quote, pk=quote_id)
    quote.views_count += 1
    quote.save()
    return render(request, 'random_quotes/detail.html', {'quote': quote})

def like_quote(request, quote_id):
    quote = get_object_or_404(Quote, pk=quote_id)
    quote.likes += 1
    quote.save()
    return redirect('quote_detail', quote_id=quote.id)

def dislike_quote(request, quote_id):
    quote = get_object_or_404(Quote, pk=quote_id)
    quote.dislikes += 1
    quote.save()
    return redirect('quote_detail', quote_id=quote.id)