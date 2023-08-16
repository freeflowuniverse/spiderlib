# HTMX Module

Allows structured creation of htmx actions, rendering html for htmx actions, and prebuilt actions commonly used.

## Factories

`factories.v` contains functions that create `HTMX` structs for commonly used purposes.
- `navigate()`: creates HTMX for navigating to a provided `path`, in an HTMX `outlet`


## Examples

To run any example: `v run examples/<example>`. This will run the example at port 8080

### Navigation example

The navigation example is a very simple example of how dynamic (without full page refresh, replacing only main content) navigation can be achieved using the HTMX module. In the example, an HTMX code corresponding to how an outlet acts is created using `outlet_htmx := htmx.outlet(default: '/home')`. This outlet defaults to the /home path and as such the home page is displayed at `localhost:8080`. The `htmx.navigate()` function is used to add navigation buttons that can replace the main content.