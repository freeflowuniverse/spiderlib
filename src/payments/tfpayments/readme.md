# ThreeFold Payment API

To run:

```
v run /path/to/spiderlib/payments/api -sk <secret_key> -pk <publishable_key> -m <mneumonics>
```

where:

- sk and pk are stripe account's secret and publishable keys
- mneumonics is the mneumonics for the account imbursing the user for the mastadon server

Please ask Alexandre Hanellas for test and production keys.

To test the api locally use Stripe CLI. You may refer to [this guide]().

## Using the API

### Authentication

As the API is expected to be used only internally and for a few services, authentication is established through API keys that can be generated from the machine running the API.

After running the API, a simple command line interface will appear. One can generate a new API key for a host by entering the following prompt:

`add host <https://host>`

This command will generate and output an API Key for the provided host, and add the host-key pair to the database. This API Key can be revoked using the `remove host` prompt.

The API Key is expected to be passed in the authorization header of requests with the key 'Apikey'

### Endpoints

The API offers the following endpoints:

#### `[GET] /mastadon_payment_session`

The mastadon payment session endpoint expects the following parameters:

- cancel_url
- success_url
- quantity (number of months being purchased)
- twinid (twin id of account purchasing monthly server)
- webhook url (optional): The url at which the payment api will send an event notification upon fulfilling the mastodon order.

**Webhook**

The webhook event notification for mastodon order fulfillment is of the following JSON format:

```
{
    id string // order id returned with session creation
    fulfilled // boolean
    tx string // stellar transaction id of order fulfillment
}
```

#### `[GET] /ourphone_payment_session`

The ourphone payment session endpoint expects the following parameters:

- cancel_url
- success_url

Both endpoints return a url for the checkout session created on stripe, and an order id. On checkout completion, Stripe will redirect to one of the two urls provided.

## Payments

All payments are done through Stripe's API. Additionaly, the Threefold Payment API handles the fulfilling of orders following the confirmation of successful payments.

### Ourphone Payments

Ourphone payments are automatically taxed using Stripe's Tax API. Once checkout session is complete and payment is confirmed, the shipping details of the customer is sent to Ourphone team for handling shipping of the device.

### Mastadon Payments

Once checkout session is complete and mastadon server payment is confirmed, the account of the customer is funded for covering the fees of the server for the quantity of months purchased. The account is funded by the account of which the mneumonics are entered when running the Payment API. Freeflowuniverse/crystallib/twinclient is used for account transactions.
