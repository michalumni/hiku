from django.test import TestCase
from ce.models import Review, Supplier
from django.utils import timezone
from time import sleep

# Create your tests here.
class CeViewsTestCase(TestCase):
	def test_reviews(self):
		#we create a supplier
		supplier = Supplier.objects.create(supplierName='Con Edison', supplierSlug='CON_ED')
		resp = self.client.get('/reviews/')
		self.assertEqual(resp.status_code, 200)
		
		#check to see if supplier list (containing our one supplier is in the reviews page)
		self.assertTrue('supplier_list' in resp.context)
		
		#get the first supplier
		sup1 = resp.context['supplier_list'][0]
		
		#see if its the same as the one we created earlier
		self.assertEqual(supplier, sup1)

	def test_slug(self):
		
		#load a slug that doesn't yet exist should return 404
		resp = self.client.get('/reviews/CON_ED/')
		self.assertEqual(resp.status_code, 404)

		#create the supplier then load slug should be fine
		supplier = Supplier.objects.create(supplierName='Con Edison', supplierSlug='CON_ED')
		resp = self.client.get('/reviews/CON_ED/')
		self.assertEqual(resp.status_code, 200)

		#there should be no reviews in this list, so a list of length 0
		self.assertTrue('review_list' in resp.context)
		self.assertTrue(len(resp.context['review_list']) == 0)

		#lets create a review with our supplier con edison and add it to the list but lets not make it published

		review = Review(supplier=supplier, rating=5, authorName='Jason Starks', reviewContent='fake review',
						timeSubmitted=timezone.now(), published=False)
		review.save()
		#now reload the page
		resp = self.client.get('/reviews/CON_ED/')

		#there should still be no reviews since published was false
		self.assertTrue('review_list' in resp.context)
		self.assertTrue(len(resp.context['review_list']) == 0)

		#ok so now , lets make sure we do display this review when it is published.
		review.published = True
		review.save()
		#sleep(1)
		#now reload the page, we should see 1 review
		resp = self.client.get('/reviews/CON_ED/')
		self.assertTrue('review_list' in resp.context)
		self.assertTrue(len(resp.context['review_list']) == 1)

		#perfect now lets make another review, save it and test the order, the most recent review should be first
		review2 = Review(supplier=supplier, rating=4, authorName='Florence Nightingale', reviewContent='fake review2',
						timeSubmitted=timezone.now(), published=True)
		review2.save()

		#reload the page again now we should have 2 reviews
		resp = self.client.get('/reviews/CON_ED/')
		self.assertTrue('review_list' in resp.context)
		self.assertTrue(len(resp.context['review_list']) == 2)

		#the first review should be the latest one so review2
		self.assertTrue(resp.context['review_list'][0] == review2)






