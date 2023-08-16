# Basic TFConnect Example

This example uses `auth.tfconnect` module's `Authenticator` can be configured to create a login with TFConnect. The example demonstrates how the module can be used to create a TFConnect login url with specific [scopes](), how the callback from the login attempt can be handled and verified, and how TFConnect user scopes can be fetched from the callback.

## Configuring Authenticator

In the main function of the example, the `Authenticator` is configured the following way:

```
// create authenticator with correct configuration
authenticator := tfconnect.new(
    app_id: 'localhost:8080'
    callback: '/callback'
    scopes: tfconnect.Scopes{
        email: true // request email scope
    }
)!
```

Here:
- `app_id` defines the host of the application. This is used for redirecting to the application upon login attempt, and informs which app is using the TFConnect Login
- `callback` defines the route of the application which the login attempt will redirect to. This route must handle decoding and verifying the login attempt
- `scopes` define the user information scopes requested from TFConnect login. These can include email and identifier.

After the creation of the authenticator, the struct is simply passed into the VWeb Application's state.
```
// create and run app with authenticator
mut app := &TFConnectApp{
    authenticator: authenticator
}
vweb.run(app, 8080)
```

Note that in the example, the authenticator field holds the `[vweb_global]` attribute. This allows for the authenticator to keep it's configuration across multiple vweb threads

```
// Example vweb application with TFConnect Authenticator
struct TFConnectApp {
	vweb.Context
	authenticator tfconnect.TFConnect [vweb_global]
}
```

## Creating login url

Creating a login url is a single after the authenticator has been configured. 

`login_url := app.authenticator.create_login_url()`

Because the login url isn't always the same, it is a good idea to have your TFConnect login button request a constant `/login` route, which redirects to the generated login url, as demonstrated in the example.

## Handling Callback

The signed authentication attempt is passed to the applications callback route as a query. The `tfconnect` module provides a simple way to decode the signed attempt from the query with the function `load_signed_attempt`:

```
query := app.query.clone()
signed_attempt := tfconnect.load_signed_attempt(query) or {
    app.error('Could not load signed tfconnect login attempt')
    return app.server_error(400)
}
```

## Verifying Signed attempt and Fetching User Scopes

The TFConnect module provides a single function to both verify and return user scopes from a `SignedAttempt`:

```
res := app.authenticator.verify(signed_attempt) or {
    app.error('Could not verify signed tfconnect login attempt')
    return app.server_error(400)
}
return app.json(json.encode(res))
```

The function returns the user scopes in JSON Format.
