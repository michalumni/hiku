from django.contrib import admin
from ce.models import Review, Supplier



 
class ReviewAdmin(admin.ModelAdmin):
    readonly_fields=('supplier', 'timeSubmitted', 'rating', 'authorName', 'reviewContent')
    fields = ['supplier', 'timeSubmitted', 'rating', 'authorName', 'reviewContent', 'published']
    list_display = ('supplier',)
    def has_add_permission(self, request):
        return False

    def supplier(self, instance):
        return instance.supplier.supplierName


class ReviewInline(admin.TabularInline):
    model = Review
    readonly_fields = ('supplier', 'timeSubmitted', 'rating', 'authorName', 'reviewContent')

    def has_add_permission(self, request):
        return False


class SupplierAdmin(admin.ModelAdmin):
    inlines = [ReviewInline,]
    list_display = ('supplierName',)


admin.site.register(Supplier, SupplierAdmin)
admin.site.register(Review, ReviewAdmin)
# Register your models here.
