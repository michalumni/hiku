from django.forms import ModelForm
from django import forms
from ce.models import Review
import re

# Create the form class.
class ReviewForm(ModelForm):
    CHOICES = ((1, '1 Poor',), (2, '2 Fair',), (3, '3 Average',), (4,'4 Good'), (5,'5 Excellent'))
    choice_field = forms.ChoiceField(widget=forms.Select, choices=CHOICES)    
    class Meta:
        model = Review
        fields = [ 'authorName', 'reviewContent']

    def clean_authorName(self):
        an = self.cleaned_data['authorName']

        p = re.compile( '[a-zA-z]+ [a-zA-z]+' )
        m = p.match(an)
        if m:
            return an
        else:
            raise forms.ValidationError('Not a valid name')




 
