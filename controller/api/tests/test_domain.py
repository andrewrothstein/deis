"""
Unit tests for the Deis api app.

Run the tests with "./manage.py test api"
"""

from __future__ import unicode_literals

import json

from django.contrib.auth.models import User
from django.test import TestCase
from rest_framework.authtoken.models import Token


class DomainTest(TestCase):

    """Tests creation of domains"""

    fixtures = ['tests.json']

    def setUp(self):
        self.user = User.objects.get(username='autotest')
        self.token = Token.objects.get(user=self.user).key
        url = '/v1/apps'
        response = self.client.post(url, HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 201)
        self.app_id = response.data['id']  # noqa

    def test_manage_domain(self):
        url = '/v1/apps/{app_id}/domains'.format(app_id=self.app_id)
        body = {'domain': 'test-domain.example.com'}
        response = self.client.post(url, json.dumps(body), content_type='application/json',
                                    HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 201)
        url = '/v1/apps/{app_id}/domains'.format(app_id=self.app_id)
        response = self.client.get(url, content_type='application/json',
                                   HTTP_AUTHORIZATION='token {}'.format(self.token))
        result = response.data['results'][0]
        self.assertEqual('test-domain.example.com', result['domain'])
        url = '/v1/apps/{app_id}/domains/{hostname}'.format(hostname='test-domain.example.com',
                                                            app_id=self.app_id)
        response = self.client.delete(url, content_type='application/json',
                                      HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 204)
        url = '/v1/apps/{app_id}/domains'.format(app_id=self.app_id)
        response = self.client.get(url, content_type='application/json',
                                   HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(0, response.data['count'])

    def test_manage_domain_invalid_app(self):
        url = '/v1/apps/{app_id}/domains'.format(app_id="this-app-does-not-exist")
        body = {'domain': 'test-domain.example.com'}
        response = self.client.post(url, json.dumps(body), content_type='application/json',
                                    HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 404)
        url = '/v1/apps/{app_id}/domains'.format(app_id='this-app-does-not-exist')
        response = self.client.get(url, content_type='application/json',
                                   HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 404)

    def test_manage_domain_invalid_domain(self):
        url = '/v1/apps/{app_id}/domains'.format(app_id=self.app_id)
        body = {'domain': 'this_is_an.invalid.domain'}
        response = self.client.post(url, json.dumps(body), content_type='application/json',
                                    HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 400)
        url = '/v1/apps/{app_id}/domains'.format(app_id=self.app_id)
        body = {'domain': 'this-is-an.invalid.a'}
        response = self.client.post(url, json.dumps(body), content_type='application/json',
                                    HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 400)
        url = '/v1/apps/{app_id}/domains'.format(app_id=self.app_id)
        body = {'domain': 'domain'}
        response = self.client.post(url, json.dumps(body), content_type='application/json',
                                    HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 400)

    def test_manage_domain_wildcard(self):
        """Wildcards are not allowed for now."""
        url = '/v1/apps/{app_id}/domains'.format(app_id=self.app_id)
        body = {'domain': '*.deis.example.com'}
        response = self.client.post(url, json.dumps(body), content_type='application/json',
                                    HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 400)

    def test_admin_can_add_domains_to_other_apps(self):
        """If a non-admin user creates an app, an administrator should be able to add
        domains to it.
        """
        user = User.objects.get(username='autotest2')
        token = Token.objects.get(user=user).key
        url = '/v1/apps'
        response = self.client.post(url, HTTP_AUTHORIZATION='token {}'.format(token))
        self.assertEqual(response.status_code, 201)
        url = '/v1/apps/{}/domains'.format(self.app_id)
        body = {'domain': 'example.deis.example.com'}
        response = self.client.post(url, json.dumps(body), content_type='application/json',
                                    HTTP_AUTHORIZATION='token {}'.format(self.token))
        self.assertEqual(response.status_code, 201)

    def test_unauthorized_user_cannot_modify_domain(self):
        """
        An unauthorized user should not be able to modify other domains.

        Since an unauthorized user should not know about the application at all, these
        requests should return a 404.
        """
        app_id = 'autotest'
        url = '/v1/apps'
        body = {'id': app_id}
        response = self.client.post(url, json.dumps(body), content_type='application/json',
                                    HTTP_AUTHORIZATION='token {}'.format(self.token))
        unauthorized_user = User.objects.get(username='autotest2')
        unauthorized_token = Token.objects.get(user=unauthorized_user).key
        url = '{}/{}/domains'.format(url, app_id)
        body = {'domain': 'example.com'}
        response = self.client.post(url, json.dumps(body), content_type='application/json',
                                    HTTP_AUTHORIZATION='token {}'.format(unauthorized_token))
        self.assertEqual(response.status_code, 403)
