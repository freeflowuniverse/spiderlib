module stripeclient

import json

__global (
	client StripeClient
)

fn testsuite_begin() {
	client = StripeClient{
		sk_test: 'enter secret test key'
	}
}

fn test_decode_session() ! {
	session_str := '{
      "id": "cs_test_a1325uriHXR49pY4F6PYOvMZTkusSU7sOKFe3LicjZdslHJ6sjxdRaooO0",
      "object": "checkout.session",
      "after_expiration": null,
      "allow_promotion_codes": null,
      "amount_subtotal": 2000,
      "amount_total": 2000,
      "automatic_tax": {
        "enabled": false,
        "status": null
      },
      "billing_address_collection": null,
      "cancel_url": "http://localhost:8000/test_cancel_url",
      "client_reference_id": null,
      "consent": null,
      "consent_collection": null,
      "created": 1672321664,
      "currency": "usd",
      "custom_text": {
        "shipping_address": null,
        "submit": null
      },
      "customer": null,
      "customer_creation": "if_required",
      "customer_details": {
        "address": {
          "city": null,
          "country": "TR",
          "line1": null,
          "line2": null,
          "postal_code": null,
          "state": null
        },
        "email": "timurgordon@gmail.com",
        "name": "Timur Gordon",
        "phone": null,
        "tax_exempt": "none",
        "tax_ids": [

        ]
      },
      "customer_email": null,
      "expires_at": 1672408064,
      "invoice": null,
      "invoice_creation": {
        "enabled": false,
        "invoice_data": {
          "account_tax_ids": null,
          "custom_fields": null,
          "description": null,
          "footer": null,
          "metadata": {
          },
          "rendering_options": null
        }
      },
      "livemode": false,
      "locale": null,
      "metadata": {
      },
      "mode": "payment",
      "payment_intent": "pi_3MKMSxC7LG8OeRdI1hlcGMJK",
      "payment_link": null,
      "payment_method_collection": "always",
      "payment_method_options": {
      },
      "payment_method_types": [
        "card"
      ],
      "payment_status": "paid",
      "phone_number_collection": {
        "enabled": false
      },
      "recovered_from": null,
      "setup_intent": null,
      "shipping_address_collection": null,
      "shipping_cost": null,
      "shipping_details": null,
      "shipping_options": [

      ],
      "status": "complete",
      "submit_type": null,
      "subscription": null,
      "success_url": "http://localhost:8000/test_success_url",
      "total_details": {
        "amount_discount": 0,
        "amount_shipping": 0,
        "amount_tax": 0
      },
      "url": null
    }'
	session := json.decode(Session, session_str)!
	panic(';sesh ${session}')
}

fn test_create_session() {
	// create product for session
	product := client.create_product(name: 'test_product')!

	// create price for product
	price := client.create_price(
		nickname: 'test_price'
		currency: 'usd'
		active: true
		unit_amount: 1000
		product: product.id
	)!

	args := SessionArgs{
		cancel_url: 'http://localhost:8000/test_cancel_url'
		mode: 'payment'
		line_items: [
			LineItem{
				price: price.id
				quantity: 2
			},
		]
		success_url: 'http://localhost:8000/test_success_url'
	}

	// create session for product
	session := client.create_session(args)!
	panic('prod: ${session}')
}