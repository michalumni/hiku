from django.shortcuts import render
from django.http import HttpResponse
from ce.models import Supplier, Review
from django.template import RequestContext, loader, Context
from django.http import Http404
from reviewform import ReviewForm
from django.utils import timezone

#this page isn't in requirements but redirect to reviews
def index(request):
    template = loader.get_template('ce/index.html')
    context = RequestContext(request, {
    })
    return HttpResponse(template.render(context))

    
    
# get all the suppliers and display them send the list to the html
def reviews(request):
    supplier_list = Supplier.objects.all()
    template = loader.get_template('ce/reviews.html')
    context = RequestContext(request, {
        'supplier_list': supplier_list,
    })
    return HttpResponse(template.render(context))

def slug(request, slug):
    try:
        supplier = Supplier.objects.get(supplierSlug=slug)
    except Supplier.DoesNotExist:
        raise Http404

    mySupplier = Supplier.objects.get(supplierSlug=slug)

    #display only published reviews, in order from most recent first 
    myReviews = Review.objects.filter(supplier=mySupplier, published=True).order_by('-timeSubmitted')   

    template = loader.get_template('ce/slug.html')
    context = RequestContext(request, {
        'review_list': myReviews, 'supplier_list' : mySupplier,
    })
    return HttpResponse(template.render(context))

    
def write(request, slug):
    #grab supplier object from slug name
    mySupplier = Supplier.objects.get(supplierSlug=slug)
    
    if request.method == 'POST':
        form = ReviewForm(request.POST)
        if form.is_valid():
            myReview = Review(supplier=mySupplier, timeSubmitted=timezone.now(), rating=form.data['choice_field'],
                              authorName=form.data['authorName'], reviewContent=form.data['reviewContent'],
                              published = False)
            myReview.save()
            template = loader.get_template('ce/thanks.html')
            context = RequestContext(request, { 'supplier':mySupplier
                })
            return HttpResponse(template.render(context))


        else:
            template = loader.get_template('ce/write.html')
            context = RequestContext(request, { 'form':form, 'supplier':mySupplier
        })
            return HttpResponse(template.render(context))           
    else:
        #get request, load up an empty form and pass it into html
        form = ReviewForm()
        template = loader.get_template('ce/write.html')
        context = RequestContext(request, { 'form':form, 'supplier':mySupplier
    })
    return HttpResponse(template.render(context))



